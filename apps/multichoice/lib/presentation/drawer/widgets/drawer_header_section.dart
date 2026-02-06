part of 'export.dart';

class DrawerHeaderSection extends StatelessWidget {
  const DrawerHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final welcomeMessage = coreSl<IFirebaseService>().getString(
      FirebaseConfigKeys.welcomeMessage,
    );

    return FutureBuilder(
      future: welcomeMessage,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.done &&
            asyncSnapshot.hasData) {
          return DrawerHeader(
            padding: allPadding12,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: borderCircular12,
                  child: Image.asset(
                    Assets.images.playstore.path,
                    width: 48,
                    height: 48,
                  ),
                ),
                gap16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Multichoice',
                        style: AppTypography.titleLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      gap4,
                      Text(
                        asyncSnapshot.data ?? 'Welcome back!',
                        style: AppTypography.subtitleMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: TooltipEnums.close.tooltip,
                  icon: const Icon(
                    Icons.close_outlined,
                    size: 28,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
