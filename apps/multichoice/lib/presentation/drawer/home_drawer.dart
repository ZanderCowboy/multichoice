// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/drawer/widgets/export.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _onLogout(BuildContext context) {
    Navigator.of(context).pop();
    if (coreSl.isRegistered<Session>()) {
      coreSl<Session>().deleteLoginInfo();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed out successfully')),
    );
    unawaited(Future<void>.microtask(() => showLoginModal(context)));
  }

  @override
  Widget build(BuildContext context) {
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
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text('Logout'),
                    onTap: () => _onLogout(context),
                  ),
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
