import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';

abstract class OpportunityRepository {
  Stream<OpportunitiesSnapshot> watchOpportunities();

  Stream<OpportunitySnapshot> watchOpportunity(String id);

  Future<void> apply({
    required String opportunityId,
    required String studentId,
  });

  Stream<bool> watchHasApplied({
    required String opportunityId,
    required String studentId,
  });
}

abstract class BookmarkRepository {
  Stream<Set<String>> watchBookmarkedIds(String userId);

  Future<void> toggleBookmark({
    required String userId,
    required String opportunityId,
  });
}
