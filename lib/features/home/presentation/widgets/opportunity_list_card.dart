import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/dimensions.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_shared_widgets.dart';
import 'package:venture_link/shared/widgets/app_card.dart';

class OpportunityListCard extends StatelessWidget {
  const OpportunityListCard({
    super.key,
    required this.opportunity,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  final OpportunityEntity opportunity;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.pushNamed(
        'opportunityDetails',
        pathParameters: {'id': opportunity.id},
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StartupLogoAvatar(
            opportunity: opportunity,
            size: 52,
            heroTag: 'logo-${opportunity.id}',
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'title-${opportunity.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      opportunity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  opportunity.startupName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    WorkModeBadge(label: opportunity.workMode.label, compact: true),
                    _InfoPill(
                      icon: Icons.schedule_rounded,
                      label: opportunity.hoursLabel,
                    ),
                    _InfoPill(
                      icon: Icons.place_outlined,
                      label: opportunity.location,
                    ),
                  ],
                ),
                if (opportunity.skills.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  SkillOverflowChips(
                    skills: opportunity.skills,
                    maxVisible: 3,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          BookmarkButton(
            isBookmarked: isBookmarked,
            onPressed: onBookmarkToggle,
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
