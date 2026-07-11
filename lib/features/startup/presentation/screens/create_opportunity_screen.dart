import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/features/startup/domain/entities/opportunity_input.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/features/startup/presentation/widgets/opportunity_form.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';

class CreateOpportunityScreen extends ConsumerStatefulWidget {
  const CreateOpportunityScreen({super.key});

  @override
  ConsumerState<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState
    extends ConsumerState<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isVerified = ref.watch(isVerifiedStartupProvider);
    final submitState = ref.watch(createOpportunityActionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(StartupStrings.createOpportunity),
      ),
      body: isVerified
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: OpportunityForm(
                formKey: _formKey,
                submitLabel: StartupStrings.saveOpportunity,
                isSubmitting: submitState.isLoading,
                onSubmit: _submit,
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  StartupStrings.notVerified,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
    );
  }

  Future<void> _submit(OpportunityInput input) async {
    final error =
        await ref.read(createOpportunityActionProvider.notifier).submit(input);

    if (!mounted) {
      return;
    }

    if (error != null) {
      context.showSnackBar(error, isError: true);
      return;
    }

    context.showSnackBar(StartupStrings.createSuccess);
    context.pop();
  }
}
