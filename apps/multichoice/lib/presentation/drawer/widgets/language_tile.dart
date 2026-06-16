// ignore_for_file: deprecated_member_use

part of 'export.dart';

class LanguageTile extends StatefulWidget {
  const LanguageTile({super.key});

  @override
  State<LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<LanguageTile> {
  final IAppStorageService _appStorageService = coreSl<IAppStorageService>();
  String _selectedLocale = 'system';

  @override
  void initState() {
    super.initState();
    unawaited(_loadLocalePreference());
  }

  Future<void> _loadLocalePreference() async {
    final savedLocale = await _appStorageService.appLocale;
    if (mounted) {
      setState(() {
        _selectedLocale = savedLocale ?? 'system';
      });
    }
  }

  String _labelForLocale(BuildContext context, String locale) {
    return switch (locale) {
      'en' => context.t.drawer.languageEnglish,
      'nl' => context.t.drawer.languageDutch,
      _ => context.t.drawer.languageSystem,
    };
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(context.t.drawer.language),
          children: [
            for (final locale in const ['system', 'en', 'nl'])
              RadioListTile<String>(
                title: Text(_labelForLocale(context, locale)),
                value: locale,
                groupValue: _selectedLocale,
                onChanged: (value) {
                  Navigator.of(dialogContext).pop(value);
                },
              ),
          ],
        );
      },
    );

    if (selected == null || selected == _selectedLocale) return;

    setState(() {
      _selectedLocale = selected;
    });

    await coreSl<IAnalyticsService>().logEvent(
      UiActionEventData(
        page: AnalyticsPage.settings,
        button: AnalyticsButton.language,
        action: AnalyticsAction.tap,
        source: selected,
      ),
    );

    if (selected == 'system') {
      await _appStorageService.setAppLocale(null);
      await LocaleSettings.useDeviceLocale();
    } else {
      await _appStorageService.setAppLocale(selected);
      await LocaleSettings.setLocale(
        selected == 'nl' ? AppLocale.nl : AppLocale.en,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(
        context.t.drawer.language,
        style: context.appTextTheme.denseTitle,
      ),
      subtitle: Text(
        _labelForLocale(context, _selectedLocale),
        style: context.appTextTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguagePicker(context),
    );
  }
}
