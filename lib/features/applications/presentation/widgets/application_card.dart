import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/features/applications/domain/entities/application_entity.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';
import 'package:venture_link/features/applications/presentation/widgets/application_status_chip.dart';
import 'package:venture_link/features/applications/presentation/widgets/application_timeline.dart';
import 'package:venture_link/shared/widgets/app_card.dart';
import 'package:venture_link/shared/widgets/secondary_button.dart';

class ApplicationCard extends StatelessWidget {
  const ApplicationCard({
    super.key,
    required this.application,
    this.onWithdraw,
    this.isWithdrawing = false,
    this.showStartupActions = false,
    this.onStatusChanged,
    this.isUpdatingStatus = false,
  });

  final ApplicationEntity application;
  final VoidCallback? onWithdraw;
  final bool isWithdrawing;
  final bool showStartupActions;
  final ValueChanged<ApplicationStatus>? onStatusChanged;
  final bool isUpdatingStatus;

  @override
  Widget build(BuildContext context) {
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
                      application.opportunityTitle ?? 'Opportunity',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      application.startupName ?? application.startupId,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              ApplicationStatusChip(status: application.status, compact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ApplicationTimeline(currentStatus: application.status),
          if (showStartupActions) ...[
            const SizedBox(height: AppSpacing.md),
            _StartupStatusActions(
              currentStatus: application.status,
              onStatusChanged: onStatusChanged,
              isUpdating: isUpdatingStatus,
            ),
          ],
          if (onWithdraw != null && application.status.canWithdraw) ...[
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: ApplicationStrings.withdraw,
              icon: Icons.close_rounded,
              onPressed: isWithdrawing ? null : onWithdraw,
            ),
          ],
        ],
      ),
    );
  }
}

class _StartupStatusActions extends StatelessWidget {
  const _StartupStatusActions({
    required this.currentStatus,
    required this.onStatusChanged,
    required this.isUpdating,
  });

  final ApplicationStatus currentStatus;
  final ValueChanged<ApplicationStatus>? onStatusChanged;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final nextStatuses = ApplicationStatus.values
        .where((status) =>
            status != currentStatus &&
            status != ApplicationStatus.applied &&
            status != ApplicationStatus.rejected)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ApplicationStrings.updateStatus,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ...nextStatuses.map(
              (status) => ActionChip(
                label: Text(status.label),
                onPressed: isUpdating ? null : () => onStatusChanged?.call(status),
              ),
            ),
            ActionChip(
              label: const Text(ApplicationStrings.reject),
              backgroundColor: AppColors.error.withValues(alpha: 0.08),
              onPressed: isUpdating
                  ? null
                  : () => onStatusChanged?.call(ApplicationStatus.rejected),
            ),
          ],
        ),
      ],
    );
  }
}