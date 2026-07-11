import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';

abstract class OpportunityRepository {
  Stream<OpportunitiesSnapshot> watchOpportunities();

  Stream<OpportunitySnapshot> watchOpportunity(String id);
}

abstract class BookmarkRepository {
  Stream<Set<String>> watchBookmarkedIds(String userId);

  Future<void> toggleBookmark({
    required String userId,
    required String opportunityId,
  });
}
