import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/opportunity_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: OpportunityStrings.offlineMessage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        color: AppColors.accent.withValues(alpha: 0.12),
        child: Row(
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 18,
              color: AppColors.accent,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                OpportunityStrings.offlineMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
