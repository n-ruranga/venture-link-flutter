import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/user_roles.dart';

class RegisterRolePicker extends StatelessWidget {
  const RegisterRolePicker({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AuthStrings.accountType,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _RoleOptionCard(
                title: AuthStrings.studentAccount,
                description: AuthStrings.studentAccountDesc,
                icon: Icons.school_outlined,
                color: AppColors.primary,
                isSelected: selectedRole == UserRoles.student,
                onTap: () => onRoleChanged(UserRoles.student),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _RoleOptionCard(
                title: AuthStrings.startupAccount,
                description: AuthStrings.startupAccountDesc,
                icon: Icons.rocket_launch_outlined,
                color: AppColors.accent,
                isSelected: selectedRole == UserRoles.startup,
                onTap: () => onRoleChanged(UserRoles.startup),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoleOptionCard extends StatelessWidget {
  const _RoleOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
