import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout_outlined),
      title: Text(context.t.auth.logout),
      onTap: () => _onLogout(context),
    );
  }

  Future<void> _onLogout(BuildContext context) async {
    Navigator.of(context).pop();
    context.read<AuthNotifier>().clearDebugLoggedInOverride();
    if (coreSl.isRegistered<ILoginService>()) {
      await coreSl<ILoginService>().deleteLoginInfo();
    }
    if (!context.mounted) return;
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
}
