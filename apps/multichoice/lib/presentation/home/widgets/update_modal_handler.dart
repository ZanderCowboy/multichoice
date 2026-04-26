import 'dart:async';
import 'dart:developer';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/presentation/home/widgets/update_available_modal.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateModalHandler extends StatefulWidget {
  const UpdateModalHandler({
    required this.builder,
    super.key,
  });

  final WidgetBuilder builder;

  @override
  State<UpdateModalHandler> createState() => _UpdateModalHandlerState();
}

class _UpdateModalHandlerState extends State<UpdateModalHandler> {
  bool _hasScheduledCheck = false;
  bool _hasShownModal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasScheduledCheck) return;
      _hasScheduledCheck = true;
      unawaited(_checkAndShow());
    });
  }

  Future<void> _checkAndShow() async {
    try {
      final firebaseService = coreSl<IFirebaseService>();
      final appInfoService = coreSl<IAppInfoService>();

      // Ensure Remote Config has a chance to fetch before reading values.
      await firebaseService.fetchAndActivate();

      final latestVersion = await firebaseService.getString(
        FirebaseConfigKeys.latestAppVersion,
      );
      final storeUrl = await firebaseService.getString(
        FirebaseConfigKeys.googlePlayStoreUrl,
      );

      final updateAvailable = await appInfoService.isUpdateAvailable(
        latestVersion ?? '',
      );

      if (!mounted || _hasShownModal || !updateAvailable) return;

      _hasShownModal = true;

      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: borderCircular16,
        ),
        builder: (context) => UpdateAvailableModal(
          onLater: () => Navigator.of(context).pop(),
          onUpdate: () async {
            final navigator = Navigator.of(context);
            final url = (storeUrl ?? '').trim();
            if (url.isNotEmpty) {
              final uri = Uri.tryParse(url);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
            navigator.pop();
          },
        ),
      );
    } on Object catch (e) {
      log('Error checking update availability: $e');
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
