part of '../home_page.dart';

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final appVersion = coreSl<IAppInfoService>().getAppVersion();
        final sharedPref = coreSl<SharedPreferences>();

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
                        Navigator.of(context).pop();
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
                      sharedPref: sharedPref,
                      state: state,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Delete All Data'),
                    ),
                    IconButton(
                      onPressed: state.tabs != null && state.tabs!.isNotEmpty
                          ? () {
                              CustomDialog<AlertDialog>.show(
                                context: context,
                                title: const Text(
                                  'Delete all tabs and entries?',
                                ),
                                content: const Text(
                                  'Are you sure you want to delete all tabs and their entries?',
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('No, cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<HomeBloc>().add(
                                            const HomeEvent
                                                .onPressedDeleteAll(),
                                          );
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes, delete'),
                                  ),
                                ],
                              );
                            }
                          : null,
                      icon: const Icon(
                        Icons.delete_sweep_rounded,
                      ),
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

class _ThemeButton extends StatelessWidget {
  const _ThemeButton({
    required this.sharedPref,
    required this.state,
  });

  final SharedPreferences sharedPref;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        sharedPref.getBool('isDarkMode') ?? ThemeMode.system == ThemeMode.dark;

    if (!isDarkMode) {
      return IconButton(
        onPressed: () {
          _darkMode(context);
          sharedPref.setBool('isDarkMode', true);
        },
        icon: const Icon(Icons.dark_mode_outlined),
      );
    } else if (isDarkMode) {
      return IconButton(
        onPressed: () {
          _lightMode(context);
          sharedPref.setBool('isDarkMode', false);
        },
        icon: const Icon(Icons.light_mode_outlined),
      );
    }
    return const SizedBox.shrink();
  }

  void _lightMode(BuildContext context) {
    context.read<AppTheme>().themeMode = ThemeMode.light;
  }

  void _darkMode(BuildContext context) {
    context.read<AppTheme>().themeMode = ThemeMode.dark;
  }
}
