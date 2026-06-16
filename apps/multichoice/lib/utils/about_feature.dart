import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// Whether the full About page (with RC-driven links) is enabled.
bool isAboutPageEnabled() {
  if (!coreSl.isRegistered<IFirebaseService>()) return false;
  return coreSl<IFirebaseService>().isEnabled(
    FirebaseConfigKeys.enableAboutPage,
  );
}

/// Pops the current route on the next frame when the About page is disabled.
void guardAboutPageRoute(BuildContext context) {
  if (isAboutPageEnabled()) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    unawaited(Navigator.of(context).maybePop());
  });
}
