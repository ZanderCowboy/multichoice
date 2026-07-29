import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// Whether sign-in, sign-up, password, and profile flows are enabled.
bool isUserAccountsEnabled() {
  if (!coreSl.isRegistered<IFirebaseService>()) return false;
  return coreSl<IFirebaseService>().isEnabled(
    FirebaseConfigKeys.enableUserAccounts,
  );
}

/// Pops the current route on the next frame when user accounts are disabled.
void guardUserAccountsRoute(BuildContext context) {
  if (isUserAccountsEnabled()) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    unawaited(Navigator.of(context).maybePop());
  });
}
