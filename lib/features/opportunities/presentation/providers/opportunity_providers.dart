import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/features/opportunities/data/datasources/mock_opportunities_data.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';

final opportunitiesProvider = Provider<List<OpportunityEntity>>((ref) {
  return MockOpportunitiesData.opportunities;
});

final featuredOpportunitiesProvider = Provider<List<OpportunityEntity>>((ref) {
  return MockOpportunitiesData.featured;
});

final recentOpportunitiesProvider = Provider<List<OpportunityEntity>>((ref) {
  return MockOpportunitiesData.recent;
});

final opportunityCategoriesProvider =
    Provider<List<OpportunityCategory>>((ref) {
  return OpportunityCategory.values;
});

final opportunityByIdProvider =
    Provider.family<OpportunityEntity?, String>((ref, id) {
  return MockOpportunitiesData.findById(id);
});

final bookmarkedIdsProvider =
    NotifierProvider<BookmarkedIdsNotifier, Set<String>>(
  BookmarkedIdsNotifier.new,
);

class BookmarkedIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String opportunityId) {
    if (state.contains(opportunityId)) {
      state = {...state}..remove(opportunityId);
    } else {
      state = {...state, opportunityId};
    }
  }

  bool isBookmarked(String opportunityId) => state.contains(opportunityId);
}

final homeSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredRecentOpportunitiesProvider =
    Provider<List<OpportunityEntity>>((ref) {
  final query = ref.watch(homeSearchQueryProvider).trim().toLowerCase();
  final opportunities = ref.watch(recentOpportunitiesProvider);

  if (query.isEmpty) {
    return opportunities;
  }

  return opportunities.where((opportunity) {
    return opportunity.title.toLowerCase().contains(query) ||
        opportunity.startupName.toLowerCase().contains(query) ||
        opportunity.tags.any((tag) => tag.toLowerCase().contains(query)) ||
        opportunity.category.label.toLowerCase().contains(query);
  }).toList();
});

final selectedCategoryProvider =
    StateProvider<OpportunityCategory?>((ref) => null);

final categoryFilteredOpportunitiesProvider =
    Provider<List<OpportunityEntity>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final opportunities = ref.watch(filteredRecentOpportunitiesProvider);

  if (category == null) {
    return opportunities;
  }

  return opportunities
      .where((opportunity) => opportunity.category == category)
      .toList();
});
