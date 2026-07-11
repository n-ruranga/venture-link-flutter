import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/dimensions.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_shared_widgets.dart';

class RecommendedOpportunityCard extends StatelessWidget {
  const RecommendedOpportunityCard({
    super.key,
    required this.opportunity,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    this.width,
  });

  final OpportunityEntity opportunity;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? MediaQuery.sizeOf(context).width * 0.78;

    return SizedBox(
      width: cardWidth.clamp(280, 360),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed(
            'opportunityDetails',
            pathParameters: {'id': opportunity.id},
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(opportunity.startupColor),
                  AppColors.secondary,
                  AppColors.accent.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: Color(opportunity.startupColor).withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StartupLogoAvatar(
                        opportunity: opportunity,
                        size: 44,
                        heroTag: 'logo-${opportunity.id}',
                      ),
                      const Spacer(),
                      BookmarkButton(
                        isBookmarked: isBookmarked,
                        onPressed: onBookmarkToggle,
                        light: true,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Hero(
                    tag: 'title-${opportunity.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        opportunity.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              height: 1.2,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.apartment_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          opportunity.startupName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      ...opportunity.skills.take(3).map(
                            (skill) => OpportunityTagChip(
                              label: skill,
                              onLightBackground: false,
                            ),
                          ),
                      WorkModeBadge(
                        label: opportunity.workMode.label,
                        compact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.schedule_rounded,
                        label: opportunity.hoursLabel,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _MetaChip(
                        icon: Icons.place_outlined,
                        label: opportunity.location,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
