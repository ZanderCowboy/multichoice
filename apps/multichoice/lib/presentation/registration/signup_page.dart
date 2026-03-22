import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
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

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasRequestedPrefill = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<RegistrationBloc>(),
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (!_hasRequestedPrefill) {
            _hasRequestedPrefill = true;
            context.read<RegistrationBloc>().add(
              const RegistrationEvent.prefillRequested(),
            );
          }
          _syncControllersFromState(state);
          if (state.isSuccess) {
            context.read<AuthNotifier>().notifyAuthChanged();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful!')),
            );
            context.router.popUntilRoot();
          } else if (state.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.email != current.email ||
            previous.username != current.username ||
            previous.password != current.password,
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncControllersFromState(state);
          });
          return _SignupPageContent(
            formKey: _formKey,
            emailController: _emailController,
            usernameController: _usernameController,
            passwordController: _passwordController,
          );
        },
      ),
    );
  }
}

class _SignupPageContent extends StatelessWidget {
  const _SignupPageContent({
    required this.formKey,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

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
              child: Form(
                key: formKey,
                child: BlocBuilder<RegistrationBloc, RegistrationState>(
                  buildWhen: (p, c) =>
                      p.isLoading != c.isLoading ||
                      p.isError != c.isError ||
                      p.isSuccess != c.isSuccess,
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        gap8,
                        EmailField(
                          controller: emailController,
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
                          controller: usernameController,
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
                          controller: passwordController,
                          showRequirements: true,
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
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<RegistrationBloc>().add(
                                      const RegistrationEvent.signupClicked(),
                                    );
                                  }
                                },
                          isLoading: state.isLoading,
                          overrideLabel: state.isSuccess
                              ? 'Registration successful!'
                              : null,
                          overrideIcon: state.isSuccess
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
                                      if (!state.isLoading &&
                                          !state.isSuccess) {
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
                    );
                  },
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
