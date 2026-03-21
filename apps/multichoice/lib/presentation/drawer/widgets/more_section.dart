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
            'More',
            style: AppTypography.titleSmall.copyWith(
              color: context.theme.appColors.textSecondary ??
                  context.theme.appColors.textTertiary,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListTile(
          title: const Text('Restart Tutorial'),
          subtitle: Text(
            'Temporarily switches to demo data to show app features, then restores your original data',
            style: context.theme.appTextTheme.bodySmall ??
                Theme.of(context).textTheme.bodySmall,
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
          title: const Text('Send Feedback'),
          onTap: () async {
            await context.router.push(const FeedbackPageRoute());
          },
        ),
        if (isChangelogEnabled)
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Changelog'),
            onTap: () async {
              await context.router.push(const ChangelogPageRoute());
            },
          ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: () async {
            await coreSl<IAnalyticsService>().logEvent(
              const UiActionEventData(
                page: AnalyticsPage.settings,
                button: AnalyticsButton.about,
                action: AnalyticsAction.open,
                source: 'about',
              ),
            );
            final appVersion = await coreSl<IAppInfoService>().getAppVersion();

            if (!context.mounted) return;

            showAboutDialog(
              context: context,
              applicationName: 'Multichoice',
              applicationVersion: appVersion,
              applicationIcon: const FlutterLogo(size: 64),
              children: [
                const Text(
                  'Multichoice is a powerful tool for managing your choices and decisions.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
