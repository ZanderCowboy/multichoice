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

enum _AuthAction { signIn, google }

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loginFormReady = false;
  bool _hasRequestedPrefill = false;
  _AuthAction? _loadingAction;
  String? _loginButtonMessage;
  bool _isLoginMessageSuccess = false;
  Timer? _loginMessageResetTimer;

  @override
  void initState() {
    super.initState();
    _emailOrUsernameController.addListener(_syncLoginFormValidity);
    _passwordController.addListener(_syncLoginFormValidity);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncLoginFormValidity());
  }

  @override
  void dispose() {
    _loginMessageResetTimer?.cancel();
    _emailOrUsernameController.removeListener(_syncLoginFormValidity);
    _passwordController.removeListener(_syncLoginFormValidity);
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _syncLoginFormValidity() {
    if (!mounted) return;
    final ident = _emailOrUsernameController.text.trim();
    final identOk = ident.isNotEmpty &&
        EmailOrUsernameField.defaultValidator(ident) == null;
    final passOk = _passwordController.text.trim().isNotEmpty;
    final ready = identOk && passOk;
    if (ready != _loginFormReady) {
      setState(() => _loginFormReady = ready);
    }
  }

  void _syncControllersFromState(RegistrationState state) {
    if (_emailOrUsernameController.text != state.email) {
      _emailOrUsernameController.text = state.email;
      _emailOrUsernameController.selection = TextSelection.collapsed(
        offset: _emailOrUsernameController.text.length,
      );
    }
  }

  void _showLoginButtonMessage(String message, {required bool isSuccess}) {
    _loginMessageResetTimer?.cancel();
    setState(() {
      _loginButtonMessage = message;
      _isLoginMessageSuccess = isSuccess;
    });

    _loginMessageResetTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _loginButtonMessage = null;
      });
    });
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
            if (_loadingAction == _AuthAction.signIn) {
              _showLoginButtonMessage(
                'Signed in successfully!',
                isSuccess: true,
              );
            }

            if (_loadingAction != _AuthAction.google) {
              Future<void>.delayed(const Duration(milliseconds: 800), () {
                if (!mounted) return;
                if (widget.isModal) {
                  Navigator.of(this.context).pop();
                } else {
                  this.context.router.popUntilRoot();
                }
              });
            } else {
              if (widget.isModal) {
                Navigator.of(context).pop();
              } else {
                context.router.popUntilRoot();
              }
            }
          } else if (state.isError && state.errorMessage != null) {
            if (_loadingAction == _AuthAction.signIn) {
              _showLoginButtonMessage(
                state.errorMessage!,
                isSuccess: false,
              );
            }
            setState(() => _loadingAction = null);
          } else if (!state.isLoading) {
            setState(() => _loadingAction = null);
          }
        },
        buildWhen: (previous, current) =>
            previous.email != current.email ||
            previous.password != current.password ||
            previous.isLoading != current.isLoading ||
            previous.isSuccess != current.isSuccess ||
            previous.isError != current.isError,
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
            loginFormReady: _loginFormReady,
            isModal: widget.isModal,
            loadingAction: _loadingAction,
            isLoading: state.isLoading,
            loginButtonMessage: _loginButtonMessage,
            isLoginMessageSuccess: _isLoginMessageSuccess,
            onLoginPressed: () {
              setState(() => _loadingAction = _AuthAction.signIn);
              context.read<RegistrationBloc>().add(
                const RegistrationEvent.signInClicked(),
              );
            },
            onGooglePressed: () {
              setState(() => _loadingAction = _AuthAction.google);
              context.read<RegistrationBloc>().add(
                const RegistrationEvent.googleSignInClicked(),
              );
            },
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
    required this.loginFormReady,
    required this.isModal,
    required this.loadingAction,
    required this.isLoading,
    required this.loginButtonMessage,
    required this.isLoginMessageSuccess,
    required this.onLoginPressed,
    required this.onGooglePressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailOrUsernameController;
  final TextEditingController passwordController;
  final bool loginFormReady;
  final bool isModal;
  final _AuthAction? loadingAction;
  final bool isLoading;
  final String? loginButtonMessage;
  final bool isLoginMessageSuccess;
  final VoidCallback onLoginPressed;
  final VoidCallback onGooglePressed;

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
    final promptStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );

    return SingleChildScrollView(
      padding: allPadding8,
      child: AutofillGroup(
        child: Form(
          key: formKey,
          child: BlocBuilder<RegistrationBloc, RegistrationState>(
            buildWhen: (p, c) =>
                p.isLoading != c.isLoading || p.isError != c.isError,
            builder: (context, state) {
              final loginErrorColor = Theme.of(context).colorScheme.error;
              final loginMessageIcon = isLoginMessageSuccess
                  ? Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : Icon(
                      Icons.error_outline,
                      size: 20,
                      color: loginErrorColor,
                    );

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
                      onTap: isLoading
                          ? null
                          : () => _onForgotPassword(context),
                      child: Text(
                        'Forgot Password?',
                        style: context.appTextTheme.hyperlink,
                      ),
                    ),
                  ),
                  gap16,
                  LoginButton(
                    enabled: loginFormReady,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              onLoginPressed();
                            }
                          },
                    isLoading: isLoading && loadingAction == _AuthAction.signIn,
                    overrideLabel: loginButtonMessage,
                    overrideIcon: loginButtonMessage != null
                        ? loginMessageIcon
                        : null,
                  ),
                  gap16,
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: horizontal16,
                        child: Text(
                          'or',
                          style: context.appTextTheme.contrastBody,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  gap16,
                  GoogleSignInButton(
                    onPressed: isLoading ? null : onGooglePressed,
                    isLoading: isLoading && loadingAction == _AuthAction.google,
                  ),
                  gap16,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: promptStyle,
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: context.appTextTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: context.appTextTheme.hyperlink,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (!isLoading) {
                                  unawaited(
                                    context.router.push(
                                      const SignupPageRoute(),
                                    ),
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
      ),
    );
  }
}
