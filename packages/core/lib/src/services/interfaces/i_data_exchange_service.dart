import 'dart:typed_data';

abstract class IDataExchangeService {
  Future<String?> pickFile();
  Future<void> saveFile(String fileName, Uint8List fileBytes);

  Future<String> exportDataToJSON();
  Future<bool?> importDataFromJSON(
    String filePath, {
    bool shouldAppend,
  });
  Future<bool> isDBEmpty();
}
