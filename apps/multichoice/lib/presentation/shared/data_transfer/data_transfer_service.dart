import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';

class DataTransferService {
  final _dataExchangeService = coreSl<IDataExchangeService>();

  Future<bool> isDBEmpty() => _dataExchangeService.isDBEmpty();

  Future<String?> pickFile() => _dataExchangeService.pickFile();

  Future<bool> importDataFromJSON(
    String filePath, {
    required bool shouldAppend,
  }) async {
    return await _dataExchangeService.importDataFromJSON(
          filePath,
          shouldAppend: shouldAppend,
        ) ??
        false;
  }

  Future<String> exportDataToJSON() => _dataExchangeService.exportDataToJSON();

  Uint8List convertToBytes(String jsonString) {
    return Uint8List.fromList(utf8.encode(jsonString));
  }

  Future<void> saveFile(String fileName, Uint8List fileBytes) {
    return _dataExchangeService.saveFile(fileName, fileBytes);
  }
}
