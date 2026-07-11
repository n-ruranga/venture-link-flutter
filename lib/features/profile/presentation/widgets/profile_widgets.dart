import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/dimensions.dart';
import 'package:venture_link/core/constants/profile_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/shared/widgets/network_image_widget.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
  });

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        children: [
          _Avatar(profile: profile),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            profile.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              profile.role.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
      return NetworkImageWidget(
        imageUrl: profile.profilePicture!,
        width: AppDimensions.avatarLg,
        height: AppDimensions.avatarLg,
        borderRadius: BorderRadius.circular(AppDimensions.avatarLg / 2),
      );
    }

    return CircleAvatar(
      radius: AppDimensions.avatarLg / 2,
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      child: Text(
        profile.fullName.isNotEmpty ? profile.fullName[0].toUpperCase() : '?',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}

class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({
    super.key,
    required this.percentage,
  });

  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ProfileStrings.profileCompletion,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: AppColors.divider,
              color: AppColors.primary,
            ),
          ),
          if (percentage < 100) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              ProfileStrings.completeYourProfile,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileChipList extends StatelessWidget {
  const ProfileChipList({
    super.key,
    required this.items,
    this.emptyMessage,
  });

  final List<String> items;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        emptyMessage ?? ProfileStrings.notSet,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      );
    }

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: items
          .map(
            (item) => Chip(
              label: Text(item),
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              side: BorderSide.none,
            ),
          )
          .toList(),
    );
  }
}
