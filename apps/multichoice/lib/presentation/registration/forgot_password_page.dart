import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/registration/widgets/email_field.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
    this.prePopulatedEmail,
  });

  final String? prePopulatedEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    if (widget.prePopulatedEmail != null && widget.prePopulatedEmail!.isNotEmpty) {
      _emailController.text = widget.prePopulatedEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onResetPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Mock email sent - replace with backend call later
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reset link sent! Check your email or open your mail app.'),
      ),
    );
  }

  void _onGoToResetPage(BuildContext context) {
    unawaited(context.router.push(const ResetPasswordPageRoute()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: _emailSent ? _buildCheckEmailContent(context) : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: allPadding16,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            gap24,
            Text(
              "Enter your email and we'll send you a link to reset your password.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            gap24,
            EmailField(controller: _emailController),
            gap24,
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading
                    ? null
                    : () => _onResetPassword(context),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Reset Link'),
              ),
            ),
            gap16,
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => _onGoToResetPage(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('I have the reset link, go to Reset Password'),
                  Text(
                    '(temp - for testing)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckEmailContent(BuildContext context) {
    return Padding(
      padding: allPadding16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          gap24,
          Icon(
            Icons.mark_email_read_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          gap24,
          Text(
            'Check your email',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          gap12,
          Text(
              "We've sent a password reset link to ${_emailController.text}. "
              'Open your email app or check your inbox.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          gap24,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Open default mail app - platform dependent
                // For now just navigate to reset page as per plan
                _onGoToResetPage(context);
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Email App'),
            ),
          ),
          gap12,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _onGoToResetPage(context),
              child: const Text('Go to Reset Password'),
            ),
          ),
          gap16,
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }
}
