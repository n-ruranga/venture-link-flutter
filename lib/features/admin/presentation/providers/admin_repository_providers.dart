import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/features/admin/data/datasources/firestore_admin_datasource.dart';
import 'package:venture_link/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:venture_link/features/admin/domain/repositories/admin_repository.dart';

final firestoreAdminDatasourceProvider =
    Provider<FirestoreAdminDatasource>((ref) {
  return FirestoreAdminDatasource(FirebaseFirestore.instance);
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(firestoreAdminDatasourceProvider));
});
