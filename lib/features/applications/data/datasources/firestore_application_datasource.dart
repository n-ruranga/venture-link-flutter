import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/features/applications/data/models/application_model.dart';
import 'package:venture_link/features/applications/domain/entities/application_entity.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';

class FirestoreApplicationDatasource {
  FirestoreApplicationDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('applications');

  Stream<ApplicationsSnapshot> watchStudentApplications(String studentId) {
    return _collection
        .where('studentId', isEqualTo: studentId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(_mapSnapshot);
  }

  Stream<ApplicationsSnapshot> watchStartupApplications(String startupId) {
    return _collection
        .where('startupId', isEqualTo: startupId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(_mapSnapshot);
  }

  Stream<ApplicationEntity?> watchStudentApplicationForOpportunity({
    required String studentId,
    required String opportunityId,
  }) {
    return _collection
        .where('studentId', isEqualTo: studentId)
        .where('opportunityId', isEqualTo: opportunityId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return ApplicationModel.fromFirestore(snapshot.docs.first).toEntity();
    });
  }

  Stream<ApplicationEntity?> watchApplication(String applicationId) {
    return _collection.doc(applicationId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return ApplicationModel.fromFirestore(snapshot).toEntity();
    });
  }

  Future<void> apply({
    required String studentId,
    required String opportunityId,
    required String startupId,
    required String coverLetter,
    String? resumeUrl,
  }) async {
    final existing = await _collection
        .where('studentId', isEqualTo: studentId)
        .where('opportunityId', isEqualTo: opportunityId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw StateError(ApplicationStrings.alreadyApplied);
    }

    await _collection.add({
      'studentId': studentId,
      'opportunityId': opportunityId,
      'startupId': startupId,
      'status': ApplicationStatus.applied.value,
      'coverLetter': coverLetter.trim(),
      if (resumeUrl != null && resumeUrl.trim().isNotEmpty)
        'resumeUrl': resumeUrl.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> withdraw({
    required String applicationId,
    required String studentId,
  }) async {
    final doc = await _collection.doc(applicationId).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError(ApplicationStrings.withdrawError);
    }

    final data = doc.data()!;
    if (data['studentId'] != studentId) {
      throw StateError(ApplicationStrings.withdrawError);
    }

    final status = ApplicationStatus.fromString(data['status'] as String?);
    if (!status.canWithdraw) {
      throw StateError(ApplicationStrings.cannotWithdraw);
    }

    await _collection.doc(applicationId).delete();
  }

  Future<void> updateStatus({
    required String applicationId,
    required ApplicationStatus status,
  }) async {
    await _collection.doc(applicationId).update({
      'status': status.value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  ApplicationsSnapshot _mapSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final applications = snapshot.docs
        .map((doc) => ApplicationModel.fromFirestore(doc).toEntity())
        .toList();

    return ApplicationsSnapshot(
      applications: applications,
      isFromCache: snapshot.metadata.isFromCache,
    );
  }
}
