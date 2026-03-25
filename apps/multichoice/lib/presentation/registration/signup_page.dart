// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/registration/utils/password_validator.dart';
import 'package:multichoice/presentation/registration/widgets/email_field.dart';
import 'package:multichoice/presentation/registration/widgets/google_sign_in_button.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:multichoice/presentation/registration/widgets/signup_button.dart';
import 'package:multichoice/presentation/registration/widgets/username_field.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

enum _AuthAction { signup, google }

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasOpenedSignupForm = false;
  _AuthAction? _loadingAction;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _syncControllersFromState(RegistrationState state) {
    if (_emailController.text != state.email) {
      _emailController.text = state.email;
      _emailController.selection = TextSelection.collapsed(
        offset: _emailController.text.length,
      );
    }
    if (_usernameController.text != state.username) {
      _usernameController.text = state.username;
      _usernameController.selection = TextSelection.collapsed(
        offset: _usernameController.text.length,
      );
    }
    if (_passwordController.text != state.password) {
      _passwordController.text = state.password;
      _passwordController.selection = TextSelection.collapsed(
        offset: _passwordController.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<RegistrationBloc>(),
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          _syncControllersFromState(state);
          if (state.isSuccess) {
            context.read<AuthNotifier>().notifyAuthChanged();
            if (_loadingAction == _AuthAction.google) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed in successfully!')),
              );
              context.router.popUntilRoot();
            } else {
              Future<void>.delayed(const Duration(milliseconds: 800), () {
                if (!mounted) return;
                context.router.popUntilRoot();
              });
            }
          } else if (state.isError && state.errorMessage != null) {
            setState(() => _loadingAction = null);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          } else if (!state.isLoading) {
            setState(() => _loadingAction = null);
          }
        },
        buildWhen: (previous, current) =>
            previous.email != current.email ||
            previous.username != current.username ||
            previous.password != current.password ||
            previous.isLoading != current.isLoading ||
            previous.isSuccess != current.isSuccess,
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_hasOpenedSignupForm) {
              _hasOpenedSignupForm = true;
              context.read<RegistrationBloc>().add(
                const RegistrationEvent.signupFormOpened(),
              );
            }
            _syncControllersFromState(state);
          });
          return _SignupPageContent(
            formKey: _formKey,
            emailController: _emailController,
            usernameController: _usernameController,
            passwordController: _passwordController,
            loadingAction: _loadingAction,
            isLoading: state.isLoading,
            isSuccess: state.isSuccess,
            onSignupPressed: () {
              setState(() => _loadingAction = _AuthAction.signup);
              context.read<RegistrationBloc>().add(
                const RegistrationEvent.signupClicked(),
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
  }
}

class _SignupPageContent extends StatefulWidget {
  const _SignupPageContent({
    required this.formKey,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.loadingAction,
    required this.isLoading,
    required this.isSuccess,
    required this.onSignupPressed,
    required this.onGooglePressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final _AuthAction? loadingAction;
  final bool isLoading;
  final bool isSuccess;
  final VoidCallback onSignupPressed;
  final VoidCallback onGooglePressed;

  @override
  State<_SignupPageContent> createState() => _SignupPageContentState();
}

class _SignupPageContentState extends State<_SignupPageContent> {
  bool _emailValid = false;
  bool _usernameValid = false;
  bool _passwordValid = false;

  bool get _formReady => _emailValid && _usernameValid && _passwordValid;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_onControllerTextChanged);
    widget.usernameController.addListener(_onControllerTextChanged);
    widget.passwordController.addListener(_onControllerTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onControllerTextChanged();
    });
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_onControllerTextChanged);
    widget.usernameController.removeListener(_onControllerTextChanged);
    widget.passwordController.removeListener(_onControllerTextChanged);
    super.dispose();
  }

  void _onControllerTextChanged() {
    if (!mounted) return;
    final email = widget.emailController.text.trim();
    final emailOk =
        email.isNotEmpty && EmailField.defaultValidator(email) == null;
    final user = widget.usernameController.text.trim();
    final userOk =
        user.isNotEmpty && UsernameField.defaultValidator(user) == null;
    final passOk = PasswordValidator.isValid(widget.passwordController.text);
    setState(() {
      _emailValid = emailOk;
      _usernameValid = userOk;
      _passwordValid = passOk;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final signupInputTheme = theme.inputDecorationTheme.copyWith(
      labelStyle: TextStyle(color: colorScheme.onSurface),
      floatingLabelStyle: TextStyle(color: colorScheme.onSurface),
      hintStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.72),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.onSurface.withValues(alpha: 0.35),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: allPadding16,
          child: _ShineCard(
            child: Theme(
              data: theme.copyWith(inputDecorationTheme: signupInputTheme),
              child: AutofillGroup(
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      gap8,
                      EmailField(
                        controller: widget.emailController,
                        onValidityChanged: (valid) {
                          setState(() => _emailValid = valid);
                        },
                        onChanged: (value) =>
                            context.read<RegistrationBloc>().add(
                              RegistrationEvent.fieldsChanged(
                                field: RegistrationField.email,
                                value: value,
                              ),
                            ),
                      ),
                      gap16,
                      UsernameField(
                        controller: widget.usernameController,
                        onValidityChanged: (valid) {
                          setState(() => _usernameValid = valid);
                        },
                        onChanged: (value) =>
                            context.read<RegistrationBloc>().add(
                              RegistrationEvent.fieldsChanged(
                                field: RegistrationField.username,
                                value: value,
                              ),
                            ),
                      ),
                      gap16,
                      PasswordField(
                        controller: widget.passwordController,
                        showRequirements: true,
                        autofillHints: const [AutofillHints.newPassword],
                        onValidityChanged: (valid) {
                          setState(() => _passwordValid = valid);
                        },
                        onChanged: (value) =>
                            context.read<RegistrationBloc>().add(
                              RegistrationEvent.fieldsChanged(
                                field: RegistrationField.password,
                                value: value,
                              ),
                            ),
                      ),
                      gap24,
                      SignupButton(
                        enabled: _formReady,
                        onPressed: widget.isLoading
                            ? null
                            : () {
                                if (widget.formKey.currentState!.validate()) {
                                  widget.onSignupPressed();
                                }
                              },
                        isLoading:
                            widget.isLoading &&
                            widget.loadingAction == _AuthAction.signup,
                        overrideLabel:
                            widget.isSuccess &&
                                widget.loadingAction == _AuthAction.signup
                            ? 'Registration successful!'
                            : null,
                        overrideIcon:
                            widget.isSuccess &&
                                widget.loadingAction == _AuthAction.signup
                            ? Icon(
                                Icons.check_circle_outline,
                                size: 20,
                                color: colorScheme.onPrimary,
                              )
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
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      gap16,
                      GoogleSignInButton(
                        onPressed: widget.isLoading
                            ? null
                            : widget.onGooglePressed,
                        isLoading:
                            widget.isLoading &&
                            widget.loadingAction == _AuthAction.google,
                      ),
                      gap16,
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                            children: [
                              const TextSpan(
                                text: 'Already have an account? ',
                              ),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: context.theme.appColors.linkColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    if (!widget.isLoading &&
                                        !widget.isSuccess) {
                                      await context.router.replace(
                                        LoginPageRoute(),
                                      );
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShineCard extends StatelessWidget {
  const _ShineCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderCircular16,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderCircular16,
        child: Stack(
          children: [
            Container(
              padding: allPadding20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                ),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
