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
      title: const Text('Light / Dark Mode'),
      value: _isDark,
      activeThumbImage: AssetImage(Assets.images.sleepMode.path),
      thumbColor: WidgetStatePropertyAll(
        context.theme.appColors.primary,
      ),
      inactiveThumbColor: Colors.black,
      inactiveThumbImage: AssetImage(Assets.images.sun.path),
      onChanged: (value) async {
        setState(() {
          _isDark = !_isDark;
        });
        context.read<AppTheme>().themeMode = _isDark
            ? ThemeMode.dark
            : ThemeMode.light;
        await _appStorageService.setIsDarkMode(_isDark);
      },
    );
  }
}
