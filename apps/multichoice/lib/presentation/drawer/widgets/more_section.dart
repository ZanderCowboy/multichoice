part of 'export.dart';

// Session-only developer mode unlock for About.
final AboutDeveloperModeUnlocker _aboutDeveloperModeUnlocker =
    AboutDeveloperModeUnlocker();

const _aboutDialogTapDelay = Duration(milliseconds: 250);
const _developerModeSnackBarDuration = Duration(milliseconds: 900);
const _developerModeSnackBarWidth = 280.0;

class MoreSection extends StatefulWidget {
  const MoreSection({super.key});

  @override
  State<MoreSection> createState() => _MoreSectionState();
}

class _MoreSectionState extends State<MoreSection> {
  Timer? _aboutDialogTimer;

  @override
  void dispose() {
    _aboutDialogTimer?.cancel();
    super.dispose();
  }

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
          onTap: () => _onAboutTap(context),
        ),
      ],
    );
  }

  void _onAboutTap(BuildContext context) {
    if (_aboutDeveloperModeUnlocker.isEnabled) {
      _aboutDialogTimer?.cancel();
      unawaited(_showAboutDialog(context));
      return;
    }

    final result = _aboutDeveloperModeUnlocker.registerTap(DateTime.now());

    if (result.isFirstTapInSequence) {
      _aboutDialogTimer?.cancel();
      _aboutDialogTimer = Timer(_aboutDialogTapDelay, () {
        if (!mounted) return;
        unawaited(_showAboutDialog(context));
      });
      return;
    }

    _aboutDialogTimer?.cancel();

    final messenger = ScaffoldMessenger.of(context)..removeCurrentSnackBar();
    if (result.didEnable) {
      messenger.showSnackBar(
        _developerModeSnackBar('You are now a developer.'),
      );
      return;
    }

    if (result.shouldShowCountdown) {
      final tapLabel = result.remainingTaps == 1 ? 'tap' : 'taps';
      messenger.showSnackBar(
        _developerModeSnackBar(
          '${result.remainingTaps} $tapLabel until developer mode.',
        ),
      );
    }
  }

  SnackBar _developerModeSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      width: _developerModeSnackBarWidth,
      shape: const StadiumBorder(),
      duration: _developerModeSnackBarDuration,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _showAboutDialog(BuildContext context) async {
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

    await showDialog<void>(
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
    );
  }
}
