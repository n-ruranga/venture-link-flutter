import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/dimensions.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/core/constants/opportunity_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/applications/presentation/widgets/application_status_chip.dart';
import 'package:venture_link/features/applications/presentation/widgets/application_timeline.dart';
import 'package:venture_link/features/applications/presentation/widgets/apply_application_sheet.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_providers.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_shared_widgets.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_state_widgets.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

class OpportunityDetailsScreen extends ConsumerWidget {
  const OpportunityDetailsScreen({
    super.key,
    required this.opportunityId,
  });

  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunityAsync = ref.watch(opportunityStreamProvider(opportunityId));
    final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).value ?? {};
    final hasApplied = ref.watch(hasAppliedStreamProvider(opportunityId));
    final applicationAsync =
        ref.watch(studentApplicationForOpportunityProvider(opportunityId));
    final applyState = ref.watch(applyActionProvider(opportunityId));

    return opportunityAsync.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorStateWidget(
          message: OpportunityStrings.loadError,
          onRetry: () => ref.invalidate(opportunityStreamProvider(opportunityId)),
        ),
      ),
      data: (snapshot) {
        final opportunity = snapshot.opportunity;
        if (opportunity == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const ErrorStateWidget(
              message: OpportunityStrings.emptyOpportunities,
            ),
          );
        }

        final isBookmarked = bookmarkedIds.contains(opportunityId);
        final isApplying = applyState.isLoading;
        final application = applicationAsync.value;
        final deadlineLabel =
            DateFormat.yMMMd().format(opportunity.deadline);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              if (snapshot.isOffline) const OfflineBanner(),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 228,
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
                              .read(bookmarkToggleProvider.notifier)
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
                          child: SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg,
                                kToolbarHeight,
                                AppSpacing.lg,
                                AppSpacing.lg,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      StartupLogoAvatar(
                                        opportunity: opportunity,
                                        size: 52,
                                        heroTag: 'logo-$opportunityId',
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Hero(
                                              tag: 'title-$opportunityId',
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  opportunity.title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                        height: 1.15,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: AppSpacing.xs),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    opportunity.startupName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.white
                                                              .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                                if (opportunity.isVerified) ...[
                                                  const SizedBox(
                                                    width: AppSpacing.sm,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withValues(
                                                        alpha: 0.2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      OpportunityStrings.verified,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _DetailsMetaGrid(
                            opportunity: opportunity,
                            deadlineLabel: deadlineLabel,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: opportunity.skills
                                .map((skill) => OpportunityTagChip(label: skill))
                                .toList(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          if (application != null) ...[
                            Row(
                              children: [
                                Text(
                                  ApplicationStrings.timeline,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const Spacer(),
                                ApplicationStatusChip(
                                  status: application.status,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ApplicationTimeline(
                              currentStatus: application.status,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                          ],
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
                            children: opportunity.skills
                                .map((skill) => OpportunityTagChip(label: skill))
                                .toList(),
                          ),
                          const SizedBox(height: 120),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton(
                label: hasApplied
                    ? OpportunityStrings.applied
                    : isApplying
                        ? OpportunityStrings.applying
                        : OpportunityStrings.applyNow,
                isLoading: isApplying,
                onPressed: hasApplied || isApplying
                    ? null
                    : () => ApplyApplicationSheet.show(
                          context,
                          opportunityId: opportunityId,
                          startupId: opportunity.startupId,
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailsMetaGrid extends StatelessWidget {
  const _DetailsMetaGrid({
    required this.opportunity,
    required this.deadlineLabel,
  });

  final OpportunityEntity opportunity;
  final String deadlineLabel;

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
          _MetaRow(icon: Icons.schedule_rounded, label: opportunity.hoursLabel),
          const Divider(height: 24),
          _MetaRow(icon: Icons.place_outlined, label: opportunity.location),
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
            icon: Icons.event_outlined,
            label: '${OpportunityStrings.deadline}: $deadlineLabel',
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
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
