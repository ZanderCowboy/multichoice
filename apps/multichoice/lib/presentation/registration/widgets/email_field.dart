// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

class EmailField extends StatefulWidget {
  const EmailField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
    this.onValidityChanged,
    this.autofillHints = const [AutofillHints.email],
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
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  bool _hasTyped = false;
  bool _isValidEmail = false;
  bool _lastNotifiedValid = false;

  String? _validator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return null;
    }
    return (widget.validator ?? EmailField.defaultValidator)(trimmedValue);
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
    final errorColor = appColors.error ?? Colors.red;
    final inactiveBorderColor =
        inputTheme.enabledBorder?.borderSide.color ??
        appColors.textSecondary ??
        appColors.accent ??
        Colors.deepPurple;
    final disabledBorderColor = appColors.disabled ?? Colors.blue;

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
                  Icons.email,
                  color: appColors.iconColor ?? textColor,
                ),
                gap4,
                Text(
                  'Email',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ],
            ),
            floatingLabelStyle: TextStyle(
              color: textColor,
            ),
            hintText: 'Enter your email',
            hintStyle: TextStyle(
              color: textColor,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: textColor,
              ),
            ),
            errorStyle: TextStyle(fontWeight: FontWeight.bold),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidEmail ? successColor : inactiveBorderColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: disabledBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidEmail ? successColor : inactiveBorderColor,
              ),
            ),
          ),
      cursorColor: _isValidEmail ? successColor : textColor,
      cursorErrorColor: errorColor,
      cursorOpacityAnimates: false,
      cursorRadius: Radius.circular(2),
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
        if (_isValidEmail != isValid) {
          setState(() {
            _isValidEmail = isValid;
          });
        }
        if (_lastNotifiedValid != isValid) {
          _lastNotifiedValid = isValid;
          widget.onValidityChanged?.call(isValid);
        }
        widget.onChanged?.call(value);
      },

      autofillHints: widget.autofillHints,
      validator: _validator,
    );
  }
}
