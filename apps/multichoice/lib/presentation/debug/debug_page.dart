import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(child: Text('Not available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: const _DebugBody(),
    );
  }
}

class _DebugBody extends StatelessWidget {
  const _DebugBody();

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();

    return SafeArea(
      child: Padding(
        padding: allPadding16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Debug only – accessible via double-tap or long-press on version',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            gap24,
            ListTile(
              leading: const Icon(Icons.dataset),
              title: const Text('Clear Storage Data'),
              subtitle: const Text(
                'Clear any data stored in SharedPreferences',
              ),
              onTap: () => _clearStorageData(context),
            ),
            gap12,
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Reset Password'),
              subtitle: const Text('Test reset password flow'),
              onTap: () => context.router.push(const ResetPasswordPageRoute()),
            ),
            gap12,
            SwitchListTile(
              secondary: const Icon(Icons.person_outline),
              title: const Text('Force Logged In (debug)'),
              subtitle: Text(
                authNotifier.hasDebugOverride
                    ? 'Manual override active'
                    : 'Using stored session state',
              ),
              value: authNotifier.isUserLoggedIn,
              onChanged: authNotifier.setDebugLoggedInOverride,
            ),
            if (authNotifier.hasDebugOverride)
              TextButton.icon(
                onPressed: authNotifier.clearDebugLoggedInOverride,
                icon: const Icon(Icons.refresh),
                label: const Text('Use real session state'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearStorageData(BuildContext context) async {
    if (!kDebugMode) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Storage Data'),
        content: const Text(
          'Are you sure you want to clear all storage data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await coreSl<IAppStorageService>().clearAllData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage data cleared successfully')),
        );
      }
    }
  }
}
