import 'package:flutter/material.dart';
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  gap10,
                  Text('Failed to load data transfer state.'),
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
                'Move your data between devices',
                style: textTheme.titleLarge,
              ),
              gap10,
              Text(
                'Export creates a Multichoice backup file. Import restores your collections from that file.',
                style: textTheme.bodyMedium,
              ),
              gap12,
              Card(
                child: Padding(
                  padding: allPadding12,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline),
                      gap12,
                      Expanded(
                        child: Text(
                          'Only Multichoice backup files can be imported (.multichoice).',
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
                child: const Text('Import backup'),
              ),
              gap10,
              ElevatedButton(
                onPressed: dbIsEmpty ? null : onExportPressed,
                child: const Text('Export backup'),
              ),
              gap12,
              Text(
                dbIsEmpty
                    ? 'Export is disabled because there is no data to back up yet.'
                    : 'Export will save a file you can import later.',
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
