import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';

class ApplicationTimeline extends StatelessWidget {
  const ApplicationTimeline({
    super.key,
    required this.currentStatus,
  });

  final ApplicationStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    if (currentStatus == ApplicationStatus.rejected) {
      return _RejectedTimeline(status: currentStatus);
    }

    final currentIndex =
        ApplicationStatus.timelineOrder.indexOf(currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ApplicationStrings.timeline,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        ...List.generate(ApplicationStatus.timelineOrder.length, (index) {
          final status = ApplicationStatus.timelineOrder[index];
          final isCompleted = index <= currentIndex;
          final isLast = index == ApplicationStatus.timelineOrder.length - 1;

          return _TimelineStep(
            status: status,
            isCompleted: isCompleted,
            isActive: index == currentIndex,
            showConnector: !isLast,
          );
        }),
      ],
    );
  }
}

class _RejectedTimeline extends StatelessWidget {
  const _RejectedTimeline({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ApplicationStrings.timeline,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        _TimelineStep(
          status: ApplicationStatus.applied,
          isCompleted: true,
          isActive: false,
          showConnector: true,
        ),
        _TimelineStep(
          status: status,
          isCompleted: true,
          isActive: true,
          showConnector: false,
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.status,
    required this.isCompleted,
    required this.isActive,
    required this.showConnector,
  });

  final ApplicationStatus status;
  final bool isCompleted;
  final bool isActive;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? status.color : AppColors.border;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isCompleted
                    ? status.color.withValues(alpha: 0.15)
                    : AppColors.divider,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: isCompleted
                  ? Icon(
                      isActive ? Icons.radio_button_checked : Icons.check,
                      size: 10,
                      color: status.color,
                    )
                  : null,
            ),
            if (showConnector)
              Container(
                width: 2,
                height: 28,
                color: isCompleted ? status.color.withValues(alpha: 0.35) : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              status.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
