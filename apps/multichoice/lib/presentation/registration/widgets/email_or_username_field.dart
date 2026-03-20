import 'package:flutter/material.dart';
import 'package:multichoice/presentation/registration/widgets/email_field.dart';
import 'package:multichoice/presentation/registration/widgets/username_field.dart';

/// Combined field that accepts either email or username for login.
class EmailOrUsernameField extends StatelessWidget {
  const EmailOrUsernameField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool enabled;

  static String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or username is required';
    }
    final trimmed = value.trim();
    if (trimmed.contains('@')) {
      return EmailField.defaultValidator(value);
    }
    return UsernameField.defaultValidator(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration:
          decoration ??
          const InputDecoration(
            labelText: 'Email or Username',
            hintText: 'Enter email or username',
            border: OutlineInputBorder(),
          ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      autofocus: autofocus,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator ?? defaultValidator,
    );
  }
}
