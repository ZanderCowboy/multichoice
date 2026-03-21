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
    if (!coreSl.isRegistered<Session>()) {
      if (mounted) {
        setState(() {
          _loaded = true;
        });
      }
      return;
    }

    final session = coreSl<Session>();
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
              if (!_loaded)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
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
                gap24,
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await context.router.push(const ResetPasswordPageRoute());
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
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(color: context.theme.appColors.error),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await context.router.push(const AccountDeletionPageRoute());
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
                    if (coreSl.isRegistered<Session>()) {
                      await coreSl<Session>().deleteLoginInfo();
                    }
                    if (!context.mounted) return;
                    context.read<AuthNotifier>().notifyAuthChanged();
                    if (!context.mounted) return;
                    context.router.popUntilRoot();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed out successfully')),
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
    );
  }
}
