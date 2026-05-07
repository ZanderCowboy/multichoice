import 'package:flutter/material.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:ui_kit/ui_kit.dart';

class DataTransferContent extends StatelessWidget {
  const DataTransferContent({
    required this.isDBEmpty,
    required this.onImportPressed,
    required this.onExportPressed,
    super.key,
  });

  final Future<bool> isDBEmpty;
  final VoidCallback onImportPressed;
  final VoidCallback onExportPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allPadding16,
      child: FutureBuilder<bool>(
        future: isDBEmpty,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularLoader.small());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  gap10,
                  Text(context.t.common.failedToLoadDataTransferState),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: CircularLoader.small());
          }

          final dbIsEmpty = snapshot.data ?? true;
          final textTheme = Theme.of(context).textTheme;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.t.dataTransfer.moveDataTitle,
                style: textTheme.titleLarge,
              ),
              gap10,
              Text(
                context.t.dataTransfer.moveDataDescription,
                style: textTheme.bodyMedium,
              ),
              gap12,
              Card(
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                child: Padding(
                  padding: allPadding12,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline),
                      gap12,
                      Expanded(
                        child: Text(
                          context.t.dataTransfer.importOnlyBackupFiles,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onImportPressed,
                child: Text(context.t.dataTransfer.importBackup),
              ),
              gap10,
              ElevatedButton(
                onPressed: dbIsEmpty ? null : onExportPressed,
                child: Text(context.t.dataTransfer.exportBackup),
              ),
              gap12,
              Text(
                dbIsEmpty
                    ? context.t.dataTransfer.exportDisabledNoData
                    : context.t.dataTransfer.exportSaveFileDescription,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}
