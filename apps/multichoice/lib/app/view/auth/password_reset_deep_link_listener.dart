import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';

/// Listens for Firebase password-reset deep links and opens the reset page.
class PasswordResetDeepLinkListener extends StatefulWidget {
  const PasswordResetDeepLinkListener({
    required this.router,
    required this.child,
    super.key,
  });

  final StackRouter router;
  final Widget child;

  @override
  State<PasswordResetDeepLinkListener> createState() =>
      _PasswordResetDeepLinkListenerState();
}

class _PasswordResetDeepLinkListenerState
    extends State<PasswordResetDeepLinkListener> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _lastHandledOobCode;
  bool _isOpeningResetPage = false;

  @override
  void initState() {
    super.initState();
    if (!isUserAccountsEnabled()) {
      return;
    }
    // Subscribe before any async read so cold-start links are not missed.
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleUri);
    unawaited(_handleInitialLinkFallback());
  }

  @override
  void dispose() {
    unawaited(_linkSubscription?.cancel());
    super.dispose();
  }

  /// Fallback when the stream did not replay the cold-start intent.
  Future<void> _handleInitialLinkFallback() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }
  }

  void _handleUri(Uri uri) {
    if (!isPasswordResetLink(uri)) {
      return;
    }

    final oobCode = parsePasswordResetOobCode(uri);
    if (oobCode == null || oobCode.isEmpty) {
      return;
    }

    if (_isOpeningResetPage) {
      return;
    }

    if (_lastHandledOobCode == oobCode &&
        widget.router.topRoute.name == ResetPasswordPageRoute.name) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_openResetPasswordPage(oobCode));
    });
  }

  Future<void> _openResetPasswordPage(String oobCode) async {
    if (!mounted || _isOpeningResetPage) {
      return;
    }

    final router = widget.router;
    if (router.topRoute.name == ResetPasswordPageRoute.name &&
        _lastHandledOobCode == oobCode) {
      return;
    }

    _isOpeningResetPage = true;
    try {
      if (router.topRoute.name != HomePageWrapperRoute.name) {
        router.popUntilRoot();
      }

      await router.push(ResetPasswordPageRoute(oobCode: oobCode));
      _lastHandledOobCode = oobCode;
    } finally {
      _isOpeningResetPage = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
