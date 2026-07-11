import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venture_link/features/profile/data/models/user_model.dart';

class FirestoreAdminDatasource {
  FirestoreAdminDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Stream<List<UserModel>> watchUsers() {
    return _usersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> updateUserVerification({
    required String uid,
    required bool isVerified,
  }) async {
    await _usersCollection.doc(uid).update({
      'isVerified': isVerified,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserRole({
    required String uid,
    required String role,
  }) async {
    await _usersCollection.doc(uid).update({
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
