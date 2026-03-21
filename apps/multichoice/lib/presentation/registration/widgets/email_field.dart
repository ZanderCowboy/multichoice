// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

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

  String? _validator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return null;
    }
    return (widget.validator ?? EmailField.defaultValidator)(trimmedValue);
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
                  Icons.email,
                  color: context.theme.appColors.black,
                ),
                gap4,
                Text(
                  'Email',
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
            hintText: 'Enter your email',
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
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidEmail ? Colors.green : Colors.deepPurple,
              ),
            ),
          ),
      cursorColor: _isValidEmail ? Colors.green : context.theme.appColors.black,
      cursorErrorColor: Colors.red,
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
        widget.onChanged?.call(value);
      },
      validator: _validator,
    );
  }
}
