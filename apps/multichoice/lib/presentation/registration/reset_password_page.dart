import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/localize_core_message.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    this.isChangePassword = false,
    this.isSetPassword = false,
    this.oobCode,
  });

  /// True when opened from profile (signed-in user changing password).
  final bool isChangePassword;

  /// True when the account has no password provider (Google-only).
  final bool isSetPassword;

  /// OOB code from the password-reset email link.
  final String? oobCode;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  static const _successNavDelay = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    guardUserAccountsRoute(context);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isEmailResetFlow =>
      !widget.isChangePassword &&
      widget.oobCode != null &&
      widget.oobCode!.isNotEmpty;

  void _exitToHome(BuildContext context) {
    context.router.popUntilRoot();
  }

  void _navigateToSignInAfterSuccess(BuildContext context) {
    context.router.popUntilRoot();
    unawaited(context.router.push(LoginPageRoute()));
  }

  void _navigateOnSuccess(BuildContext context) {
    Future<void>.delayed(_successNavDelay, () {
      if (!context.mounted) return;
      if (widget.isChangePassword) {
        unawaited(context.router.maybePop());
      } else if (_isEmailResetFlow) {
        _navigateToSignInAfterSuccess(context);
      } else {
        context.router.popUntilRoot();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isChange = widget.isChangePassword;
    final isSet = widget.isSetPassword;
    final title = isChange
        ? (isSet
              ? context.t.profile.setPassword
              : context.t.profile.updatePassword)
        : context.t.profile.resetPassword;
    final primaryLabel = title;

    return BlocProvider(
      create: (_) => coreSl<ResetPasswordBloc>(),
      child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  localizeCoreMessage(context, state.errorMessage!),
                ),
              ),
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
                  null &&
              (!isChange ||
                  isSet ||
                  validation.validatePasswordRequired(state.currentPassword) ==
                      null);

          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: _isEmailResetFlow
                    ? () => _exitToHome(context)
                    : () => context.router.maybePop(),
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
                      if (isChange && !isSet) ...[
                        PasswordField(
                          controller: _currentPasswordController,
                          customLabel: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                color: context.appColorsTheme.iconColor,
                              ),
                              gap4,
                              Text(
                                context.t.profile.enterPasswordToConfirm,
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
                          hintText: context.t.profile.enterPasswordToConfirm,
                          onChanged: (value) =>
                              context.read<ResetPasswordBloc>().add(
                                ResetPasswordEvent.currentPasswordChanged(
                                  value,
                                ),
                              ),
                        ),
                        gap16,
                      ],
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
                              context.t.profile.newPassword,
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
                        hintText: context.t.profile.enterNewPassword,
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
                              context.t.profile.confirmPassword,
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
                        hintText: context.t.auth.reenterPassword,
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
                                  isSetPassword: widget.isSetPassword,
                                  oobCode: widget.oobCode,
                                ),
                              ),
                        enabled: canSubmitReset,
                        isLoading: state.isLoading,
                        successLabel: state.successMessage != null
                            ? localizeCoreMessage(
                                context,
                                state.successMessage!,
                              )
                            : null,
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
                              : () => _isEmailResetFlow
                              ? _exitToHome(context)
                              : context.router.popUntilRoot(),
                          child: Text(
                            _isEmailResetFlow
                                ? context.t.common.goHome
                                : context.t.auth.backToSignIn,
                          ),
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
