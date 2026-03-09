// Not used currently, but kept for future use
// ignore_for_file: unused_element

part of '../home_page.dart';

Future<void> _checkAndRequestPermissions(BuildContext context) async {
  final appStorageService = coreSl<IAppStorageService>();
  final isChecked = await appStorageService.isPermissionsChecked;

  if (isChecked) {
    return;
  }

  var status = await Permission.manageExternalStorage.status;

  if (status.isGranted) {
    await appStorageService.setIsPermissionsChecked(true);
    return;
  }

  if (status.isDenied && context.mounted) {
    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'Storage permission is required for import/export.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await appStorageService.setIsPermissionsChecked(true);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Deny'),
            ),
            TextButton(
              onPressed: () async {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                status = await Permission.manageExternalStorage.request();
                if (status.isGranted) {
                  await appStorageService.setIsPermissionsChecked(true);
                }
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    if (status.isPermanentlyDenied && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission will be needed for import/export.'),
        ),
      );
    }
  }
}
