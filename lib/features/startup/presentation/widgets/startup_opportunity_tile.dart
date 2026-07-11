import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/dimensions.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/shared/widgets/app_card.dart';

class StartupOpportunityTile extends StatelessWidget {
  const StartupOpportunityTile({
    super.key,
    required this.opportunity,
    required this.onDelete,
    this.isDeleting = false,
  });

  final OpportunityEntity opportunity;
  final VoidCallback onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final deadlineLabel = DateFormat.yMMMd().format(opportunity.deadline);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${opportunity.category.label} · ${opportunity.workMode.label}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(isActive: opportunity.isActive),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${StartupStrings.deadline}: $deadlineLabel',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => context.push(
                  RouteNames.startupApplicants,
                  extra: opportunity.id,
                ),
                icon: const Icon(Icons.people_outline_rounded, size: 18),
                label: const Text(StartupStrings.viewApplicants),
              ),
              const Spacer(),
              IconButton(
                onPressed: isDeleting
                    ? null
                    : () => context.push(
                          '/startup/opportunities/${opportunity.id}/edit',
                        ),
                icon: const Icon(Icons.edit_outlined),
                tooltip: StartupStrings.editOpportunity,
              ),
              IconButton(
                onPressed: isDeleting ? null : onDelete,
                icon: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline_rounded),
                tooltip: StartupStrings.deleteOpportunity,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.textSecondary;
    final label = isActive ? StartupStrings.active : StartupStrings.closed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
