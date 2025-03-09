import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IFilePickerWrapper)
class FilePickerWrapper implements IFilePickerWrapper {
  final FilePicker _filePicker;

  FilePickerWrapper({required FilePicker? filePicker})
      : _filePicker = filePicker ?? coreSl<FilePicker>();

  @override
  Future<String?> pickFile() async {
    final result = await _filePicker.pickFiles();

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
    return _filePicker.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      bytes: bytes,
    );
  }
}
