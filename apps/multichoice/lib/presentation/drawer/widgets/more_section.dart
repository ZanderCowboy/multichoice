part of 'export.dart';

class MoreSection extends StatelessWidget {
  const MoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isChangelogEnabled = coreSl<IFirebaseService>().isEnabled(
      FirebaseConfigKeys.enableChangelogPage,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            context.t.drawer.more,
            style: context.appTextTheme.titleSmall!.copyWith(
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListTile(
          title: Text(
            context.t.drawer.restartTutorial,
            style: context.appTextTheme.denseTitle,
          ),
          subtitle: Text(
            context.t.drawer.restartTutorialDesc,
            style: context.appTextTheme.bodyMedium,
          ),
          trailing: IconButton(
            onPressed: () async {
              final appLayout = context.read<AppLayout>();
              final originalLayout = appLayout.isLayoutVertical;
              await appLayout.setLayoutVertical(isVertical: false);

              await Future.value(
                coreSl<IProductTourController>().resetTour(),
              ).whenComplete(() async {
                if (context.mounted) {
                  Navigator.of(context).pop();

                  await context.router.push(
                    TutorialPageRoute(
                      onCallback: () async {
                        await appLayout.setLayoutVertical(
                          isVertical: originalLayout,
                        );
                      },
                    ),
                  );
                }
              });
            },
            icon: const Icon(
              Icons.refresh_outlined,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.feedback_outlined),
          title: Text(
            context.t.drawer.sendFeedback,
            style: context.appTextTheme.denseTitle,
          ),
          onTap: () async {
            await context.router.push(const FeedbackPageRoute());
          },
        ),
        if (isChangelogEnabled)
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              context.t.drawer.changelog,
              style: context.appTextTheme.denseTitle,
            ),
            onTap: () async {
              await context.router.push(const ChangelogPageRoute());
            },
          ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(
            context.t.drawer.about,
            style: context.appTextTheme.denseTitle,
          ),
          onTap: () async {
            await coreSl<IAnalyticsService>().logEvent(
              const UiActionEventData(
                page: AnalyticsPage.settings,
                button: AnalyticsButton.about,
                action: AnalyticsAction.open,
                source: 'about',
              ),
            );
            if (!context.mounted) return;
            await context.router.push(const AboutPageRoute());
          },
        ),
      ],
    );
  }
}
