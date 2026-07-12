import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/shared/widgets/role_branch_screen.dart';

class MainShell extends ConsumerWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(appShellRoleProvider);

    return switch (role) {
      AppShellRole.admin => _buildShell(
          navigationShell: navigationShell,
          onTap: _onTap,
          indicatorColor: AppColors.primary.withValues(alpha: 0.14),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: HomeStrings.navDashboard,
            ),
            NavigationDestination(
              icon: Icon(Icons.admin_panel_settings_outlined),
              selectedIcon: Icon(Icons.admin_panel_settings_rounded),
              label: HomeStrings.navUsers,
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: HomeStrings.navPlatform,
            ),
            NavigationDestination(
              icon: Icon(Icons.manage_accounts_outlined),
              selectedIcon: Icon(Icons.manage_accounts_rounded),
              label: HomeStrings.navAccount,
            ),
          ],
        ),
      AppShellRole.startup => _buildShell(
          navigationShell: navigationShell,
          onTap: _onTap,
          indicatorColor: AppColors.accent.withValues(alpha: 0.16),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: HomeStrings.navDashboard,
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline_rounded),
              selectedIcon: Icon(Icons.work_rounded),
              label: HomeStrings.navListings,
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups_rounded),
              label: HomeStrings.navApplicants,
            ),
            NavigationDestination(
              icon: Icon(Icons.apartment_outlined),
              selectedIcon: Icon(Icons.apartment_rounded),
              label: HomeStrings.navCompany,
            ),
          ],
        ),
      AppShellRole.student => _buildShell(
          navigationShell: navigationShell,
          onTap: _onTap,
          indicatorColor: AppColors.primary.withValues(alpha: 0.12),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: HomeStrings.navHome,
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: HomeStrings.navExplore,
            ),
            NavigationDestination(
              icon: Icon(Icons.description_outlined),
              selectedIcon: Icon(Icons.description_rounded),
              label: HomeStrings.navApplications,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: HomeStrings.navProfile,
            ),
          ],
        ),
    };
  }

  Widget _buildShell({
    required StatefulNavigationShell navigationShell,
    required ValueChanged<int> onTap,
    required Color indicatorColor,
    required List<NavigationDestination> destinations,
  }) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: AppColors.surface,
        indicatorColor: indicatorColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: destinations,
      ),
    );
  }
}
