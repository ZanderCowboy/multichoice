import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/presentation/home/widgets/welcome_modal.dart';

class WelcomeModalHandler extends StatefulWidget {
  const WelcomeModalHandler({
    required this.builder,
    required this.onSkipTips,
    required this.onStartTips,
    super.key,
  });

  final WidgetBuilder builder;
  final Future<void> Function() onSkipTips;
  final Future<void> Function() onStartTips;

  @override
  State<WelcomeModalHandler> createState() => _WelcomeModalHandlerState();
}

class _WelcomeModalHandlerState extends State<WelcomeModalHandler> {
  bool _hasScheduledModalCheck = false;

  Future<void> _checkAndShowWelcomeModal(BuildContext context) async {
    final appStorageService = coreSl<IAppStorageService>();
    final isExistingUser = await appStorageService.isExistingUser;
    final isCompleted = await appStorageService.isCompleted;

    if (!isExistingUser && !isCompleted && context.mounted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => WelcomeModal(
          onSkipTips: () async {
            if (context.mounted) {
              Navigator.of(context).pop();
              await widget.onSkipTips();
            }
          },
          onStartTips: () async {
            if (context.mounted) {
              Navigator.of(context).pop();
              await widget.onStartTips();
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _hasScheduledModalCheck) return;
      _hasScheduledModalCheck = true;
      await _checkAndShowWelcomeModal(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
