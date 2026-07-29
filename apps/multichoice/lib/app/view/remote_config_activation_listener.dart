import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multichoice/app/bootstrap/non_critical_services.dart';
import 'package:multichoice/app/view/debug/remote_config_debug_notifier.dart';
import 'package:provider/provider.dart';

/// Rebuilds Remote Config consumers after the startup fetch completes.
class RemoteConfigActivationListener extends StatefulWidget {
  const RemoteConfigActivationListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RemoteConfigActivationListener> createState() =>
      _RemoteConfigActivationListenerState();
}

class _RemoteConfigActivationListenerState
    extends State<RemoteConfigActivationListener> {
  @override
  void initState() {
    super.initState();
    unawaited(_notifyWhenRemoteConfigIsReady());
  }

  Future<void> _notifyWhenRemoteConfigIsReady() async {
    await nonCriticalServicesInitialization;
    if (!mounted) return;
    context.read<RemoteConfigDebugNotifier>().notifyRemoteConfigRefreshed();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
