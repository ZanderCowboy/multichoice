import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/presentation/home/widgets/welcome_modal.dart';

class WelcomeModalHandler extends StatelessWidget {
  const WelcomeModalHandler({
    required this.builder,
    required this.onSkipTour,
    required this.onFollowTutorial,
    super.key,
  });

  final WidgetBuilder builder;
  final Future<void> Function() onSkipTour;
  final Future<void> Function() onFollowTutorial;

  Future<void> _checkAndShowWelcomeModal(BuildContext context) async {
    final appStorageService = coreSl<IAppStorageService>();
    final isExistingUser = await appStorageService.isExistingUser;
    final isCompleted = await appStorageService.isCompleted;

    if (!isExistingUser && !isCompleted && context.mounted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => WelcomeModal(
          onGoHome: () async {
            if (context.mounted) {
              Navigator.of(context).pop();
              await onSkipTour();
            }
          },
          onFollowTutorial: () async {
            if (context.mounted) {
              Navigator.of(context).pop();
              await onFollowTutorial();
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _checkAndShowWelcomeModal(context),
    );

    return builder(context);
  }
}
