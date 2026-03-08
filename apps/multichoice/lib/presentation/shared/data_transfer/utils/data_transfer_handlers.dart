// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/presentation/shared/data_transfer/data_transfer_service.dart';
import 'package:multichoice/presentation/shared/data_transfer/widgets/file_name_dialog.dart';
import 'package:multichoice/presentation/shared/data_transfer/widgets/import_confirmation_dialog.dart';

typedef DataTransferMessage = void Function(String message);

Future<void> handleImport({
  required BuildContext context,
  required DataTransferService service,
  required VoidCallback onImportSuccess,
  required DataTransferMessage showMessage,
}) async {
  final filePath = await service.pickFile();
  if (filePath == null) {
    showMessage('No file selected');
    return;
  }

  final isDBEmpty = await service.isDBEmpty();
  if (!isDBEmpty) {
    final shouldAppend = await showDialog<bool>(
      context: context,
      builder: (context) => const ImportConfirmationDialog(),
    );

    if (shouldAppend == null) {
      showMessage('Aborted import operation');
      return;
    }

    await _handleImportFeedback(
      context: context,
      service: service,
      filePath: filePath,
      shouldAppend: shouldAppend,
      onImportSuccess: onImportSuccess,
      showMessage: showMessage,
    );
  } else {
    await _handleImportFeedback(
      context: context,
      service: service,
      filePath: filePath,
      shouldAppend: true,
      onImportSuccess: onImportSuccess,
      showMessage: showMessage,
    );
  }
}

Future<void> handleExport({
  required BuildContext context,
  required DataTransferService service,
  required DataTransferMessage showMessage,
}) async {
  final jsonString = await service.exportDataToJSON();
  final fileName = await showDialog<String>(
    context: context,
    builder: (context) => const FileNameDialog(),
  );

  if (fileName == null) {
    showMessage('Export cancelled');
    return;
  }

  final fileBytes = service.convertToBytes(jsonString);
  await service.saveFile(fileName, fileBytes);
  showMessage('File saved successfully!');
}

Future<void> _handleImportFeedback({
  required BuildContext context,
  required DataTransferService service,
  required String filePath,
  required bool shouldAppend,
  required VoidCallback onImportSuccess,
  required DataTransferMessage showMessage,
}) async {
  final result = await service.importDataFromJSON(
    filePath,
    shouldAppend: shouldAppend,
  );

  if (!context.mounted) return;

  if (result) {
    onImportSuccess.call();
    showMessage('Data imported successfully');
    context.router.popUntilRoot();
    scaffoldKey.currentState?.closeDrawer();
  } else {
    showMessage('Failed to import data');
  }
}
