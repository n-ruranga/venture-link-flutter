import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/dimensions.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';

class ApplicationStatusChip extends StatelessWidget {
  const ApplicationStatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  final ApplicationStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: status.color.withValues(alpha: 0.25)),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: status.color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
