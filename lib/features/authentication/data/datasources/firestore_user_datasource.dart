import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venture_link/features/authentication/data/models/user_model.dart';

class FirestoreUserDatasource {
  FirestoreUserDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toFirestore());
  }

  Future<UserModel?> getUser(String uid) async {
    final document = await _usersCollection.doc(uid).get();
    if (!document.exists || document.data() == null) {
      return null;
    }
    return UserModel.fromFirestore(document.data()!, uid);
  }

  Future<void> updateEmailVerified(String uid, bool isVerified) async {
    await _usersCollection.doc(uid).update({'isEmailVerified': isVerified});
  }
}
