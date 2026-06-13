import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/home/widgets/update_modal_handler.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

class DebugToolsContent extends StatelessWidget {
  const DebugToolsContent({
    required this.onClearStorage,
    super.key,
  });

  final Future<void> Function(BuildContext) onClearStorage;

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.dataset),
            title: Text(context.t.debug.clearStorageDataTitle),
            subtitle: Text(context.t.debug.clearStorageDataSubtitle),
            onTap: () => onClearStorage(context),
          ),
          gap12,
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined),
            title: Text(context.t.debug.refetchRemoteConfigTitle),
            subtitle: Text(context.t.debug.refetchRemoteConfigSubtitle),
            onTap: () async {
              try {
                final firebaseService = coreSl<IFirebaseService>();
                await firebaseService.forceFetchAndActivate();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.t.debug.remoteConfigRefreshed),
                  ),
                );
              } on Object catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.t.common.failedToRefresh(error: e.toString()),
                    ),
                  ),
                );
              }
            },
          ),
          gap12,
          ListTile(
            leading: const Icon(Icons.system_update_alt_outlined),
            title: Text(context.t.debug.showUpdatePromptTitle),
            subtitle: Text(context.t.debug.showUpdatePromptSubtitle),
            onTap: () async {
              await showUpdatePromptForDebug(context);
            },
          ),
          if (isUserAccountsEnabled()) ...[
            gap12,
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: Text(context.t.debug.resetPasswordTitle),
              subtitle: Text(context.t.debug.resetPasswordSubtitle),
              onTap: () => context.router.push(ResetPasswordPageRoute()),
            ),
          ],
          gap12,
          FutureBuilder<bool>(
            future: authNotifier.isUserLoggedIn,
            builder: (context, snapshot) {
              final sessionLoggedIn = snapshot.data ?? false;
              final value = authNotifier.hasDebugOverride
                  ? (authNotifier.debugLoggedInOverride ?? false)
                  : sessionLoggedIn;
              return SwitchListTile(
                secondary: const Icon(Icons.person_outline),
                title: Text(context.t.debug.forceLoggedInTitle),
                subtitle: Text(
                  authNotifier.hasDebugOverride
                      ? context.t.debug.forceLoggedInOverrideActive
                      : context.t.debug.forceLoggedInStoredSession,
                ),
                value: value,
                onChanged: (newValue) => authNotifier.setDebugLoggedInOverride(
                  value: newValue,
                ),
              );
            },
          ),
          if (authNotifier.hasDebugOverride)
            TextButton.icon(
              onPressed: authNotifier.clearDebugLoggedInOverride,
              icon: const Icon(Icons.refresh),
              label: Text(context.t.debug.useRealSessionState),
            ),
        ],
      ),
    );
  }
}
