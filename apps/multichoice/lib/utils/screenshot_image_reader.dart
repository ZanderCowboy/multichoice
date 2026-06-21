import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Android-only screenshot reader for feedback paste.
///
/// Uses a native MethodChannel that reads the system clipboard, then falls back
/// to the most recent screenshot in MediaStore (Samsung/One UI).
abstract final class ScreenshotImageReader {
  static const _channel = MethodChannel(
    'co.za.zanderkotze.multichoice/screenshot_image',
  );

  static Future<({Uint8List bytes, String extension})?> readImageBytes() async {
    await _ensurePhotosAccess();

    try {
      final result = await _channel.invokeMethod<Object?>('readImageBytes');
      return _parseNativeResult(result);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  static Future<void> _ensurePhotosAccess() async {
    final photos = await Permission.photos.status;
    if (!photos.isGranted && !photos.isLimited) {
      await Permission.photos.request();
    }
  }

  static ({Uint8List bytes, String extension})? _parseNativeResult(
    Object? result,
  ) {
    if (result is! List || result.length < 2) return null;

    final bytes = _coerceBytes(result[0]);
    final extension = result[1];
    if (bytes == null || bytes.isEmpty) return null;
    if (extension is! String || extension.isEmpty) return null;

    return (bytes: bytes, extension: extension);
  }

  static Uint8List? _coerceBytes(Object? raw) {
    if (raw == null) return null;
    if (raw is Uint8List) return raw;
    if (raw is ByteBuffer) return raw.asUint8List();
    if (raw is List) {
      try {
        return Uint8List.fromList(raw.cast<int>());
      } on Object {
        return null;
      }
    }
    return null;
  }
}
