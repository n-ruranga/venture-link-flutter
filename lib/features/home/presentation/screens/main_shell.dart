import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';

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
    final isStartup = ref.watch(isStartupUserProvider);
    final applicationsLabel =
        isStartup ? HomeStrings.navApplicants : HomeStrings.navApplications;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: HomeStrings.navHome,
            tooltip: HomeStrings.navHome,
          ),
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: HomeStrings.navExplore,
            tooltip: HomeStrings.navExplore,
          ),
          NavigationDestination(
            icon: const Icon(Icons.description_outlined),
            selectedIcon: const Icon(Icons.description_rounded),
            label: applicationsLabel,
            tooltip: applicationsLabel,
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: HomeStrings.navProfile,
            tooltip: HomeStrings.navProfile,
          ),
        ],
      ),
    );
  }
}
