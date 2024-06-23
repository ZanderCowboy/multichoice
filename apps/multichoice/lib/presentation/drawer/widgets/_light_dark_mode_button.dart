part of '../home_drawer.dart';

class _LightDarkModeButton extends HookWidget {
  const _LightDarkModeButton();

  @override
  Widget build(BuildContext context) {
    final sharedPref = coreSl<SharedPreferences>();

    final isDarkMode =
        sharedPref.getBool('isDarkMode') ?? ThemeMode.system == ThemeMode.dark;

    final isDark = useState<bool>(isDarkMode);

    return SwitchListTile(
      title: const Text('Light / Dark Mode'),
      value: isDark.value,
      activeThumbImage: AssetImage(Assets.images.sleepMode.path),
      thumbColor: const WidgetStatePropertyAll(
        Colors.white,
      ),
      inactiveThumbColor: Colors.black,
      inactiveThumbImage: AssetImage(Assets.images.sun.path),
      onChanged: (value) {
        isDark.value = !isDark.value;
        context.read<AppTheme>().themeMode =
            isDark.value == true ? ThemeMode.dark : ThemeMode.light;
        sharedPref.setBool('isDarkMode', isDark.value);
      },
    );
  }
}
