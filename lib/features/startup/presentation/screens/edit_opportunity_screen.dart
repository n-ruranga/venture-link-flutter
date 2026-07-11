import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_providers.dart';
import 'package:venture_link/features/startup/domain/entities/opportunity_input.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/features/startup/presentation/widgets/opportunity_form.dart';
import 'package:venture_link/shared/utils/action_result_handler.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

class EditOpportunityScreen extends ConsumerStatefulWidget {
  const EditOpportunityScreen({
    super.key,
    required this.opportunityId,
  });

  final String opportunityId;

  @override
  ConsumerState<EditOpportunityScreen> createState() =>
      _EditOpportunityScreenState();
}

class _EditOpportunityScreenState extends ConsumerState<EditOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final opportunityAsync =
        ref.watch(opportunityStreamProvider(widget.opportunityId));
    final submitState =
        ref.watch(updateOpportunityActionProvider(widget.opportunityId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(StartupStrings.editOpportunity),
      ),
      body: opportunityAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: StartupStrings.loadError,
          onRetry: () =>
              ref.invalidate(opportunityStreamProvider(widget.opportunityId)),
        ),
        data: (snapshot) {
          final opportunity = snapshot.opportunity;
          if (opportunity == null) {
            return const ErrorStateWidget(message: StartupStrings.loadError);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: OpportunityForm(
              formKey: _formKey,
              initialOpportunity: opportunity,
              submitLabel: StartupStrings.saveOpportunity,
              isSubmitting: submitState.isLoading,
              onSubmit: _submit,
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit(OpportunityInput input) async {
    await handleActionResult(
      context,
      action: () => ref
          .read(updateOpportunityActionProvider(widget.opportunityId).notifier)
          .submit(input),
      successMessage: StartupStrings.updateSuccess,
      onSuccess: () => context.pop(),
    );
  }
}
