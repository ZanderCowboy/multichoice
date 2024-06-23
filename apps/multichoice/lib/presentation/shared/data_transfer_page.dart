// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/engine/tooltip_enums.dart';
import 'package:multichoice/constants/export_constants.dart';

@RoutePage()
class DataTransferScreen extends StatefulWidget {
  const DataTransferScreen({super.key});

  @override
  DataTransferPageState createState() => DataTransferPageState();
}

class DataTransferPageState extends State<DataTransferScreen> {
  final dataExchangeService = coreSl<IDataExchangeService>();

  String? _fileName;

  @override
  Widget build(BuildContext context) {
    final isDBEmpty = dataExchangeService.isDBEmpty();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Transfer',
        ),
        leading: IconButton(
          onPressed: () {
            context.router.maybePop();
          },
          tooltip: TooltipEnums.back.tooltip,
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.router.replace(const HomePageRoute());
            },
            tooltip: TooltipEnums.home.tooltip,
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: isDBEmpty,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final isDBEmpty = snapshot.data ?? false;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _importFile(context),
                  child: const Text('Import'),
                ),
                gap10,
                ElevatedButton(
                  onPressed: isDBEmpty ? null : _exportFile,
                  child: const Text('Export'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _importFile(BuildContext context) async {
    final filePath = await dataExchangeService.pickFile();

    if (filePath != null) {
      final isDBEmpty = await dataExchangeService.isDBEmpty();

      if (!isDBEmpty) {
        final shouldClearDB = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Warning!'),
              content: const Text(
                'Importing data will clear all existing data. Do you want to proceed?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        if (shouldClearDB == null || !shouldClearDB) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aborted import operation'),
            ),
          );

          return;
        }

        await _showFeedback(filePath);
      }

      await _showFeedback(filePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected'),
        ),
      );
    }
  }

  Future<void> _showFeedback(String filePath) async {
    final result =
        await dataExchangeService.importDataFromJSON(filePath) ?? false;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data imported successfully'),
        ),
      );
      await context.router.replace(const HomePageRoute());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to import data'),
        ),
      );
    }
  }

  Future<void> _exportFile() async {
    final filePath = await dataExchangeService.saveFile();

    if (filePath != null) {
      final json = await dataExchangeService.exportDataToJSON();

      await _showInputModal(context);

      final updatedFilePath = '$filePath/$_fileName.json';

      final file = File(updatedFilePath);
      await file.writeAsString(json);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File saved at: $updatedFilePath'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Save operation cancelled'),
        ),
      );
    }
  }

  Future<void> _showInputModal(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter File Name'),
          content: TextField(
            onChanged: (value) {
              _fileName = value;
            },
            decoration: const InputDecoration(
              hintText: 'File Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                log('File Name: $_fileName');
                Navigator.of(context).pop();
              },
              child: const Text('Save Export'),
            ),
          ],
        );
      },
    );
  }
}
