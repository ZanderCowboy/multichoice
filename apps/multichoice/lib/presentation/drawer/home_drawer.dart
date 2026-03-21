import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/drawer/widgets/export.dart';
import 'package:multichoice/presentation/drawer/widgets/logout_tile.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AuthNotifier>();
    final isLoggedIn =
        coreSl.isRegistered<Session>() && coreSl<Session>().isUserLoggedIn();

    return Drawer(
      width: MediaQuery.sizeOf(context).width,
      backgroundColor: context.theme.appColors.background,
      child: SafeArea(
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
                  const Divider(height: 32),
                  const MoreSection(),
                  if (isLoggedIn) ...[
                    const Divider(height: 32),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        unawaited(
                          context.router.push(const ProfilePageRoute()),
                        );
                      },
                    ),
                    const LogoutTile(),
                  ],
                  gap56,
                ],
              ),
            ),
            const AppVersion(),
          ],
        ),
      ),
    );
  }
}
