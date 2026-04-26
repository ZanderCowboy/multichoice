part of 'export.dart';

// Session-only developer mode unlock for About.
final AboutDeveloperModeUnlocker _aboutDeveloperModeUnlocker =
    AboutDeveloperModeUnlocker();

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
            style: context.appTextTheme.titleSmall!.copyWith(
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Restart Tutorial',
            style: context.appTextTheme.denseTitle,
          ),
          subtitle: Text(
            'Temporarily switches to demo data to show app features, then restores your original data',
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
            'Send Feedback',
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
              'Changelog',
              style: context.appTextTheme.denseTitle,
            ),
            onTap: () async {
              await context.router.push(const ChangelogPageRoute());
            },
          ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(
            'About',
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
            final appVersion = await coreSl<IAppInfoService>().getAppVersion();

            if (!context.mounted) return;

            final didEnableDeveloperMode = _aboutDeveloperModeUnlocker.registerTap(
              DateTime.now(),
            );

            if (didEnableDeveloperMode) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Developer mode enabled')),
              );
            }

            unawaited(
              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('About Multichoice'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: FlutterLogo(size: 64)),
                        gap16,
                        Text('Version $appVersion'),
                        gap12,
                        const Text(
                          'Multichoice is a powerful tool for managing your choices and decisions.',
                        ),
                      ],
                    ),
                    actions: [
                      if (_aboutDeveloperModeUnlocker.isEnabled)
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            showLicensePage(
                              context: context,
                              applicationName: 'Multichoice',
                              applicationVersion: appVersion,
                              applicationIcon: const FlutterLogo(size: 64),
                            );
                          },
                          child: const Text('Licences'),
                        ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
