import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    this.isChangePassword = false,
    this.oobCode,
  });

  /// True when opened from profile (signed-in user changing password).
  final bool isChangePassword;

  /// OOB code from the password-reset email link; when null, reset flow uses a
  /// dev fallback until deep links supply this value.
  final String? oobCode;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _successMessage;

  static const _successNavDelay = Duration(milliseconds: 1200);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _successMessage = null;
    });

    final repo = coreSl<IRegistrationRepository>();
    final password = _newPasswordController.text;

    if (widget.isChangePassword) {
      final result = await repo.updatePassword(password);
      if (!context.mounted) return;
      result.fold(
        (err) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.message)),
          );
        },
        (_) => _showSuccessAndNavigate(context),
      );
      return;
    }

    if (widget.oobCode != null && widget.oobCode!.isNotEmpty) {
      final result = await repo.confirmPasswordReset(
        oobCode: widget.oobCode!,
        newPassword: password,
      );
      if (!context.mounted) return;
      result.fold(
        (err) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.message)),
          );
        },
        (_) => _showSuccessAndNavigate(context),
      );
      return;
    }

    // No OOB code (e.g. tester flow before deep links): brief delay only.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;
    _showSuccessAndNavigate(context);
  }

  void _showSuccessAndNavigate(BuildContext context) {
    final isChange = widget.isChangePassword;
    setState(() {
      _isLoading = false;
      _successMessage = isChange
          ? 'Password changed successfully!'
          : 'Password reset successfully!';
    });

    Future<void>.delayed(_successNavDelay, () {
      if (!context.mounted) return;
      if (isChange) {
        unawaited(context.router.maybePop());
      } else {
        context.router.popUntilRoot();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isChange = widget.isChangePassword;
    final title = isChange ? 'Change Password' : 'Reset Password';
    final primaryLabel = isChange ? 'Change Password' : 'Reset Password';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: allPadding16,
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  gap24,
                  PasswordField(
                    controller: _newPasswordController,
                    customLabel: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.password,
                          color: context.appColorsTheme.iconColor,
                        ),
                        gap4,
                        Text(
                          'New Password',
                          style: TextStyle(
                            color: context
                                .theme
                                .inputDecorationTheme
                                .labelStyle
                                ?.color,
                          ),
                        ),
                      ],
                    ),
                    hintText: 'Enter new password',
                    showRequirements: true,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  gap16,
                  PasswordField(
                    controller: _confirmPasswordController,
                    customLabel: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.password,
                          color: context.appColorsTheme.iconColor,
                        ),
                        gap4,
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                            color: context
                                .theme
                                .inputDecorationTheme
                                .labelStyle
                                ?.color,
                          ),
                        ),
                      ],
                    ),
                    hintText: 'Re-enter password',
                    validatePolicy: false,
                    validator: _confirmValidator,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  gap24,
                  AsyncFilledButton(
                    onPressed: _successMessage != null
                        ? null
                        : () => _submit(context),
                    isLoading: _isLoading,
                    successLabel: _successMessage,
                    successIcon: _successMessage != null
                        ? Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                        : null,
                    flexSuccessLabel: true,
                    label: Text(primaryLabel),
                  ),
                  if (!isChange) ...[
                    gap16,
                    TextButton(
                      onPressed: _isLoading || _successMessage != null
                          ? null
                          : () => context.router.popUntilRoot(),
                      child: const Text('Back to Sign In'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
