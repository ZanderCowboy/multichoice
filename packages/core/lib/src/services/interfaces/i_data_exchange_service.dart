abstract class IDataExchangeService {
  Future<String?> pickFile();
  Future<String?> saveFile();

  Future<String> exportDataToJSON();
  Future<bool?> importDataFromJSON(
    String filePath, {
    bool shouldAppend,
  });
  Future<bool> isDBEmpty();
}
