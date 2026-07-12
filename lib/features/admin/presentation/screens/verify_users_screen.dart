import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/admin_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/features/admin/presentation/providers/admin_providers.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/app_card.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';
import 'package:venture_link/shared/widgets/sign_out_button.dart';

class VerifyUsersScreen extends ConsumerWidget {
  const VerifyUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminUserProvider);
    final usersAsync = ref.watch(adminUsersStreamProvider);
    final users = ref.watch(filteredAdminUsersProvider);
    final selectedFilter = ref.watch(adminUserFilterProvider);

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text(AdminStrings.verifyUsers)),
        body: const ErrorStateWidget(message: AdminStrings.unauthorized),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AdminStrings.verifyUsers),
        actions: const [SignOutIconButton()],
      ),
      body: usersAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: AdminStrings.loadError,
          onRetry: () => ref.invalidate(adminUsersStreamProvider),
        ),
        data: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: AdminUserFilter.values.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(_filterLabel(filter)),
                        selected: isSelected,
                        onSelected: (_) {
                          ref.read(adminUserFilterProvider.notifier).state =
                              filter;
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: users.isEmpty
                    ? EmptyStateWidget(
                        title: selectedFilter == AdminUserFilter.pending
                            ? AdminStrings.emptyPending
                            : AdminStrings.emptyUsers,
                        icon: Icons.people_outline_rounded,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: users.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return _AdminUserTile(user: users[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _filterLabel(AdminUserFilter filter) {
    return switch (filter) {
      AdminUserFilter.all => AdminStrings.allUsers,
      AdminUserFilter.startups => AdminStrings.startups,
      AdminUserFilter.pending => AdminStrings.pending,
      AdminUserFilter.students => AdminStrings.students,
    };
  }
}

class _AdminUserTile extends ConsumerWidget {
  const _AdminUserTile({required this.user});

  final UserProfileEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationState =
        ref.watch(updateUserVerificationActionProvider(user.uid));
    final roleState = ref.watch(updateUserRoleActionProvider(user.uid));
    final isUpdating = verificationState.isLoading || roleState.isLoading;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  _initials(user.fullName),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _RoleChip(label: user.role),
                        if (user.role == UserRoles.startup)
                          _RoleChip(
                            label: user.isVerified
                                ? AdminStrings.verified
                                : AdminStrings.unverified,
                            color: user.isVerified
                                ? AppColors.success
                                : AppColors.accent,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                enabled: !isUpdating,
                tooltip: AdminStrings.changeRole,
                onSelected: (role) async {
                  final error = await ref
                      .read(updateUserRoleActionProvider(user.uid).notifier)
                      .updateRole(role);
                  if (!context.mounted) {
                    return;
                  }
                  if (error != null) {
                    context.showSnackBar(error, isError: true);
                    return;
                  }
                  context.showSnackBar(AdminStrings.roleUpdated);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: UserRoles.student,
                    child: Text('Student'),
                  ),
                  const PopupMenuItem(
                    value: UserRoles.startup,
                    child: Text('Startup'),
                  ),
                  const PopupMenuItem(
                    value: UserRoles.admin,
                    child: Text('Admin'),
                  ),
                ],
                icon: const Icon(Icons.more_vert_rounded),
              ),
            ],
          ),
          if (user.role == UserRoles.startup) ...[
            const Divider(height: AppSpacing.lg),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                AdminStrings.verified,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                user.isVerified
                    ? 'This startup can post opportunities'
                    : 'Verify to allow opportunity posting',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              value: user.isVerified,
              onChanged: isUpdating
                  ? null
                  : (value) async {
                      final error = await ref
                          .read(
                            updateUserVerificationActionProvider(user.uid)
                                .notifier,
                          )
                          .updateVerification(value);
                      if (!context.mounted) {
                        return;
                      }
                      if (error != null) {
                        context.showSnackBar(error, isError: true);
                        return;
                      }
                      context.showSnackBar(AdminStrings.verificationUpdated);
                    },
            ),
          ],
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    this.color = AppColors.primary,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
