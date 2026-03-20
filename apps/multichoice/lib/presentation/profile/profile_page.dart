import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: const Text('—'),
                tileColor: context.theme.appColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: borderCircular12,
                ),
              ),
              gap12,
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Username'),
                subtitle: const Text('—'),
                tileColor: context.theme.appColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: borderCircular12,
                ),
              ),
              gap24,
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
                tileColor: context.theme.appColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: borderCircular12,
                ),
              ),
              gap12,
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  'Delete Account',
                  style: TextStyle(color: context.theme.appColors.error),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await context.router.push(const AccountDeletionPageRoute());
                },
                tileColor: context.theme.appColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: borderCircular12,
                ),
              ),
              gap24,
              OutlinedButton.icon(
                onPressed: () {
                  if (coreSl.isRegistered<Session>()) {
                    coreSl<Session>().deleteLoginInfo();
                  }
                  context.read<AuthNotifier>().notifyAuthChanged();
                  context.router.popUntilRoot();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out successfully')),
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
