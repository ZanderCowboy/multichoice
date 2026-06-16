import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/view/debug/remote_config_debug_notifier.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

class FeatureFlagsContent extends StatelessWidget {
  const FeatureFlagsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = context.watch<RemoteConfigDebugNotifier>();
    final t = context.t.debug.featureFlags;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          gap12,
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined),
            title: Text(context.t.debug.refetchRemoteConfigTitle),
            subtitle: Text(context.t.debug.refetchRemoteConfigSubtitle),
            onTap: () => _refetchRemoteConfig(context, remoteConfig),
          ),
          if (remoteConfig.hasAnyOverride) ...[
            gap8,
            TextButton.icon(
              onPressed: remoteConfig.clearAllOverrides,
              icon: const Icon(Icons.refresh),
              label: Text(t.clearAllOverrides),
            ),
          ],
          gap12,
          for (final key in FirebaseConfigKeys.featureFlags) ...[
            _FeatureFlagTile(flagKey: key),
            gap8,
          ],
        ],
      ),
    );
  }

  Future<void> _refetchRemoteConfig(
    BuildContext context,
    RemoteConfigDebugNotifier remoteConfig,
  ) async {
    try {
      await coreSl<IFirebaseService>().forceFetchAndActivate();
      if (!context.mounted) return;
      remoteConfig.notifyRemoteConfigRefreshed();
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
  }
}

class _FeatureFlagTile extends StatelessWidget {
  const _FeatureFlagTile({required this.flagKey});

  final FirebaseConfigKeys flagKey;

  @override
  Widget build(BuildContext context) {
    final remoteConfig = context.watch<RemoteConfigDebugNotifier>();
    final t = context.t.debug.featureFlags;
    final remoteValue = remoteConfig.remoteValue(flagKey);
    final effectiveValue = remoteConfig.effectiveValue(flagKey);
    final hasOverride = remoteConfig.hasOverride(flagKey);
    final firebaseLabel =
        remoteValue ? t.firebaseValueOn : t.firebaseValueOff;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.flag_outlined),
          title: Text(_flagTitle(context, flagKey)),
          subtitle: Text(
            hasOverride
                ? '$firebaseLabel · ${flagKey.key} · ${t.overrideActive}'
                : '$firebaseLabel · ${flagKey.key}',
          ),
          value: effectiveValue,
          onChanged: (newValue) => remoteConfig.setOverride(
            key: flagKey,
            value: newValue,
          ),
        ),
        if (hasOverride)
          Padding(
            padding: horizontal16,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => remoteConfig.clearOverride(flagKey),
                icon: const Icon(Icons.refresh),
                label: Text(t.useFirebaseValue),
              ),
            ),
          ),
      ],
    );
  }

  String _flagTitle(BuildContext context, FirebaseConfigKeys key) {
    final t = context.t.debug.featureFlags;
    return switch (key) {
      FirebaseConfigKeys.usePillStyleBanner => t.usePillStyleBanner,
      FirebaseConfigKeys.enableChangelogPage => t.enableChangelogPage,
      FirebaseConfigKeys.feedbackImagesEnabled => t.feedbackImagesEnabled,
      FirebaseConfigKeys.enableUserAccounts => t.enableUserAccounts,
      FirebaseConfigKeys.enableTutorial => t.enableTutorial,
      FirebaseConfigKeys.enableUpdatePrompt => t.enableUpdatePrompt,
      FirebaseConfigKeys.enableAboutPage => t.enableAboutPage,
      _ => key.key,
    };
  }
}
