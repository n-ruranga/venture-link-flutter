import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/core/constants/opportunity_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/features/home/presentation/widgets/category_grid.dart';
import 'package:venture_link/features/home/presentation/widgets/home_header_widgets.dart';
import 'package:venture_link/features/home/presentation/widgets/opportunity_list_card.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_providers.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_state_widgets.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);
    final results = ref.watch(exploreFilteredOpportunitiesProvider);
    final categories = ref.watch(opportunityCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final bookmarksOnly = ref.watch(showBookmarksOnlyProvider);
    final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).value ?? {};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(HomeStrings.navExplore),
      ),
      body: opportunitiesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: OpportunityStrings.loadError,
          onRetry: () => ref.invalidate(opportunitiesStreamProvider),
        ),
        data: (snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snapshot.isOffline) const OfflineBanner(),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      OpportunityStrings.allOpportunities,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      OpportunityStrings.exploreSubtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    HomeSearchSection(
                      controller: _searchController,
                      onChanged: (value) {
                        ref.read(exploreSearchQueryProvider.notifier).state =
                            value;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        FilterChip(
                          label: Text(OpportunityStrings.saved),
                          selected: bookmarksOnly,
                          onSelected: (selected) {
                            ref.read(showBookmarksOnlyProvider.notifier).state =
                                selected;
                          },
                        ),
                        if (selectedCategory != null)
                          InputChip(
                            label: Text(selectedCategory.label),
                            onDeleted: () {
                              ref.read(selectedCategoryProvider.notifier).state =
                                  null;
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CategoryGrid(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Text(
                          bookmarksOnly
                              ? OpportunityStrings.emptyBookmarks
                              : snapshot.opportunities.isEmpty
                                  ? OpportunityStrings.emptyOpportunities
                                  : OpportunityStrings.emptySearch,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.xxl,
                        ),
                        itemCount: results.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final opportunity = results[index];
                          return OpportunityListCard(
                            opportunity: opportunity,
                            isBookmarked:
                                bookmarkedIds.contains(opportunity.id),
                            onBookmarkToggle: () => ref
                                .read(bookmarkToggleProvider.notifier)
                                .toggle(opportunity.id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
