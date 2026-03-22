import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/registration/widgets/email_or_username_field.dart';
import 'package:multichoice/presentation/registration/widgets/google_sign_in_button.dart';
import 'package:multichoice/presentation/registration/widgets/login_button.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:provider/provider.dart';
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

/// Duration to show success message on button before navigating.
const _successMessageDuration = Duration(milliseconds: 1000);

/// Duration to show "Coming soon" on Google button before resetting.
const _comingSoonDuration = Duration(milliseconds: 1000);

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _signInSuccessMessage;
  String? _googleOverrideLabel;

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Mock success - replace with backend call later
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;
    setState(() {
      _isLoading = false;
      _signInSuccessMessage = 'Signed in successfully!';
    });

    if (coreSl.isRegistered<Session>()) {
      coreSl<Session>().storeLoginInfo('debug-access-token');
    }
    context.read<AuthNotifier>().notifyAuthChanged();

    await Future<void>.delayed(_successMessageDuration);
    if (!context.mounted) return;
    if (widget.isModal) {
      Navigator.of(context).pop();
      return;
    }
    context.router.popUntilRoot();
  }

  Future<void> _onGoogleSignIn() async {
    setState(() => _googleOverrideLabel = 'Coming soon');
    await Future<void>.delayed(_comingSoonDuration);
    if (!mounted) return;
    setState(() => _googleOverrideLabel = null);
  }

  void _onForgotPassword(BuildContext context) {
    final email = _emailOrUsernameController.text.trim();
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
    final content = SingleChildScrollView(
      padding: allPadding4,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isModal) gap24,
            EmailOrUsernameField(controller: _emailOrUsernameController),
            gap16,
            PasswordField(
              controller: _passwordController,
              validatePolicy: false,
            ),
            gap8,
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _isLoading || _signInSuccessMessage != null
                    ? null
                    : () => _onForgotPassword(context),
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.theme.appColors.linkColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            gap16,
            LoginButton(
              onPressed: () => _onSignIn(context),
              isLoading: _isLoading,
              overrideLabel: _signInSuccessMessage,
              overrideIcon: _signInSuccessMessage != null
                  ? Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
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
              onPressed: _onGoogleSignIn,
              overrideLabel: _googleOverrideLabel,
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
                        color: context.theme.appColors.linkColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (!_isLoading && _signInSuccessMessage == null) {
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
        ),
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
