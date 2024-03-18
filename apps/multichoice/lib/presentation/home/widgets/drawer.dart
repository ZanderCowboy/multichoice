part of '../home_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final appVersion = coreSl<IAppInfoService>().getAppVersion();

        return Drawer(
          width: MediaQuery.sizeOf(context).width,
          backgroundColor: context.theme.appColors.background,
          child: Padding(
            padding: allPadding12,
            child: Column(
              children: [
                gap56,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Settings',
                        style: context.theme.appTextTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.close_outlined,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                gap24,
                Row(
                  children: [
                    const Expanded(
                      child: Text('Light/Dark Mode'),
                    ),
                    _ThemeButton(
                      sharedPref: coreSl<SharedPreferences>(),
                      state: state,
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox.expand(),
                ),
                Padding(
                  padding: allPadding12,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
