import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venture_link/core/constants/opportunity_strings.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/features/opportunities/data/models/opportunity_model.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/startup/domain/entities/opportunity_input.dart';

class FirestoreOpportunityDatasource {
  FirestoreOpportunityDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('opportunities');

  Stream<OpportunitiesSnapshot> watchOpportunities() {
    return _collection
        .where('status', isEqualTo: OpportunityStatus.active.value)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapOpportunitiesSnapshot);
  }

  Stream<OpportunitySnapshot> watchOpportunity(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return OpportunitySnapshot(
          isFromCache: snapshot.metadata.isFromCache,
          hasPendingWrites: snapshot.metadata.hasPendingWrites,
        );
      }

      return OpportunitySnapshot(
        opportunity: OpportunityModel.fromFirestore(snapshot).toEntity(),
        isFromCache: snapshot.metadata.isFromCache,
        hasPendingWrites: snapshot.metadata.hasPendingWrites,
      );
    });
  }

  Stream<OpportunitiesSnapshot> watchStartupOpportunities(String startupId) {
    return _collection
        .where('startupId', isEqualTo: startupId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(_mapAllOpportunitiesSnapshot);
  }

  Future<String> createOpportunity({
    required String startupId,
    required String startupName,
    required bool startupIsVerified,
    required OpportunityInput input,
  }) async {
    if (!startupIsVerified) {
      throw StateError(StartupStrings.notVerified);
    }

    final doc = await _collection.add({
      'title': input.title.trim(),
      'description': input.description.trim(),
      'startupId': startupId,
      'startupName': startupName,
      'skills': input.skills,
      'location': input.location.trim(),
      'workMode': input.workMode.label,
      'category': input.category.label,
      'hoursPerWeek': input.hoursPerWeek.trim(),
      'deadline': Timestamp.fromDate(input.deadline),
      'status': OpportunityStatus.active.value,
      'isVerified': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  Future<void> updateOpportunity({
    required String opportunityId,
    required String startupId,
    required OpportunityInput input,
  }) async {
    await _assertOwnership(opportunityId: opportunityId, startupId: startupId);

    await _collection.doc(opportunityId).update({
      'title': input.title.trim(),
      'description': input.description.trim(),
      'skills': input.skills,
      'location': input.location.trim(),
      'workMode': input.workMode.label,
      'category': input.category.label,
      'hoursPerWeek': input.hoursPerWeek.trim(),
      'deadline': Timestamp.fromDate(input.deadline),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteOpportunity({
    required String opportunityId,
    required String startupId,
  }) async {
    await _assertOwnership(opportunityId: opportunityId, startupId: startupId);
    await _collection.doc(opportunityId).update({
      'status': OpportunityStatus.closed.value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> syncStartupName({
    required String startupId,
    required String startupName,
  }) async {
    final snapshot = await _collection
        .where('startupId', isEqualTo: startupId)
        .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'startupName': startupName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> _assertOwnership({
    required String opportunityId,
    required String startupId,
  }) async {
    final doc = await _collection.doc(opportunityId).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError(StartupStrings.updateError);
    }
    if (doc.data()!['startupId'] != startupId) {
      throw StateError(StartupStrings.unauthorized);
    }
  }

  OpportunitiesSnapshot _mapAllOpportunitiesSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final opportunities = snapshot.docs
        .map((doc) => OpportunityModel.fromFirestore(doc).toEntity())
        .toList();

    return OpportunitiesSnapshot(
      opportunities: opportunities,
      isFromCache: snapshot.metadata.isFromCache,
      hasPendingWrites: snapshot.metadata.hasPendingWrites,
    );
  }

  OpportunitiesSnapshot _mapOpportunitiesSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final opportunities = snapshot.docs
        .map((doc) => OpportunityModel.fromFirestore(doc).toEntity())
        .where((opportunity) => opportunity.isActive)
        .toList();

    return OpportunitiesSnapshot(
      opportunities: opportunities,
      isFromCache: snapshot.metadata.isFromCache,
      hasPendingWrites: snapshot.metadata.hasPendingWrites,
    );
  }
}
