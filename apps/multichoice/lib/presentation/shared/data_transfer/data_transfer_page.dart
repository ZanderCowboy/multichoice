// The context is used synchronously in this file, and the asynchronous usage is safe here.
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/app/engine/tooltip_enums.dart';
import 'package:multichoice/presentation/shared/data_transfer/data_transfer_service.dart';
import 'package:multichoice/presentation/shared/data_transfer/widgets/file_name_dialog.dart';
import 'package:multichoice/presentation/shared/data_transfer/widgets/import_confirmation_dialog.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class DataTransferScreen extends HookWidget {
  const DataTransferScreen({
    required this.onCallback,
    super.key,
  });

  final void Function() onCallback;

  // TODO(@ZanderCowboy): When the user Appends New Data, the data should
  // be appended to the end of the existing data, NOT the beginning.

  @override
  Widget build(BuildContext context) {
    final dataTransferService = useMemoized(DataTransferService.new);
    final isDBEmpty = useFuture(dataTransferService.isDBEmpty());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Transfer'),
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          tooltip: TooltipEnums.back.tooltip,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.router.popUntilRoot();
              scaffoldKey.currentState?.closeDrawer();
            },
            tooltip: TooltipEnums.home.tooltip,
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: !isDBEmpty.hasData
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        _handleImport(context, dataTransferService),
                    child: const Text('Import'),
                  ),
                  gap10,
                  ElevatedButton(
                    onPressed: isDBEmpty.data ?? true
                        ? null
                        : () => _handleExport(context, dataTransferService),
                    child: const Text('Export'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleImport(
    BuildContext context,
    DataTransferService service,
  ) async {
    final filePath = await service.pickFile();
    if (filePath == null) {
      _showSnackBar(context, 'No file selected');
      return;
    }

    final isDBEmpty = await service.isDBEmpty();
    if (!isDBEmpty) {
      final shouldAppend = await showDialog<bool>(
        context: context,
        builder: (context) => const ImportConfirmationDialog(),
      );

      if (shouldAppend == null) {
        _showSnackBar(context, 'Aborted import operation');
        return;
      }

      await _handleImportFeedback(context, service, filePath, shouldAppend);
    } else {
      await _handleImportFeedback(context, service, filePath, true);
    }
  }

  Future<void> _handleImportFeedback(
    BuildContext context,
    DataTransferService service,
    String filePath,
    bool shouldAppend,
  ) async {
    final result = await service.importDataFromJSON(
      filePath,
      shouldAppend: shouldAppend,
    );

    if (result) {
      onCallback.call();
      _showSnackBar(context, 'Data imported successfully');
      context.router.popUntilRoot();
      scaffoldKey.currentState?.closeDrawer();
    } else {
      _showSnackBar(context, 'Failed to import data');
    }
  }

  Future<void> _handleExport(
    BuildContext context,
    DataTransferService service,
  ) async {
    final jsonString = await service.exportDataToJSON();
    final fileName = await showDialog<String>(
      context: context,
      builder: (context) => const FileNameDialog(),
    );

    if (fileName == null) {
      _showSnackBar(context, 'Export cancelled');
      return;
    }

    final fileBytes = service.convertToBytes(jsonString);
    await service.saveFile(fileName, fileBytes);
    _showSnackBar(context, 'File saved successfully!');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
