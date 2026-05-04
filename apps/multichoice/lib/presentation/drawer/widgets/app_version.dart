part of 'export.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final appVersion = coreSl<IAppInfoService>().getAppVersion();
    final versionTextStyle = context.appTextTheme.bodyMedium?.copyWith(
      color: context.theme.colorScheme.onSurface,
    );

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
                      style: versionTextStyle,
                    ),
                  )
                : Text(
                    'v${snapshot.data}',
                    style: versionTextStyle,
                  );
          }
          return Text(
            'Unknown version',
            style: versionTextStyle,
          );
        },
      ),
    );
  }
}
