part of '../home_page.dart';

// Needs to be refactored
// ignore: unused_element
Future<void> _checkAndRequestPermissions(BuildContext context) async {
  var status = await Permission.manageExternalStorage.status;

  if (status.isGranted) {
    return;
  }

  if (status.isDenied && context.mounted) {
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        coreSl<SharedPreferences>().setBool('isPermissionsChecked', true);

        return AlertDialog(
          title: const Text('Permission Required'),
          content:
              const Text('Storage permission is required for import/export.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Deny'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                status = await Permission.manageExternalStorage.request();
                // openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    // final _status = await Permission.manageExternalStorage.request();

    if (status.isPermanentlyDenied && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission will be needed for import/export.'),
        ),
      );
    }
  }
}
