// ignore_for_file: use_build_context_synchronously

part of 'export.dart';

class LightDarkModeButton extends StatefulWidget {
  const LightDarkModeButton({super.key});

  @override
  State<LightDarkModeButton> createState() => _LightDarkModeButtonState();
}

class _LightDarkModeButtonState extends State<LightDarkModeButton> {
  final IAppStorageService _appStorageService = coreSl<IAppStorageService>();
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDarkModePreference());
  }

  Future<void> _loadDarkModePreference() async {
    final isDarkMode = await _appStorageService.isDarkMode;
    if (mounted) {
      setState(() {
        _isDark = isDarkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      key: context.keys.lightDarkModeSwitch,
      title: Text(
        'Light / Dark Mode',
        style: context.appTextTheme.denseTitle,
      ),
      value: _isDark,
      activeThumbImage: AssetImage(Assets.images.sleepWhite.path),
      activeThumbColor: context.appColorsTheme.foreground,
      inactiveThumbImage: AssetImage(Assets.images.sun.path),
      inactiveThumbColor: context.appColorsTheme.primary,
      onChanged: (value) async {
        setState(() {
          _isDark = !_isDark;
        });
        await coreSl<IAnalyticsService>().logEvent(
          UiActionEventData(
            page: AnalyticsPage.settings,
            button: AnalyticsButton.theme,
            action: AnalyticsAction.tap,
            source: _isDark ? 'dark_mode' : 'light_mode',
          ),
        );
        context.read<AppTheme>().themeMode = _isDark
            ? ThemeMode.dark
            : ThemeMode.light;
        await _appStorageService.setIsDarkMode(_isDark);
      },
    );
  }
}
