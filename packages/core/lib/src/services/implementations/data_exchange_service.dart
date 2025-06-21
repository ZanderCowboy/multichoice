import 'dart:developer';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';

@LazySingleton(as: IDataExchangeService)
class DataExchangeService implements IDataExchangeService {
  final Isar isar;
  final IFilePickerWrapper filePickerWrapper;

  DataExchangeService(
    this.isar, {
    required this.filePickerWrapper,
  });

  @override
  Future<String?> pickFile() async {
    return await filePickerWrapper.pickFile();
  }

  @override
  Future<void> saveFile(String fileName, Uint8List fileBytes) async {
    try {
      final String? filePath = await filePickerWrapper.saveFile(
        dialogTitle: "Save JSON File",
        fileName: "$fileName.json",
        bytes: fileBytes,
      );

      if (filePath != null) {
        File file = File(filePath);
        await file.writeAsBytes(fileBytes);
        print("File saved successfully at: $filePath");
      } else {
        print("User canceled file selection.");
      }
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  @override
  Future<String> exportDataToJSON() async {
    final tabsData = await isar.tabs.where().findAll();
    final entriesData = await isar.entrys.where().findAll();

    final json = jsonEncode({
      'tabs': tabsData.map((item) => item.toJson()).toList(),
      'entries': entriesData.map((item) => item.toJson()).toList(),
    });

    return json;
  }

  @override
  Future<bool?> importDataFromJSON(
    String filePath, {
    bool shouldAppend = true,
  }) async {
    final file = await _getFile(filePath);

    if (file == null) {
      return false;
    }

    final jsonData = await file.readAsString();
    final data = jsonDecode(jsonData) as Map<String, dynamic>;

    final List<Map<String, dynamic>> tabsData = (data['tabs'] as List)
        .map((item) => item as Map<String, dynamic>)
        .toList();
    final List<Map<String, dynamic>> entriesData = (data['entries'] as List)
        .map((item) => item as Map<String, dynamic>)
        .toList();

    try {
      await isar.writeTxn(() async {
        final newTabs = tabsData.map((e) => Tabs.fromJson(e)).toList();
        final newEntries = entriesData.map((e) => Entry.fromJson(e)).toList();

        if (!shouldAppend) {
          await isar.clear();
        }

        await isar.tabs.putAll(newTabs);
        await isar.entrys.putAll(newEntries);
      });

      return true;
    } catch (e, s) {
      log(
        e.toString(),
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }

  Future<File?> _getFile(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        return file;
      }
    } catch (e, s) {
      log(
        e.toString(),
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }

  @override
  Future<bool> isDBEmpty() async {
    final tabsData = await isar.tabs.where().findAll();
    final entriesData = await isar.entrys.where().findAll();

    return tabsData.isEmpty && entriesData.isEmpty;
  }
}
