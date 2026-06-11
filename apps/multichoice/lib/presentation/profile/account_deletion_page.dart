import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';
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
  void initState() {
    super.initState();
    guardUserAccountsRoute(context);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndRequest(BuildContext context) async {
    if (!_passwordValid || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.common.enterYourPasswordToContinue)),
      );
      return;
    }

    // TODO: Re-authenticate with Firebase/backend using password when deletion API requires it.

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t.profile.deleteConfirmation),
        content: Text(
          context.t.profile.deleteAccountConfirmationBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(context.t.profile.requestDeletion),
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
      SnackBar(
        content: Text(context.t.common.deletionRequestSubmitted),
      ),
    );

    context.router.popUntilRoot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.profile.deleteAccount),
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
                context.t.profile.requestAccountDeletion,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              gap12,
              Text(
                context.t.profile.requestAccountDeletionBody,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              gap24,
              PasswordField(
                controller: _passwordController,
                hintText: context.t.profile.enterPasswordToConfirm,
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
                child: Text(context.t.profile.requestDeletion),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
