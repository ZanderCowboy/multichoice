part of 'export.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final appVersion = coreSl<IAppInfoService>().getAppVersion();

    return Padding(
      padding: allPadding24,
      child: FutureBuilder(
        future: appVersion,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularLoader.small();
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return kDebugMode
                ? GestureDetector(
                    onLongPress: () =>
                        context.router.push(const DebugPageRoute()),
                    onDoubleTap: () =>
                        context.router.push(const DebugPageRoute()),
                    child: Text(
                      'v${snapshot.data}',
                      style: context.appTextTheme.bodyMedium,
                    ),
                  )
                : const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
