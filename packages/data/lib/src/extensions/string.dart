extension FashHashExtension on String {
  /// FNV-1a 64bit hash algorithm optimized for Dart Strings
  int fastHash() {
    // The hash algorithm requires the use of 64-bit integers, which may cause rounding issues in JavaScript.
    // ignore: avoid_js_rounded_ints
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}
