import 'package:venture_link/features/opportunities/data/datasources/firestore_bookmark_datasource.dart';
import 'package:venture_link/features/opportunities/data/datasources/firestore_opportunity_datasource.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/domain/repositories/opportunity_repository.dart';

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
