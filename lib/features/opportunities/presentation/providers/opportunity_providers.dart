import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_repository_providers.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';

final opportunitiesStreamProvider =
    StreamProvider<OpportunitiesSnapshot>((ref) {
  return ref.watch(opportunityRepositoryProvider).watchOpportunities();
});

final opportunityStreamProvider =
    StreamProvider.family<OpportunitySnapshot, String>((ref, id) {
  return ref.watch(opportunityRepositoryProvider).watchOpportunity(id);
});

final bookmarkedIdsStreamProvider = StreamProvider<Set<String>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value({});
  }
  return ref.watch(bookmarkRepositoryProvider).watchBookmarkedIds(userId);
});

final opportunityCategoriesProvider =
    Provider<List<OpportunityCategory>>((ref) {
  return OpportunityCategory.values;
});

final homeSearchQueryProvider = StateProvider<String>((ref) => '');

final exploreSearchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider =
    StateProvider<OpportunityCategory?>((ref) => null);

final showBookmarksOnlyProvider = StateProvider<bool>((ref) => false);

final opportunitiesListProvider = Provider<List<OpportunityEntity>>((ref) {
  final snapshot = ref.watch(opportunitiesStreamProvider);
  return snapshot.maybeWhen(
    data: (data) => data.opportunities,
    orElse: () => const [],
  );
});

final isOpportunitiesOfflineProvider = Provider<bool>((ref) {
  final snapshot = ref.watch(opportunitiesStreamProvider);
  return snapshot.maybeWhen(
    data: (data) => data.isOffline,
    orElse: () => false,
  );
});

final featuredOpportunitiesProvider = Provider<List<OpportunityEntity>>((ref) {
  final opportunities = ref.watch(opportunitiesListProvider);
  final featured = opportunities.where((item) => item.isFeatured).toList();
  if (featured.isNotEmpty) {
    return featured;
  }
  return opportunities.take(3).toList();
});

final filteredOpportunitiesProvider =
    Provider<List<OpportunityEntity>>((ref) {
  final opportunities = ref.watch(opportunitiesListProvider);
  final query = ref.watch(homeSearchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final bookmarksOnly = ref.watch(showBookmarksOnlyProvider);
  final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).value ?? {};

  return _filterOpportunities(
    opportunities: opportunities,
    query: query,
    category: category,
    bookmarksOnly: bookmarksOnly,
    bookmarkedIds: bookmarkedIds,
  );
});

final exploreFilteredOpportunitiesProvider =
    Provider<List<OpportunityEntity>>((ref) {
  final opportunities = ref.watch(opportunitiesListProvider);
  final query = ref.watch(exploreSearchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final bookmarksOnly = ref.watch(showBookmarksOnlyProvider);
  final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).value ?? {};

  return _filterOpportunities(
    opportunities: opportunities,
    query: query,
    category: category,
    bookmarksOnly: bookmarksOnly,
    bookmarkedIds: bookmarkedIds,
  );
});

final bookmarkedOpportunitiesProvider = Provider<List<OpportunityEntity>>((ref) {
  final opportunities = ref.watch(opportunitiesListProvider);
  final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).value ?? {};
  return opportunities
      .where((opportunity) => bookmarkedIds.contains(opportunity.id))
      .toList();
});

List<OpportunityEntity> _filterOpportunities({
  required List<OpportunityEntity> opportunities,
  required String query,
  required OpportunityCategory? category,
  required bool bookmarksOnly,
  required Set<String> bookmarkedIds,
}) {
  var results = opportunities;

  if (bookmarksOnly) {
    results = results
        .where((opportunity) => bookmarkedIds.contains(opportunity.id))
        .toList();
  }

  if (category != null) {
    results =
        results.where((opportunity) => opportunity.category == category).toList();
  }

  if (query.isNotEmpty) {
    results = results.where((opportunity) {
      return opportunity.title.toLowerCase().contains(query) ||
          opportunity.startupName.toLowerCase().contains(query) ||
          opportunity.skills.any((skill) => skill.toLowerCase().contains(query)) ||
          opportunity.category.label.toLowerCase().contains(query) ||
          opportunity.location.toLowerCase().contains(query);
    }).toList();
  }

  return results;
}

final bookmarkToggleProvider =
    AsyncNotifierProvider<BookmarkToggleNotifier, void>(
  BookmarkToggleNotifier.new,
);

class BookmarkToggleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggle(String opportunityId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(bookmarkRepositoryProvider).toggleBookmark(
            userId: userId,
            opportunityId: opportunityId,
          );
    });
  }
}
