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
    return Center(
      child: FutureBuilder<bool>(
        future: isDBEmpty,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularLoader.small();
          }

          if (snapshot.hasError) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                gap10,
                Text('Failed to load data transfer state.'),
              ],
            );
          }

          if (!snapshot.hasData) {
            return CircularLoader.small();
          }

          final dbIsEmpty = snapshot.data ?? true;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onImportPressed,
                child: const Text('Import'),
              ),
              gap10,
              ElevatedButton(
                onPressed: dbIsEmpty ? null : onExportPressed,
                child: const Text('Export'),
              ),
            ],
          );
        },
      ),
    );
  }
}
