// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:multichoice/app/extensions/extension_getters.dart';
import 'package:multichoice/app/view/theme/theme_extension/app_theme_extension.dart';
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
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      decoration:
          widget.decoration ??
          InputDecoration(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person,
                  color: context.theme.appColors.black,
                ),
                gap4,
                Text(
                  'Username',
                  style: TextStyle(
                    color: context.theme.appColors.black,
                  ),
                ),
              ],
            ),
            // labelText: 'Email label',
            // labelStyle: TextStyle(
            //   color: Colors.black,
            // ),
            floatingLabelStyle: TextStyle(
              color: context.theme.appColors.black,
            ),
            // floatingLabelBehavior: FloatingLabelBehavior.values[0],
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: context.theme.appColors.black,
            ),
            // helperText: 'Helper Text',
            // maintainLabelSize: true,
            // prefixIcon: Icon(Icons.telegram),
            // counterText: 'Counter Text',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            // errorText: 'Error Text',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidUsername ? Colors.green : Colors.deepPurple,
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
