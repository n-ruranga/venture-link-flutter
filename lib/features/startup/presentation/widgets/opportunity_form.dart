import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/utils/validators.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/profile/presentation/widgets/tag_editor.dart';
import 'package:venture_link/features/startup/domain/entities/opportunity_input.dart';
import 'package:venture_link/shared/widgets/custom_text_field.dart';

class OpportunityForm extends StatefulWidget {
  const OpportunityForm({
    super.key,
    required this.formKey,
    required this.onSubmit,
    required this.submitLabel,
    this.initialOpportunity,
    this.isSubmitting = false,
  });

  final GlobalKey<FormState> formKey;
  final Future<void> Function(OpportunityInput input) onSubmit;
  final String submitLabel;
  final OpportunityEntity? initialOpportunity;
  final bool isSubmitting;

  @override
  State<OpportunityForm> createState() => _OpportunityFormState();
}

class _OpportunityFormState extends State<OpportunityForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _hoursController;
  late final TextEditingController _skillController;

  late WorkMode _workMode;
  late OpportunityCategory _category;
  late DateTime _deadline;
  List<String> _skills = [];
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _hoursController = TextEditingController();
    _skillController = TextEditingController();
    _workMode = WorkMode.remote;
    _category = OpportunityCategory.engineering;
    _deadline = DateTime.now().add(const Duration(days: 30));
  }

  @override
  void didUpdateWidget(covariant OpportunityForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _populateFromInitial();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _hoursController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _populateFromInitial() {
    final initial = widget.initialOpportunity;
    if (initial == null || _initialized) {
      return;
    }

    _initialized = true;
    _titleController.text = initial.title;
    _descriptionController.text = initial.description;
    _locationController.text = initial.location;
    _hoursController.text = initial.hoursPerWeek;
    _workMode = initial.workMode;
    _category = initial.category;
    _deadline = initial.deadline;
    _skills = List<String>.from(initial.skills);
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty) {
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

  Future<void> _handleSubmit() async {
    if (_skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StartupStrings.skillsRequired)),
      );
      return;
    }

    if (!widget.formKey.currentState!.validate()) {
      return;
    }

    await widget.onSubmit(
      OpportunityInput(
        title: _titleController.text,
        description: _descriptionController.text,
        skills: _skills,
        location: _locationController.text,
        workMode: _workMode,
        category: _category,
        hoursPerWeek: _hoursController.text,
        deadline: _deadline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _populateFromInitial();

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _titleController,
            label: StartupStrings.title,
            hint: StartupStrings.titleHint,
            validator: Validators.validateOpportunityTitle,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _descriptionController,
            label: StartupStrings.description,
            hint: StartupStrings.descriptionHint,
            maxLines: 5,
            validator: Validators.validateOpportunityDescription,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _locationController,
            label: StartupStrings.location,
            hint: StartupStrings.locationHint,
            validator: Validators.validateOpportunityLocation,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _hoursController,
            label: StartupStrings.hoursPerWeek,
            hint: StartupStrings.hoursHint,
            validator: Validators.validateOpportunityHours,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<WorkMode>(
            initialValue: _workMode,
            decoration: const InputDecoration(labelText: StartupStrings.workMode),
            items: WorkMode.values
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: Text(mode.label),
                  ),
                )
                .toList(),
            onChanged: widget.isSubmitting
                ? null
                : (value) {
                    if (value != null) {
                      setState(() => _workMode = value);
                    }
                  },
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<OpportunityCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: StartupStrings.category),
            items: OpportunityCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.label),
                  ),
                )
                .toList(),
            onChanged: widget.isSubmitting
                ? null
                : (value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
          ),
          const SizedBox(height: AppSpacing.md),
          InputDecorator(
            decoration: const InputDecoration(labelText: StartupStrings.deadline),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(DateFormat.yMMMd().format(_deadline)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: widget.isSubmitting ? null : _pickDeadline,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TagEditor(
            label: StartupStrings.skills,
            hint: StartupStrings.skillsHint,
            items: _skills,
            controller: _skillController,
            onAdd: _addSkill,
            onRemove: (skill) {
              setState(() {
                _skills = _skills.where((item) => item != skill).toList();
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: widget.isSubmitting ? null : _handleSubmit,
            child: widget.isSubmitting
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
