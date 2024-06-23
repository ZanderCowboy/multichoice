part of '../home_drawer.dart';

class _AppVersion extends StatelessWidget {
  const _AppVersion();

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
            return Text(
              'V${snapshot.data}',
              style: context.theme.appTextTheme.bodyMedium,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
