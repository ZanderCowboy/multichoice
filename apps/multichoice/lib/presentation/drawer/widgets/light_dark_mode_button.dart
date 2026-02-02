part of 'export.dart';

class LightDarkModeButton extends HookWidget {
  const LightDarkModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appStorageService = coreSl<IAppStorageService>();

    final isDark = useState<bool>(false);

    useEffect(
      () {
        Future<void> loadDarkModePreference() async {
          final isDarkMode = await appStorageService.isDarkMode;
          isDark.value = isDarkMode;
        }

        loadDarkModePreference();
        return null;
      },
      [],
    );

    return SwitchListTile(
      key: context.keys.lightDarkModeSwitch,
      title: const Text('Light / Dark Mode'),
      value: isDark.value,
      activeThumbImage: AssetImage(Assets.images.sleepMode.path),
      thumbColor: const WidgetStatePropertyAll(
        Colors.white,
      ),
      inactiveThumbColor: Colors.black,
      inactiveThumbImage: AssetImage(Assets.images.sun.path),
      onChanged: (value) async {
        isDark.value = !isDark.value;
        context.read<AppTheme>().themeMode = isDark.value
            ? ThemeMode.dark
            : ThemeMode.light;
        await appStorageService.setIsDarkMode(isDark.value);
      },
    );
  }
}
