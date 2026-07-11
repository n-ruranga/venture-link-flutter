import 'package:venture_link/features/opportunities/data/datasources/firestore_bookmark_datasource.dart';
import 'package:venture_link/features/opportunities/data/datasources/firestore_opportunity_datasource.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/domain/repositories/opportunity_repository.dart';
import 'package:venture_link/features/startup/domain/entities/opportunity_input.dart';

class OpportunityRepositoryImpl implements OpportunityRepository {
  OpportunityRepositoryImpl(this.datasource);

  final FirestoreOpportunityDatasource datasource;

  @override
  Stream<OpportunitiesSnapshot> watchOpportunities() {
    return datasource.watchOpportunities();
  }

  @override
  Stream<OpportunitySnapshot> watchOpportunity(String id) {
    return datasource.watchOpportunity(id);
  }

  @override
  Stream<OpportunitiesSnapshot> watchStartupOpportunities(String startupId) {
    return datasource.watchStartupOpportunities(startupId);
  }

  @override
  Future<String> createOpportunity({
    required String startupId,
    required String startupName,
    required bool startupIsVerified,
    required OpportunityInput input,
  }) {
    return datasource.createOpportunity(
      startupId: startupId,
      startupName: startupName,
      startupIsVerified: startupIsVerified,
      input: input,
    );
  }

  @override
  Future<void> updateOpportunity({
    required String opportunityId,
    required String startupId,
    required OpportunityInput input,
  }) {
    return datasource.updateOpportunity(
      opportunityId: opportunityId,
      startupId: startupId,
      input: input,
    );
  }

  @override
  Future<void> deleteOpportunity({
    required String opportunityId,
    required String startupId,
  }) {
    return datasource.deleteOpportunity(
      opportunityId: opportunityId,
      startupId: startupId,
    );
  }
}

class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl(this.datasource);

  final FirestoreBookmarkDatasource datasource;

  @override
  Stream<Set<String>> watchBookmarkedIds(String userId) {
    return datasource.watchBookmarkedIds(userId);
  }

  @override
  Future<void> toggleBookmark({
    required String userId,
    required String opportunityId,
  }) {
    return datasource.toggleBookmark(
      userId: userId,
      opportunityId: opportunityId,
    );
  }
}
