// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/registration/utils/password_validator.dart';
import 'package:ui_kit/ui_kit.dart';

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
    this.showErrorText = false,
    this.validatePolicy = true,
    this.onValidityChanged,
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
  final bool showErrorText;
  final bool validatePolicy;
  final ValueChanged<bool>? onValidityChanged;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  bool _hasTyped = false;
  bool _isValidPassword = false;
  String _currentPassword = '';
  final GlobalKey<TooltipState> _passwordRequirementsTooltipKey =
      GlobalKey<TooltipState>();
  static const List<String> _requirements = [
    'At least 8 characters',
    '1 uppercase letter',
    '1 lowercase letter',
    '1 number',
    '1 special character',
  ];

  @override
  void initState() {
    super.initState();
    _currentPassword = widget.controller?.text ?? widget.initialValue ?? '';
    _isValidPassword =
        _currentPassword.trim().isNotEmpty &&
        _validator(_currentPassword.trim()) == null;
  }

  Color _requirementColor({
    required bool hasInput,
    required bool isSatisfied,
  }) {
    if (!hasInput) return context.theme.appColors.white ?? Colors.white;
    return isSatisfied ? Colors.green : Colors.red;
  }

  List<InlineSpan> _buildTooltipRequirements() {
    final trimmed = _currentPassword.trim();
    final hasInput = trimmed.isNotEmpty;
    final unmet = PasswordValidator.getUnmetRequirements(trimmed).toSet();

    return _requirements
        .map(
          (requirement) => TextSpan(
            text: '\n• $requirement',
            style: TextStyle(
              color: _requirementColor(
                hasInput: hasInput,
                isSatisfied: !unmet.contains(requirement),
              ),
            ),
          ),
        )
        .toList();
  }

  Color _infoIconColor() {
    if (_currentPassword.trim().isEmpty) {
      return context.theme.appColors.white ?? Colors.white;
    }
    return _isValidPassword ? Colors.green : Colors.red;
  }

  String? _validator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return null;
    }
    if (widget.validator != null) {
      return widget.validator!(trimmedValue);
    }
    return widget.validatePolicy
        ? PasswordValidator.validate(trimmedValue)
        : _requiredOnly(trimmedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          decoration: (widget.decoration ?? const InputDecoration()).copyWith(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.password,
                  color: context.theme.appColors.black,
                ),
                gap4,
                Text(
                  'Password',
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
            errorMaxLines: 3,
            errorStyle: widget.showErrorText
                ? null
                : const TextStyle(fontSize: 0, height: 0),
            border: const OutlineInputBorder(
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
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValidPassword ? Colors.green : Colors.deepPurple,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 88),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    key: _passwordRequirementsTooltipKey,
                    triggerMode: TooltipTriggerMode.manual,
                    preferBelow: false,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    richMessage: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Password requirements\n',
                          style: TextStyle(
                            color: context.theme.appColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ..._buildTooltipRequirements(),
                      ],
                    ),
                    child: IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: 40,
                        height: 40,
                      ),
                      visualDensity: VisualDensity.compact,
                      padding: zeroPadding,
                      onPressed: () {
                        _passwordRequirementsTooltipKey.currentState
                            ?.ensureTooltipVisible();
                      },
                      icon: Icon(
                        Icons.info_outline,
                        size: 20,
                        color: _infoIconColor(),
                      ),
                    ),
                  ),
                  IconButton(
                    constraints: const BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: zeroPadding,
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  ),
                ],
              ),
            ),
          ),
          cursorColor: context.theme.appColors.black,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _obscureText,
          obscuringCharacter: '*',
          autocorrect: false,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          autovalidateMode: _hasTyped
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          onChanged: (value) {
            final trimmed = value.trim();
            final isValid = trimmed.isNotEmpty && _validator(trimmed) == null;
            final previousValidState = _isValidPassword;

            setState(() {
              _currentPassword = value;
              _hasTyped = _hasTyped || trimmed.isNotEmpty;
              _isValidPassword = isValid;
            });

            if (previousValidState != isValid) {
              widget.onValidityChanged?.call(isValid);
            }

            widget.onChanged?.call(value);
          },
          validator: _validator,
        ),
        // if (widget.showRequirements) ...[
        //   const SizedBox(height: 8),
        //   Text(
        //     'Password requirements: 1 lower case, 1 upper case, 1 number, '
        //     '1 special character, 8 minimum characters.',
        //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //       color: Theme.of(context).colorScheme.onSurfaceVariant,
        //     ),
        //   ),
        // ],
      ],
    );
  }

  static String? _requiredOnly(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }
}
