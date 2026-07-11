import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/dimensions.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_providers.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_shared_widgets.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

class OpportunityDetailsScreen extends ConsumerWidget {
  const OpportunityDetailsScreen({
    super.key,
    required this.opportunityId,
  });

  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunity = ref.watch(opportunityByIdProvider(opportunityId));
    final isBookmarked = ref.watch(bookmarkedIdsProvider).contains(opportunityId);

    if (opportunity == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyStateWidget(
          title: HomeStrings.noResults,
          icon: Icons.work_off_outlined,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor: Color(opportunity.startupColor),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
            ),
            actions: [
              BookmarkButton(
                isBookmarked: isBookmarked,
                onPressed: () => ref
                    .read(bookmarkedIdsProvider.notifier)
                    .toggle(opportunityId),
                light: true,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(opportunity.startupColor),
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  96,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StartupLogoAvatar(
                      opportunity: opportunity,
                      size: 64,
                      heroTag: 'logo-$opportunityId',
                    ),
                    const Spacer(),
                    Hero(
                      tag: 'title-$opportunityId',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          opportunity.title,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      opportunity.startupName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _DetailsMetaGrid(opportunity: opportunity),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: opportunity.tags
                      .map((tag) => OpportunityTagChip(label: tag))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  HomeStrings.aboutOpportunity,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  opportunity.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  HomeStrings.skillsRequired,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: opportunity.tags
                      .map((tag) => OpportunityTagChip(label: tag))
                      .toList(),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PrimaryButton(
            label: HomeStrings.applyNow,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class _DetailsMetaGrid extends StatelessWidget {
  const _DetailsMetaGrid({required this.opportunity});

  final OpportunityEntity opportunity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _MetaRow(
            icon: Icons.schedule_rounded,
            label: opportunity.weeklyHours,
          ),
          const Divider(height: 24),
          _MetaRow(
            icon: Icons.place_outlined,
            label: opportunity.location,
          ),
          const Divider(height: 24),
          _MetaRow(
            icon: Icons.laptop_mac_rounded,
            label: opportunity.workMode.label,
          ),
          const Divider(height: 24),
          _MetaRow(
            icon: Icons.category_outlined,
            label: opportunity.category.label,
          ),
          const Divider(height: 24),
          _MetaRow(
            icon: Icons.access_time_rounded,
            label: opportunity.postedLabel,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
