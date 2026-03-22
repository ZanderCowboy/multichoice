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
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return GestureDetector(
              onDoubleTap: kDebugMode
                  ? () => context.router.push(const DebugPageRoute())
                  : null,
              onLongPress: kDebugMode
                  ? () =>
                        () => context.router.push(const DebugPageRoute())
                  : null,
              child: Text(
                'v${snapshot.data}',
                style: context.theme.appTextTheme.bodyMedium,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
