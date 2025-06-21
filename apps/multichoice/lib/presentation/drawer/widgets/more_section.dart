part of 'export.dart';

class MoreSection extends StatelessWidget {
  const MoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            'More',
            style: AppTypography.titleSmall.copyWith(
              color: Colors.white70,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListTile(
          title: const Text('Restart Tutorial'),
          subtitle: const Text(
            'Temporarily switches to demo data to show app features, then restores your original data',
            style: TextStyle(fontSize: 12),
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
          onTap: () {
            context.router.push(const FeedbackPageRoute());
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: () async {
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
