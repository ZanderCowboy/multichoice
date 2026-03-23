import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _email;
  String? _username;
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProfile());
  }

  Future<void> _loadProfile() async {
    if (!coreSl.isRegistered<ILoginService>()) {
      if (mounted) {
        setState(() {
          _loaded = true;
        });
      }
      return;
    }

    final session = coreSl<ILoginService>();
    var email = await session.getProfileEmail();
    final username = await session.getProfileUsername();
    if (email == null || email.isEmpty) {
      email = await coreSl<IAppStorageService>().lastUsedEmail;
    }

    if (!mounted) return;
    setState(() {
      _email = email;
      _username = username;
      _loaded = true;
    });
  }

  String _display(String? value) =>
      (value != null && value.isNotEmpty) ? value : '—';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            if (!context.mounted) return;
            context.router.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: allPadding16,
          child: _ShineCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_loaded)
                  const Center(
                    child: Padding(
                      padding: allPadding24,
                      child: CircularProgressIndicator(),
                    ),
                  )
                else ...[
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(_display(_email)),
                    tileColor: context.theme.appColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: borderCircular12,
                    ),
                  ),
                  gap12,
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Username'),
                    subtitle: Text(_display(_username)),
                    tileColor: context.theme.appColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: borderCircular12,
                    ),
                  ),
                  gap12,
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await context.router.push(
                        const ResetPasswordPageRoute(),
                      );
                      if (context.mounted) {
                        await _loadProfile();
                      }
                    },
                    tileColor: context.theme.appColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: borderCircular12,
                    ),
                  ),
                  gap12,
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: context.appColorsTheme.error,
                    ),
                    title: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: context.appColorsTheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await context.router.push(
                        const AccountDeletionPageRoute(),
                      );
                      if (context.mounted) {
                        await _loadProfile();
                      }
                    },
                    tileColor: context.theme.appColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: borderCircular12,
                    ),
                  ),
                  gap24,
                  OutlinedButton.icon(
                    onPressed: () async {
                      if (coreSl.isRegistered<ILoginService>()) {
                        await coreSl<ILoginService>().deleteLoginInfo();
                      }
                      if (!context.mounted) return;
                      context.read<AuthNotifier>().notifyAuthChanged();
                      if (!context.mounted) return;
                      context.router.popUntilRoot();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signed out successfully'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout_outlined),
                    label: const Text('Sign Out'),
                  ),
                ],
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
