import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venture_link/features/profile/data/models/user_model.dart';

class FirestoreProfileDatasource {
  FirestoreProfileDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<void> createProfile(UserModel user) async {
    await _usersCollection.doc(user.uid).set({
      'uid': user.uid,
      ...user.toFirestore(),
    });
  }

  Future<UserModel?> getProfile(String uid) async {
    final document = await _usersCollection.doc(uid).get();
    if (!document.exists || document.data() == null) {
      return null;
    }
    return UserModel.fromFirestore(document.data()!, uid);
  }

  Stream<UserModel?> watchProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return UserModel.fromFirestore(snapshot.data()!, uid);
    });
  }

  Future<void> updateProfile(UserModel user) async {
    await _usersCollection.doc(user.uid).update({
      ...user.toFirestore(),
      'updatedAt': Timestamp.fromDate(user.updatedAt),
    });
  }

  Future<void> updateEmailVerified(String uid, bool isVerified) async {
    await _usersCollection.doc(uid).update({
      'isEmailVerified': isVerified,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
