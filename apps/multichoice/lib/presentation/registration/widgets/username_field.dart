// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

class UsernameField extends StatefulWidget {
  const UsernameField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
    this.hintText = 'Enter username',
    this.labelText = 'Username',
    this.onValidityChanged,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool enabled;
  final String hintText;
  final String labelText;
  final ValueChanged<bool>? onValidityChanged;

  static String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 2) {
      return 'Username must be at least 2 characters';
    }
    return null;
  }

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  bool _hasTyped = false;
  bool _isValidUsername = false;

  String? _validator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return null;
    }
    return (widget.validator ?? UsernameField.defaultValidator)(trimmedValue);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final textColor =
        inputTheme.labelStyle?.color ??
        inputTheme.hintStyle?.color ??
        appColors.background ??
        appColors.black ??
        Colors.black;
    final successColor = appColors.success ?? Colors.green;
    final errorColor = appColors.error ?? Colors.red;
    final inactiveBorderColor =
        inputTheme.enabledBorder?.borderSide.color ??
        appColors.background ??
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
                  Icons.person,
                  color: appColors.background ?? textColor,
                ),
                gap4,
                Text(
                  'Username',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ],
            ),
            floatingLabelStyle: TextStyle(
              color: textColor,
            ),
            hintText: widget.hintText,
            errorStyle: TextStyle(fontWeight: FontWeight.bold),
            hintStyle: TextStyle(
              color: textColor,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: textColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidUsername ? successColor : inactiveBorderColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: errorColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: disabledBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidUsername ? successColor : inactiveBorderColor,
              ),
            ),
          ),
      keyboardType: TextInputType.text,
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
        if (_isValidUsername != isValid) {
          setState(() {
            _isValidUsername = isValid;
          });
          widget.onValidityChanged?.call(isValid);
        }

        widget.onChanged?.call(value);
      },
      validator: _validator,
    );
  }
}
