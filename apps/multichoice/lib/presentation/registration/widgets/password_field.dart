import 'package:flutter/material.dart';
import 'package:multichoice/presentation/registration/utils/password_validator.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
    this.labelText = 'Password',
    this.hintText = 'Enter password',
    this.showRequirements = false,
    this.validatePolicy = true,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool enabled;
  final String labelText;
  final String hintText;
  final bool showRequirements;
  final bool validatePolicy;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          decoration: (widget.decoration ?? const InputDecoration())
              .copyWith(
                labelText: widget.labelText,
                hintText: widget.hintText,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() => _obscureText = !_obscureText);
                  },
                ),
              ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: _obscureText,
          autocorrect: false,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          validator: widget.validator ??
              (widget.validatePolicy ? PasswordValidator.validate : _requiredOnly),
        ),
        if (widget.showRequirements) ...[
          const SizedBox(height: 8),
          Text(
            'Password requirements: 1 lower case, 1 upper case, 1 number, '
            '1 special character, 8 minimum characters.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }

  static String? _requiredOnly(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }
}
