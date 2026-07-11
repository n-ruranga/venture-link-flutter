import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/utils/validators.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/custom_text_field.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

class ApplyApplicationSheet extends ConsumerStatefulWidget {
  const ApplyApplicationSheet({
    super.key,
    required this.opportunityId,
    required this.startupId,
  });

  final String opportunityId;
  final String startupId;

  static Future<void> show(
    BuildContext context, {
    required String opportunityId,
    required String startupId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ApplyApplicationSheet(
          opportunityId: opportunityId,
          startupId: startupId,
        ),
      ),
    );
  }

  @override
  ConsumerState<ApplyApplicationSheet> createState() =>
      _ApplyApplicationSheetState();
}

class _ApplyApplicationSheetState extends ConsumerState<ApplyApplicationSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _coverLetterController;
  late final TextEditingController _resumeUrlController;
  var _useProfileResume = true;

  @override
  void initState() {
    super.initState();
    _coverLetterController = TextEditingController();
    _resumeUrlController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileResume =
          ref.read(userProfileStreamProvider).value?.resumeUrl;
      if (profileResume != null && mounted) {
        _resumeUrlController.text = profileResume;
      }
    });
  }

  @override
  void dispose() {
    _coverLetterController.dispose();
    _resumeUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileStreamProvider).value;
    final profileResume = profile?.resumeUrl;
    final applyState = ref.watch(applyActionProvider(widget.opportunityId));
    final isSubmitting = applyState.isLoading;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ApplicationStrings.apply,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _coverLetterController,
              label: ApplicationStrings.coverLetter,
              hint: ApplicationStrings.coverLetterHint,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              validator: Validators.validateCoverLetter,
            ),
            const SizedBox(height: AppSpacing.md),
            if (profileResume != null) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(ApplicationStrings.useProfileResume),
                value: _useProfileResume,
                onChanged: isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _useProfileResume = value;
                          if (value) {
                            _resumeUrlController.text = profileResume;
                          } else {
                            _resumeUrlController.clear();
                          }
                        });
                      },
              ),
            ],
            CustomTextField(
              controller: _resumeUrlController,
              label: ApplicationStrings.resumeUrl,
              hint: ApplicationStrings.resumeHint,
              keyboardType: TextInputType.url,
              readOnly: _useProfileResume && profileResume != null,
              validator: Validators.validateOptionalUrl,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: ApplicationStrings.apply,
              isLoading: isSubmitting,
              onPressed: isSubmitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final resumeUrl = _resumeUrlController.text.trim();

    final error = await ref
        .read(applyActionProvider(widget.opportunityId).notifier)
        .submit(
          startupId: widget.startupId,
          coverLetter: _coverLetterController.text,
          resumeUrl: resumeUrl.isEmpty ? null : resumeUrl,
        );

    if (!mounted) {
      return;
    }

    if (error != null) {
      context.showSnackBar(error, isError: true);
      return;
    }

    context.showSnackBar(ApplicationStrings.applySuccess);
    Navigator.of(context).pop();
  }
}
