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
          title: const Text('Reset Tutorial'),
          subtitle: const Text(
            'Temporarily switches to demo data to show app features, then restores your original data',
            style: TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            onPressed: () async {
              await Future.value(
                coreSl<IProductTourController>().resetTour(),
              ).whenComplete(() async {
                if (context.mounted) {
                  Navigator.of(context).pop();

                  await context.router.push(
                    TutorialPageRoute(
                      onCallback: () {},
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
      ],
    );
  }
}
