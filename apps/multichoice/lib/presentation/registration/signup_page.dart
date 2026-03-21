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

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

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
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );
    context.router.popUntilRoot();
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  ),
                  gap16,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                if (!_isLoading) {
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                ),
              ),
              child: child,
            ),
            // Positioned(
            //   top: -42,
            //   left: -84,
            //   child: Transform.rotate(
            //     angle: -0.55,
            //     child: Container(
            //       width: 260,
            //       height: 96,
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //           colors: [
            //             Colors.white.withValues(alpha: 0),
            //             Colors.white.withValues(alpha: 0.22),
            //             Colors.white.withValues(alpha: 0),
            //             // ?context.theme.appColors.background?.withValues(
            //             //   alpha: 0,
            //             // ),
            //             // ?context.theme.appColors.background?.withValues(
            //             //   alpha: 0.22,
            //             // ),
            //             // ?context.theme.appColors.background?.withValues(
            //             //   alpha: 0,
            //             // ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
