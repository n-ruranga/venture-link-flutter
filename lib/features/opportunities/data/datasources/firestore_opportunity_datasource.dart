import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venture_link/core/constants/opportunity_strings.dart';
import 'package:venture_link/features/opportunities/data/models/opportunity_model.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';

class FirestoreOpportunityDatasource {
  FirestoreOpportunityDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('opportunities');

  CollectionReference<Map<String, dynamic>> get _applicationsCollection =>
      _firestore.collection('applications');

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

  Future<void> apply({
    required String opportunityId,
    required String studentId,
  }) async {
    final existing = await _applicationsCollection
        .where('studentId', isEqualTo: studentId)
        .where('opportunityId', isEqualTo: opportunityId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw StateError(OpportunityStrings.alreadyApplied);
    }

    await _applicationsCollection.add({
      'studentId': studentId,
      'opportunityId': opportunityId,
      'status': 'applied',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<bool> watchHasApplied({
    required String opportunityId,
    required String studentId,
  }) {
    return _applicationsCollection
        .where('studentId', isEqualTo: studentId)
        .where('opportunityId', isEqualTo: opportunityId)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
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
