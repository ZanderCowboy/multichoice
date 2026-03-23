import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/registration/widgets/email_or_username_field.dart';
import 'package:multichoice/presentation/registration/widgets/google_sign_in_button.dart';
import 'package:multichoice/presentation/registration/widgets/login_button.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.isModal = false,
  });

  final bool isModal;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasRequestedPrefill = false;

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _syncControllersFromState(RegistrationState state) {
    if (_emailOrUsernameController.text != state.email) {
      _emailOrUsernameController.text = state.email;
      _emailOrUsernameController.selection = TextSelection.collapsed(
        offset: _emailOrUsernameController.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocProvider(
      create: (_) => coreSl<RegistrationBloc>(),
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          _syncControllersFromState(state);
          if (state.isSuccess) {
            context.read<AuthNotifier>().notifyAuthChanged();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signed in successfully!')),
            );
            if (widget.isModal) {
              Navigator.of(context).pop();
            } else {
              context.router.popUntilRoot();
            }
          } else if (state.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.email != current.email ||
            previous.password != current.password,
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_hasRequestedPrefill) {
              _hasRequestedPrefill = true;
              context.read<RegistrationBloc>().add(
                const RegistrationEvent.prefillRequested(),
              );
            }
            _syncControllersFromState(state);
          });
          return _LoginPageContent(
            formKey: _formKey,
            emailOrUsernameController: _emailOrUsernameController,
            passwordController: _passwordController,
            isModal: widget.isModal,
          );
        },
      ),
    );

    if (widget.isModal) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(child: content),
    );
  }
}

class _LoginPageContent extends StatelessWidget {
  const _LoginPageContent({
    required this.formKey,
    required this.emailOrUsernameController,
    required this.passwordController,
    required this.isModal,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailOrUsernameController;
  final TextEditingController passwordController;
  final bool isModal;

  void _onForgotPassword(BuildContext context) {
    final email = emailOrUsernameController.text.trim();
    unawaited(
      context.router.push(
        ForgotPasswordPageRoute(
          prePopulatedEmail: email.contains('@') ? email : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: allPadding16,
      child: Form(
        key: formKey,
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          buildWhen: (p, c) =>
              p.isLoading != c.isLoading || p.isError != c.isError,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isModal) gap24,
                EmailOrUsernameField(
                  controller: emailOrUsernameController,
                  onChanged: (value) => context.read<RegistrationBloc>().add(
                    RegistrationEvent.fieldsChanged(
                      field: RegistrationField.email,
                      value: value,
                    ),
                  ),
                ),
                gap16,
                PasswordField(
                  controller: passwordController,
                  validatePolicy: false,
                  onChanged: (value) => context.read<RegistrationBloc>().add(
                    RegistrationEvent.fieldsChanged(
                      field: RegistrationField.password,
                      value: value,
                    ),
                  ),
                ),
                gap8,
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: state.isLoading
                        ? null
                        : () => _onForgotPassword(context),
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.theme.appColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                gap16,
                LoginButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            context.read<RegistrationBloc>().add(
                              const RegistrationEvent.signInClicked(),
                            );
                          }
                        },
                  isLoading: state.isLoading,
                ),
                gap16,
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: horizontal16,
                      child: Text(
                        'or',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                gap16,
                GoogleSignInButton(
                  onPressed: state.isLoading
                      ? null
                      : () => context.read<RegistrationBloc>().add(
                          const RegistrationEvent.googleSignInClicked(),
                        ),
                  isLoading: state.isLoading,
                ),
                gap16,
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: context.theme.appColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (!state.isLoading) {
                                unawaited(
                                  context.router.push(const SignupPageRoute()),
                                );
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
