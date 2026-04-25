import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class AccountDeletionPage extends StatefulWidget {
  const AccountDeletionPage({super.key});

  @override
  State<AccountDeletionPage> createState() => _AccountDeletionPageState();
}

class _AccountDeletionPageState extends State<AccountDeletionPage> {
  final _passwordController = TextEditingController();
  bool _passwordValid = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndRequest(BuildContext context) async {
    if (!_passwordValid || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your password to continue')),
      );
      return;
    }

    // TODO: Re-authenticate with Firebase/backend using password when deletion API requires it.

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This submits a deletion request. You will be signed out on this '
          'device. Your data may be removed after the request is processed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Request deletion'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    if (coreSl.isRegistered<ILoginService>()) {
      await coreSl<ILoginService>().deleteLoginInfo();
    }
    await coreSl<IAppStorageService>().clearLastUsedEmail();
    if (!context.mounted) return;
    context.read<AuthNotifier>().notifyAuthChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deletion request submitted. You have been signed out.'),
      ),
    );

    context.router.popUntilRoot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: allPadding16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              gap24,
              Text(
                'Request account deletion',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              gap12,
              Text(
                'You can request that your account and associated data be '
                'deleted. This is processed on our side; you will be signed '
                'out here after submitting.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              gap24,
              PasswordField(
                controller: _passwordController,
                hintText: 'Enter your password to confirm',
                validatePolicy: false,
                onValidityChanged: (valid) {
                  setState(() => _passwordValid = valid);
                },
              ),
              gap24,
              FilledButton(
                onPressed: _passwordValid
                    ? () => _confirmAndRequest(context)
                    : null,
                child: const Text('Request deletion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
