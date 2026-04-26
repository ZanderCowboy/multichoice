import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  static const _successNavDelay = Duration(milliseconds: 1200);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateOnSuccess(BuildContext context) {
    Future<void>.delayed(_successNavDelay, () {
      if (!context.mounted) return;
      if (widget.isChangePassword) {
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

    return BlocProvider(
      create: (_) => coreSl<ResetPasswordBloc>(),
      child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
          if (state.shouldNavigateOnSuccess) {
            context.read<ResetPasswordBloc>().add(
              const ResetPasswordEvent.successConsumed(),
            );
            _navigateOnSuccess(context);
          }
        },
        builder: (context, state) {
          final validation = coreSl<ICredentialValidationService>();
          final canSubmitReset =
              validation.validatePassword(state.newPassword) == null &&
              validation.validatePasswordConfirmation(
                password: state.newPassword,
                confirmation: state.confirmPassword,
              ) ==
                  null;

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
                        onChanged: (value) =>
                            context.read<ResetPasswordBloc>().add(
                              ResetPasswordEvent.newPasswordChanged(value),
                            ),
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
                        autofillHints: const [AutofillHints.newPassword],
                        onChanged: (value) =>
                            context.read<ResetPasswordBloc>().add(
                              ResetPasswordEvent.confirmPasswordChanged(value),
                            ),
                      ),
                      gap24,
                      AsyncFilledButton(
                        onPressed: state.successMessage != null
                            ? null
                            : () => context.read<ResetPasswordBloc>().add(
                                ResetPasswordEvent.submitPressed(
                                  isChangePassword: widget.isChangePassword,
                                  oobCode: widget.oobCode,
                                ),
                              ),
                        enabled: canSubmitReset,
                        isLoading: state.isLoading,
                        successLabel: state.successMessage,
                        successIcon: state.successMessage != null
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
                          onPressed:
                              state.isLoading || state.successMessage != null
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
          );
        },
      ),
    );
  }
}
