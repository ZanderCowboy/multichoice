import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
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

/// Duration to show success message on button before navigating.
const _successMessageDuration = Duration(milliseconds: 1000);

/// Duration to show "Coming soon" on Google button before resetting.
const _comingSoonDuration = Duration(milliseconds: 1000);

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _signupSuccessMessage;
  String? _googleOverrideLabel;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignup(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Mock success - replace with backend call later
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;
    setState(() {
      _isLoading = false;
      _signupSuccessMessage = 'Registration successful!';
    });

    await Future<void>.delayed(_successMessageDuration);
    if (!context.mounted) return;
    context.router.popUntilRoot();
  }

  Future<void> _onGoogleSignIn() async {
    setState(() => _googleOverrideLabel = 'Coming soon');
    await Future<void>.delayed(_comingSoonDuration);
    if (!mounted) return;
    setState(() => _googleOverrideLabel = null);
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    gap8,
                    EmailField(controller: _emailController),
                    gap16,
                    UsernameField(controller: _usernameController),
                    gap16,
                    PasswordField(
                      controller: _passwordController,
                      showRequirements: true,
                    ),
                    gap24,
                    SignupButton(
                      onPressed: () => _onSignup(context),
                      isLoading: _isLoading,
                      overrideLabel: _signupSuccessMessage,
                      overrideIcon: _signupSuccessMessage != null
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
                      onPressed: _onGoogleSignIn,
                      overrideLabel: _googleOverrideLabel,
                    ),
                    gap16,
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: context.theme.appColors.linkColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (!_isLoading &&
                                      _signupSuccessMessage == null) {
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
