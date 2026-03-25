import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
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
            title: const Text('Clear Storage Data'),
            subtitle: const Text(
              'Clear any data stored in SharedPreferences',
            ),
            onTap: () => onClearStorage(context),
          ),
          gap12,
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Reset Password'),
            subtitle: const Text('Test reset password flow'),
            onTap: () => context.router.push(ResetPasswordPageRoute()),
          ),
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
                title: const Text('Force Logged In (debug)'),
                subtitle: Text(
                  authNotifier.hasDebugOverride
                      ? 'Manual override active'
                      : 'Using stored session state',
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
              label: const Text('Use real session state'),
            ),
        ],
      ),
    );
  }
}
