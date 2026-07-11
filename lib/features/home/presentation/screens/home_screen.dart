import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/features/home/presentation/widgets/category_grid.dart';
import 'package:venture_link/features/home/presentation/widgets/home_header_widgets.dart';
import 'package:venture_link/features/home/presentation/widgets/opportunity_list_card.dart';
import 'package:venture_link/features/home/presentation/widgets/recommended_opportunity_card.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_providers.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_shared_widgets.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    final authAsync = ref.watch(authNotifierProvider);
    final profileAsync = ref.watch(userProfileStreamProvider);
    final featured = ref.watch(featuredOpportunitiesProvider);
    final recent = ref.watch(categoryFilteredOpportunitiesProvider);
    final categories = ref.watch(opportunityCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final bookmarkedIds = ref.watch(bookmarkedIdsProvider);

    return authAsync.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (error, _) => Scaffold(body: Center(child: Text(error.toString()))),
      data: (authState) {
        if (!authState.isAuthenticated) {
          return const Scaffold(body: LoadingIndicator());
        }

        final user = authState.user!;
        final profile = profileAsync.value;
        final firstName = _firstName(
          profile?.fullName ?? user.displayName ?? user.email,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      HomeGreetingHeader(
                        name: firstName,
                        onAvatarTap: () => context.go(RouteNames.profile),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      HomeSearchSection(
                        controller: _searchController,
                        onChanged: (value) {
                          ref.read(homeSearchQueryProvider.notifier).state =
                              value;
                        },
                      ),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        SectionHeader(
                          title: HomeStrings.recommended,
                          actionLabel: HomeStrings.seeAll,
                          onAction: () => context.go(RouteNames.search),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 240,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final opportunity = featured[index];
                        return RecommendedOpportunityCard(
                          opportunity: opportunity,
                          isBookmarked:
                              bookmarkedIds.contains(opportunity.id),
                          onBookmarkToggle: () => ref
                              .read(bookmarkedIdsProvider.notifier)
                              .toggle(opportunity.id),
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          HomeStrings.browseCategories,
                          style: Theme.of(context).textTheme.titleMedium,
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
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      HomeStrings.recentOpportunities,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                if (recent.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      title: HomeStrings.noResults,
                      icon: Icons.search_off_rounded,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    sliver: SliverList.separated(
                      itemCount: recent.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final opportunity = recent[index];
                        return OpportunityListCard(
                          opportunity: opportunity,
                          isBookmarked:
                              bookmarkedIds.contains(opportunity.id),
                          onBookmarkToggle: () => ref
                              .read(bookmarkedIdsProvider.notifier)
                              .toggle(opportunity.id),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _firstName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) {
      return 'Student';
    }
    if (parts.first.contains('@')) {
      return parts.first.split('@').first;
    }
    return parts.first;
  }
}
