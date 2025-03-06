import 'dart:typed_data';

import 'package:core/src/wrappers/export.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IFilePickerWrapper)
class FilePickerWrapper implements IFilePickerWrapper {
  @override
  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      return result.files.single.path;
    }
    return null;
  }

  @override
  Future<String?> saveFile({
    required String dialogTitle,
    required String fileName,
    Uint8List? bytes,
  }) {
    return FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      bytes: bytes,
    );
  }
}
