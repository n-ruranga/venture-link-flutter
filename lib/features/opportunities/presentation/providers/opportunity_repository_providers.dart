import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/features/opportunities/data/datasources/firestore_bookmark_datasource.dart';
import 'package:venture_link/features/opportunities/data/datasources/firestore_opportunity_datasource.dart';
import 'package:venture_link/features/opportunities/data/repositories/opportunity_repository_impl.dart';
import 'package:venture_link/features/opportunities/domain/repositories/opportunity_repository.dart';

final firestoreOpportunityDatasourceProvider =
    Provider<FirestoreOpportunityDatasource>((ref) {
  return FirestoreOpportunityDatasource(FirebaseFirestore.instance);
});

final firestoreBookmarkDatasourceProvider =
    Provider<FirestoreBookmarkDatasource>((ref) {
  return FirestoreBookmarkDatasource(FirebaseFirestore.instance);
});

final opportunityRepositoryProvider = Provider<OpportunityRepository>((ref) {
  return OpportunityRepositoryImpl(
    ref.watch(firestoreOpportunityDatasourceProvider),
  );
});

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(
    ref.watch(firestoreBookmarkDatasourceProvider),
  );
});
