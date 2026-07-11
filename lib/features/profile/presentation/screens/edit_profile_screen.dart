import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/profile_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/utils/validators.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';
import 'package:venture_link/features/profile/presentation/widgets/tag_editor.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/custom_text_field.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _degreeController = TextEditingController();
  final _yearController = TextEditingController();
  final _bioController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _skillController = TextEditingController();
  final _interestController = TextEditingController();

  List<String> _skills = [];
  List<String> _interests = [];
  UserProfileEntity? _originalProfile;

  @override
  void dispose() {
    _fullNameController.dispose();
    _degreeController.dispose();
    _yearController.dispose();
    _bioController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _portfolioController.dispose();
    _skillController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  void _populateForm(UserProfileEntity profile) {
    if (_originalProfile?.uid == profile.uid) {
      return;
    }
    _originalProfile = profile;
    _fullNameController.text = profile.fullName;
    _degreeController.text = profile.degree ?? '';
    _yearController.text = profile.year ?? '';
    _bioController.text = profile.bio ?? '';
    _githubController.text = profile.github ?? '';
    _linkedinController.text = profile.linkedin ?? '';
    _portfolioController.text = profile.portfolio ?? '';
    _skills = List<String>.from(profile.skills);
    _interests = List<String>.from(profile.interests);
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty) {
      context.showSnackBar(ProfileStrings.skillRequired, isError: true);
      return;
    }
    if (_skills.contains(skill)) {
      _skillController.clear();
      return;
    }
    setState(() {
      _skills = [..._skills, skill];
      _skillController.clear();
    });
  }

  void _addInterest() {
    final interest = _interestController.text.trim();
    if (interest.isEmpty) {
      context.showSnackBar(ProfileStrings.interestRequired, isError: true);
      return;
    }
    if (_interests.contains(interest)) {
      _interestController.clear();
      return;
    }
    setState(() {
      _interests = [..._interests, interest];
      _interestController.clear();
    });
  }

  Future<void> _saveProfile(UserProfileEntity profile) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final updatedProfile = profile.copyWith(
      fullName: _fullNameController.text.trim(),
      degree: _degreeController.text.trim(),
      year: _yearController.text.trim(),
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
      github: _githubController.text.trim().isEmpty
          ? null
          : _githubController.text.trim(),
      linkedin: _linkedinController.text.trim().isEmpty
          ? null
          : _linkedinController.text.trim(),
      portfolio: _portfolioController.text.trim().isEmpty
          ? null
          : _portfolioController.text.trim(),
      skills: _skills,
      interests: _interests,
    );

    await ref
        .read(updateProfileActionProvider.notifier)
        .updateProfile(updatedProfile);

    if (!mounted) {
      return;
    }

    final updateState = ref.read(updateProfileActionProvider);
    if (updateState.hasError) {
      context.showSnackBar(updateState.error.toString(), isError: true);
      return;
    }

    context.showSnackBar(ProfileStrings.profileUpdated);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final updateState = ref.watch(updateProfileActionProvider);
    final isSaving = updateState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(ProfileStrings.editProfile),
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(message: error.toString()),
        data: (profile) {
          if (profile == null) {
            return const ErrorStateWidget();
          }

          _populateForm(profile);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ProfileStrings.personalInfo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _fullNameController,
                    label: ProfileStrings.fullName,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: Validators.validateName,
                    enabled: !isSaving,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: ProfileStrings.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Theme.of(context)
                          .inputDecorationTheme
                          .fillColor
                          ?.withValues(alpha: 0.5),
                    ),
                    child: Text(
                      profile.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    ProfileStrings.academicInfo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _degreeController,
                    label: ProfileStrings.degree,
                    prefixIcon: Icons.school_outlined,
                    validator: Validators.validateDegree,
                    enabled: !isSaving,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _yearController,
                    label: ProfileStrings.year,
                    prefixIcon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.text,
                    validator: Validators.validateYear,
                    enabled: !isSaving,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    ProfileStrings.about,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _bioController,
                    label: ProfileStrings.bio,
                    prefixIcon: Icons.info_outline_rounded,
                    maxLines: 4,
                    validator: Validators.validateBio,
                    enabled: !isSaving,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TagEditor(
                    label: ProfileStrings.skills,
                    hint: ProfileStrings.addSkill,
                    emptyHint: ProfileStrings.noSkills,
                    items: _skills,
                    controller: _skillController,
                    onAdd: _addSkill,
                    onRemove: (skill) {
                      setState(() {
                        _skills = _skills.where((s) => s != skill).toList();
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TagEditor(
                    label: ProfileStrings.interests,
                    hint: ProfileStrings.addInterest,
                    emptyHint: ProfileStrings.noInterests,
                    items: _interests,
                    controller: _interestController,
                    onAdd: _addInterest,
                    onRemove: (interest) {
                      setState(() {
                        _interests =
                            _interests.where((i) => i != interest).toList();
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    ProfileStrings.portfolioLinks,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _githubController,
                    label: ProfileStrings.github,
                    prefixIcon: Icons.code_rounded,
                    keyboardType: TextInputType.url,
                    validator: Validators.validateOptionalUrl,
                    enabled: !isSaving,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _linkedinController,
                    label: ProfileStrings.linkedin,
                    prefixIcon: Icons.link_rounded,
                    keyboardType: TextInputType.url,
                    validator: Validators.validateOptionalUrl,
                    enabled: !isSaving,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _portfolioController,
                    label: ProfileStrings.portfolio,
                    prefixIcon: Icons.language_rounded,
                    keyboardType: TextInputType.url,
                    validator: Validators.validateOptionalUrl,
                    enabled: !isSaving,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: ProfileStrings.saveProfile,
                    isLoading: isSaving,
                    onPressed: isSaving ? null : () => _saveProfile(profile),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
