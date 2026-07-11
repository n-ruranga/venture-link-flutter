import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(HomeStrings.navExplore),
      ),
      body: const EmptyStateWidget(
        title: HomeStrings.navExplore,
        message: HomeStrings.exploreComingSoon,
        icon: Icons.explore_outlined,
      ),
    );
  }
}

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(HomeStrings.navApplications),
      ),
      body: const EmptyStateWidget(
        title: HomeStrings.navApplications,
        message: HomeStrings.applicationsComingSoon,
        icon: Icons.description_outlined,
      ),
    );
  }
}

class PlaceholderTabScreen extends StatelessWidget {
  const PlaceholderTabScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title)),
      body: EmptyStateWidget(
        title: title,
        message: message,
        icon: icon,
      ),
    );
  }
}
