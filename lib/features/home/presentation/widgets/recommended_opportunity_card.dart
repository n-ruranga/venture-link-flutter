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
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StartupLogoAvatar(
                        opportunity: opportunity,
                        size: 40,
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
                              height: 1.15,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SkillOverflowChips(
                    skills: opportunity.skills,
                    maxVisible: 3,
                    onLightBackground: false,
                    trailing: _LightWorkModeBadge(
                      label: opportunity.workMode.label,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
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

class _LightWorkModeBadge extends StatelessWidget {
  const _LightWorkModeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
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
