import 'dart:typed_data';

abstract class IFilePickerWrapper {
  Future<String?> pickFile();

  Future<String?> saveFile({
    required String dialogTitle,
    required String fileName,
    Uint8List? bytes,
  });
}
