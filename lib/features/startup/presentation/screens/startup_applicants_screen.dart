import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_state_widgets.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/features/startup/presentation/widgets/startup_applicants_list.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

class StartupApplicantsScreen extends ConsumerStatefulWidget {
  const StartupApplicantsScreen({
    super.key,
    this.initialOpportunityId,
  });

  final String? initialOpportunityId;

  @override
  ConsumerState<StartupApplicantsScreen> createState() =>
      _StartupApplicantsScreenState();
}

class _StartupApplicantsScreenState extends ConsumerState<StartupApplicantsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialOpportunityId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref.read(selectedApplicantOpportunityFilterProvider.notifier).state =
            widget.initialOpportunityId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(startupApplicationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(StartupStrings.applicants),
      ),
      body: applicationsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: ApplicationStrings.loadError,
          onRetry: () => ref.invalidate(startupApplicationsStreamProvider),
        ),
        data: (snapshot) {
          return Column(
            children: [
              if (snapshot.isFromCache) const OfflineBanner(),
              const Expanded(child: StartupApplicantsList()),
            ],
          );
        },
      ),
    );
  }
}
