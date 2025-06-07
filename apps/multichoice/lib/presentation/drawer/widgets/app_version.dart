part of 'export.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  Future<void> _clearStorageData(BuildContext context) async {
    if (!kDebugMode) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Storage Data'),
        content: const Text(
          'Are you sure you want to clear all storage data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await coreSl<IAppStorageService>().clearAllData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage data cleared successfully')),
        );
      }
    }
  }

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
            return GestureDetector(
              onLongPress: kDebugMode ? () => _clearStorageData(context) : null,
              child: Text(
                'V${snapshot.data}',
                style: context.theme.appTextTheme.bodyMedium,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
