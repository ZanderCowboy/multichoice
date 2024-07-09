abstract class IDataExchangeService {
  Future<String?> pickFile();
  Future<String?> saveFile();

  Future<String> exportDataToJSON();
  Future<bool?> importDataFromJSON(String filePath);
  Future<bool> isDBEmpty();
}
