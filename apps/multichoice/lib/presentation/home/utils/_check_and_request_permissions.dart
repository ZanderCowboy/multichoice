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
          title: Text(context.t.common.permissionRequired),
          content: Text(
            context.t.common.storagePermissionNeeded,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await appStorageService.setIsPermissionsChecked(true);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(context.t.common.deny),
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
              child: Text(context.t.common.openSettings),
            ),
          ],
        );
      },
    );

    if (status.isPermanentlyDenied && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t.common.storagePermissionNeeded),
        ),
      );
    }
  }
}
