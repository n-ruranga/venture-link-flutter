import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/startup/domain/entities/opportunity_input.dart';

abstract class OpportunityRepository {
  Stream<OpportunitiesSnapshot> watchOpportunities();

  Stream<OpportunitySnapshot> watchOpportunity(String id);

  Stream<OpportunitiesSnapshot> watchStartupOpportunities(String startupId);

  Future<String> createOpportunity({
    required String startupId,
    required String startupName,
    required bool startupIsVerified,
    required OpportunityInput input,
  });

  Future<void> updateOpportunity({
    required String opportunityId,
    required String startupId,
    required OpportunityInput input,
  });

  Future<void> deleteOpportunity({
    required String opportunityId,
    required String startupId,
  });

  Future<void> syncStartupName({
    required String startupId,
    required String startupName,
  });
}

abstract class BookmarkRepository {
  Stream<Set<String>> watchBookmarkedIds(String userId);

  Future<void> toggleBookmark({
    required String userId,
    required String opportunityId,
  });
}
