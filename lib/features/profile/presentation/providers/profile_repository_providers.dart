import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_repository_providers.dart';
import 'package:venture_link/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:venture_link/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:venture_link/features/profile/domain/repositories/profile_repository.dart';

final firestoreProfileDatasourceProvider =
    Provider<FirestoreProfileDatasource>((ref) {
  return FirestoreProfileDatasource(FirebaseFirestore.instance);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    datasource: ref.watch(firestoreProfileDatasourceProvider),
    opportunityRepository: ref.watch(opportunityRepositoryProvider),
  );
});
