import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/profile_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';

class TagEditor extends StatelessWidget {
  const TagEditor({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
    this.emptyHint,
  });

  final String label;
  final String hint;
  final String? emptyHint;
  final List<String> items;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filled(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (items.isEmpty)
          Text(
            emptyHint ?? ProfileStrings.notSet,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: items
                .map(
                  (item) => InputChip(
                    label: Text(item),
                    onDeleted: () => onRemove(item),
                    deleteIconColor: AppColors.textSecondary,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
