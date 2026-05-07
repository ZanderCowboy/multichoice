import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:ui_kit/ui_kit.dart';

class WelcomeModal extends StatelessWidget {
  const WelcomeModal({
    required this.onGoHome,
    required this.onFollowTutorial,
    super.key,
  });

  final VoidCallback onGoHome;
  final VoidCallback onFollowTutorial;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: allPadding24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.t.common.welcomeToMultichoice,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gap16,
              Text(
                context.t.common.welcomeToMultichoiceBody,
                textAlign: TextAlign.center,
                style: context.theme.appTextTheme.bodyLarge,
              ),
              gap24,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      await coreSl<IAnalyticsService>().logEvent(
                        const UiActionEventData(
                          page: AnalyticsPage.home,
                          button: AnalyticsButton.goHome,
                          action: AnalyticsAction.tap,
                          source: 'welcome_modal',
                        ),
                      );
                      onGoHome();
                    },
                    child: Text(context.t.common.goHome),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await coreSl<IAnalyticsService>().logEvent(
                        const UiActionEventData(
                          page: AnalyticsPage.home,
                          button: AnalyticsButton.followTutorial,
                          action: AnalyticsAction.tap,
                          source: 'tutorial',
                        ),
                      );
                      onFollowTutorial();
                    },
                    child: Text(context.t.tutorial.followTutorial),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
