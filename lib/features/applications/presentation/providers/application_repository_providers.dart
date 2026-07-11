import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/features/applications/data/datasources/firestore_application_datasource.dart';
import 'package:venture_link/features/applications/data/repositories/application_repository_impl.dart';
import 'package:venture_link/features/applications/domain/repositories/application_repository.dart';

final firestoreApplicationDatasourceProvider =
    Provider<FirestoreApplicationDatasource>((ref) {
  return FirestoreApplicationDatasource(FirebaseFirestore.instance);
});

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepositoryImpl(
    ref.watch(firestoreApplicationDatasourceProvider),
  );
});
