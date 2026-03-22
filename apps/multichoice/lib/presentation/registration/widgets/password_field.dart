// ignore_for_file: avoid_redundant_argument_values

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
    this.customLabel,
    this.labelText = 'Password',
    this.hintText = 'Enter password',
    this.showRequirements = false,
    this.showErrorText = false,
    this.validatePolicy = true,
    this.onValidityChanged,
    this.suffixIconAreaWidth = 92,
  }); // TODO: Add assertion

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool enabled;
  final Widget? customLabel;
  final String labelText;
  final String? hintText;
  final bool showRequirements;
  final bool showErrorText;
  final bool validatePolicy;
  final ValueChanged<bool>? onValidityChanged;

  /// Horizontal space reserved for the info + visibility controls so the field
  /// width stays stable when the eye icon appears.
  final double suffixIconAreaWidth;

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
    final appColors = context.theme.appColors;
    if (!hasInput) {
      return appColors.textPrimary ?? appColors.white ?? Colors.white;
    }
    return isSatisfied
        ? appColors.success ?? Colors.green
        : appColors.error ?? Colors.red;
  }

  /// Returns true if the password meets the full strength policy:
  /// - At least 8 characters
  /// - 1 uppercase letter
  /// - 1 lowercase letter
  /// - 1 number
  /// - 1 special character
  ///
  /// Used only for policy success styling;
  bool get _meetsPolicy {
    final trimmed = _currentPassword.trim();
    return trimmed.isNotEmpty && PasswordValidator.isValid(trimmed);
  }

  Color _policyBorderColor({
    required Color successColor,
    required Color inactiveColor,
    required Color errorColor,
  }) {
    final trimmed = _currentPassword.trim();
    if (trimmed.isEmpty) return inactiveColor;
    return PasswordValidator.isValid(trimmed) ? successColor : errorColor;
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
    final appColors = context.theme.appColors;
    if (_currentPassword.trim().isEmpty) {
      return appColors.ternary ?? Colors.white;
    }
    return _meetsPolicy
        ? appColors.success ?? Colors.green
        : appColors.error ?? Colors.red;
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
    final hasPasswordInput = _currentPassword.trim().isNotEmpty;
    final suffixWidth = widget.suffixIconAreaWidth;
    final policyBorderColor = _policyBorderColor(
      successColor: successColor,
      inactiveColor: inactiveBorderColor,
      errorColor: errorColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          style: TextStyle(color: textColor),
          decoration: (widget.decoration ?? const InputDecoration()).copyWith(
            label:
                widget.customLabel ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.password,
                      color: appColors.iconColor ?? textColor,
                    ),
                    gap4,
                    Text(
                      'Password',
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
            floatingLabelStyle: TextStyle(
              color: textColor,
            ),
            hintText: widget.hintText ?? 'Enter your password',
            hintStyle: TextStyle(
              color: textColor,
            ),

            errorMaxLines: 3,
            errorStyle: widget.showErrorText
                ? null
                : const TextStyle(fontSize: 0, height: 0),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: policyBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: policyBorderColor),
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
              borderSide: BorderSide(color: disabledBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: policyBorderColor),
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: suffixWidth,
              maxWidth: suffixWidth,
              minHeight: 48,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (hasPasswordInput)
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
                    )
                  else
                    const SizedBox.shrink(),
                  if (widget.showRequirements)
                    Tooltip(
                      key: _passwordRequirementsTooltipKey,
                      triggerMode: TooltipTriggerMode.manual,
                      preferBelow: true,
                      richMessage: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Password requirements\n',
                            style: TextStyle(
                              color: appColors.textPrimary ?? appColors.white,
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
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          cursorColor: textColor,
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
      ],
    );
  }

  static String? _requiredOnly(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }
}
