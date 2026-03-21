import 'package:flutter/material.dart';
import 'package:multichoice/presentation/registration/widgets/email_field.dart';
import 'package:multichoice/presentation/registration/widgets/username_field.dart';

/// Combined field that accepts either email or username for login.
class EmailOrUsernameField extends StatefulWidget {
  const EmailOrUsernameField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
    this.onValidityChanged,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool enabled;
  final ValueChanged<bool>? onValidityChanged;

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
  State<EmailOrUsernameField> createState() => _EmailOrUsernameFieldState();
}

class _EmailOrUsernameFieldState extends State<EmailOrUsernameField> {
  bool _hasTyped = false;
  bool _isValidInput = false;

  String? _validator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return null;
    }
    return (widget.validator ?? EmailOrUsernameField.defaultValidator)(
      trimmedValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      decoration:
          widget.decoration ??
          InputDecoration(
            labelText: 'Email or Username',
            hintText: 'Enter email or username',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidInput ? Colors.green : Colors.deepPurple,
              ),
            ),
          ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      autovalidateMode: _hasTyped
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      onChanged: (value) {
        if (!_hasTyped && value.trim().isNotEmpty) {
          setState(() {
            _hasTyped = true;
          });
        }

        final trimmed = value.trim();
        final isValid = trimmed.isNotEmpty && _validator(trimmed) == null;
        if (_isValidInput != isValid) {
          setState(() {
            _isValidInput = isValid;
          });
          widget.onValidityChanged?.call(isValid);
        }

        widget.onChanged?.call(value);
      },
      validator: _validator,
    );
  }
}
