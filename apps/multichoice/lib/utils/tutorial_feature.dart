import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// Whether the guided product-tour journey is enabled.
bool isTutorialEnabled() {
  if (!coreSl.isRegistered<IFirebaseService>()) return false;
  return coreSl<IFirebaseService>().isEnabled(
    FirebaseConfigKeys.enableTutorial,
  );
}

/// Pops the current route on the next frame when the tutorial is disabled.
void guardTutorialRoute(BuildContext context) {
  if (isTutorialEnabled()) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    unawaited(Navigator.of(context).maybePop());
  });
}
