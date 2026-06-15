part of 'export.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final appInfoService = coreSl<IAppInfoService>();
    final appVersion = AppFlavor.allowsDebugPage
        ? appInfoService.getAppVersion()
        : appInfoService.getDisplayAppVersion();
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
            return AppFlavor.allowsDebugPage
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
            context.t.common.unknownVersion,
            style: versionTextStyle,
          );
        },
      ),
    );
  }
}
