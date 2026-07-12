import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/profile_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/strings.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';
import 'package:venture_link/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:venture_link/shared/widgets/app_card.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';
import 'package:venture_link/shared/widgets/sign_out_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final isStartup = ref.watch(isStartupUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(ProfileStrings.profile),
        actions: [
          profileAsync.maybeWhen(
            data: (profile) => profile != null
                ? IconButton(
                    onPressed: () => context.push(RouteNames.editProfile),
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: ProfileStrings.editProfile,
                  )
                : null,
            orElse: () => null,
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: AppStrings.genericError,
          onRetry: () => ref.invalidate(userProfileStreamProvider),
        ),
        data: (profile) {
          if (profile == null) {
            return const EmptyStateWidget(
              title: ProfileStrings.profile,
              message: 'Profile not found. Please try again later.',
              icon: Icons.person_outline_rounded,
            );
          }

          return _ProfileContent(
            profile: profile,
            isStartup: isStartup,
          );
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.isStartup,
  });

  final UserProfileEntity profile;
  final bool isStartup;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          ProfileCompletionCard(percentage: profile.completionPercentage),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.academicInfo,
              child: Column(
                children: [
                  ProfileInfoRow(
                    icon: Icons.school_outlined,
                    label: ProfileStrings.degree,
                    value: profile.degree ?? ProfileStrings.notSet,
                  ),
                  ProfileInfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: ProfileStrings.year,
                    value: profile.year ?? ProfileStrings.notSet,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.about,
              child: Text(
                profile.bio ?? ProfileStrings.noBio,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: profile.bio == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      height: 1.5,
                    ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.skills,
              child: ProfileChipList(
                items: profile.skills,
                emptyMessage: ProfileStrings.noSkills,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.interests,
              child: ProfileChipList(
                items: profile.interests,
                emptyMessage: ProfileStrings.noInterests,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.portfolioLinks,
              child: Column(
                children: [
                  ProfileInfoRow(
                    icon: Icons.code_rounded,
                    label: ProfileStrings.github,
                    value: profile.github ?? ProfileStrings.notSet,
                  ),
                  ProfileInfoRow(
                    icon: Icons.link_rounded,
                    label: ProfileStrings.linkedin,
                    value: profile.linkedin ?? ProfileStrings.notSet,
                  ),
                  ProfileInfoRow(
                    icon: Icons.language_rounded,
                    label: ProfileStrings.portfolio,
                    value: profile.portfolio ?? ProfileStrings.notSet,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (isStartup) ...[
            PrimaryButton(
              label: StartupStrings.dashboard,
              icon: Icons.dashboard_outlined,
              onPressed: () => context.push(RouteNames.startupDashboard),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          PrimaryButton(
            label: ProfileStrings.editProfile,
            icon: Icons.edit_outlined,
            onPressed: () => context.push(RouteNames.editProfile),
          ),
          const SizedBox(height: AppSpacing.md),
          const SignOutButton(),
        ],
      ),
    );
  }
}
