import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/drawer/widgets/export.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

Future<bool> _drawerSessionLoggedIn() async {
  if (!coreSl.isRegistered<ILoginService>()) return false;
  return coreSl<ILoginService>().isUserLoggedIn();
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _onLogin(BuildContext context) {
    Navigator.of(context).pop();
    unawaited(
      Future<void>.microtask(() {
        if (!context.mounted) return;
        showLoginModal(context);
      }),
    );
  }

  void _onLogout(BuildContext context) {
    Navigator.of(context).pop();
    if (coreSl.isRegistered<ILoginService>()) {
      unawaited(coreSl<ILoginService>().deleteLoginInfo());
    }
    context.read<AuthNotifier>().notifyAuthChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t.auth.signedOutSuccess)),
    );
    unawaited(
      Future<void>.microtask(() {
        if (!context.mounted) return;
        showLoginModal(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();
    return FutureBuilder<bool>(
      key: ValueKey(auth.authEpoch),
      future: _drawerSessionLoggedIn(),
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data ?? false;
        return Drawer(
          width: MediaQuery.sizeOf(context).width,
          backgroundColor: context.theme.appColors.background,
          child: ScaffoldMessenger(
            child: Scaffold(
              backgroundColor: context.theme.appColors.background,
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DrawerHeaderSection(),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          const AppearanceSection(),
                          const Divider(height: 32),
                          const DataSection(),
                          if (isLoggedIn) ...[
                            const Divider(height: 32),
                            const AccountSection(),
                          ],
                          const Divider(height: 32),
                          const MoreSection(),
                          if (isLoggedIn) ...[
                            const Divider(height: 32),
                            ListTile(
                              leading: const Icon(Icons.logout_outlined),
                              title: Text(context.t.auth.logout),
                              onTap: () => _onLogout(context),
                            ),
                          ] else ...[
                            const Divider(height: 32),
                            ListTile(
                              leading: const Icon(Icons.login_outlined),
                              title: Text(context.t.auth.signIn),
                              onTap: () => _onLogin(context),
                            ),
                          ],
                          gap56,
                        ],
                      ),
                    ),
                    const AppVersion(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
