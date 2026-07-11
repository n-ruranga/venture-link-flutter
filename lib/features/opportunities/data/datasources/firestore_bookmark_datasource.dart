import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreBookmarkDatasource {
  FirestoreBookmarkDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _savedCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('saved');
  }

  Stream<Set<String>> watchBookmarkedIds(String userId) {
    return _savedCollection(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  Future<void> toggleBookmark({
    required String userId,
    required String opportunityId,
  }) async {
    final docRef = _savedCollection(userId).doc(opportunityId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
      return;
    }

    await docRef.set({
      'opportunityId': opportunityId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
