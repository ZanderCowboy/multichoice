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
          child: _ShineCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                gap8,
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: const Text('—'),
                  tileColor: context.theme.appColors.scaffoldBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderCircular12,
                  ),
                ),
                gap12,
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Username'),
                  subtitle: const Text('—'),
                  tileColor: context.theme.appColors.scaffoldBackground,
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
                  tileColor: context.theme.appColors.scaffoldBackground,
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
                  tileColor: context.theme.appColors.scaffoldBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderCircular12,
                  ),
                ),
                gap24,
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthNotifier>().clearDebugLoggedInOverride();
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
            Positioned(
              top: -42,
              left: -84,
              child: Transform.rotate(
                angle: -0.55,
                child: Container(
                  width: 260,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: 0.22),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
