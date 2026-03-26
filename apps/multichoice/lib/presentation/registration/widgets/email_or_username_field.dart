import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/registration/widgets/email_field.dart';
import 'package:multichoice/presentation/registration/widgets/username_field.dart';
import 'package:ui_kit/ui_kit.dart';

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
    this.autofillHints = const [AutofillHints.username],
  });

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool enabled;
  final ValueChanged<bool>? onValidityChanged;
  final Iterable<String>? autofillHints;

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
  late bool _isEmailInput;

  @override
  void initState() {
    super.initState();
    final initialInput = widget.controller?.text ?? widget.initialValue ?? '';
    _isEmailInput = initialInput.trim().contains('@');
  }

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
    final appColors = context.theme.appColors;
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final textColor =
        inputTheme.labelStyle?.color ??
        inputTheme.hintStyle?.color ??
        appColors.textSecondary ??
        appColors.textPrimary ??
        appColors.black ??
        Colors.black;
    final successColor = appColors.success ?? Colors.green;
    final inactiveBorderColor =
        inputTheme.enabledBorder?.borderSide.color ??
        appColors.textSecondary ??
        appColors.accent ??
        Colors.deepPurple;

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      style: TextStyle(color: textColor),
      decoration:
          widget.decoration ??
          InputDecoration(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isEmailInput ? Icons.email_outlined : Icons.person_outline,
                  color: appColors.iconColor ?? textColor,
                ),
                gap4,
                Text(
                  'Email or Username',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ],
            ),
            hintText: 'Enter email or username',
            labelStyle: TextStyle(color: textColor),
            floatingLabelStyle: TextStyle(color: textColor),
            hintStyle: TextStyle(color: textColor),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidInput ? successColor : inactiveBorderColor,
              ),
            ),
            errorStyle: const TextStyle(fontWeight: FontWeight.bold),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidInput ? successColor : inactiveBorderColor,
              ),
            ),
          ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      autofillHints: widget.autofillHints,
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
        final isEmailInput = trimmed.contains('@');
        if (_isEmailInput != isEmailInput) {
          setState(() {
            _isEmailInput = isEmailInput;
          });
        }

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
