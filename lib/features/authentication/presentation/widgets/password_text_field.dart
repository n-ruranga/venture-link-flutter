import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/shared/widgets/custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscureText,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      prefixIcon: Icons.lock_outline_rounded,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
