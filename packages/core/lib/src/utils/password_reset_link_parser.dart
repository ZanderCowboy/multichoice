/// Extracts a Firebase password-reset OOB code from an incoming deep link.
String? parsePasswordResetOobCode(Uri uri) {
  final directCode = uri.queryParameters['oobCode'];
  if (directCode != null && directCode.isNotEmpty) {
    final mode = uri.queryParameters['mode'];
    if (mode == null || mode.isEmpty || mode == 'resetPassword') {
      return directCode;
    }
  }

  final nestedLink = uri.queryParameters['link'];
  if (nestedLink != null && nestedLink.isNotEmpty) {
    return parsePasswordResetOobCode(Uri.parse(nestedLink));
  }

  final continueUrl = uri.queryParameters['continueUrl'];
  if (continueUrl != null && continueUrl.isNotEmpty) {
    return parsePasswordResetOobCode(Uri.parse(continueUrl));
  }

  return null;
}

bool isPasswordResetLink(Uri uri) {
  final mode = uri.queryParameters['mode'];
  if (mode == 'resetPassword') {
    return true;
  }

  final nestedLink = uri.queryParameters['link'];
  if (nestedLink != null && nestedLink.isNotEmpty) {
    return isPasswordResetLink(Uri.parse(nestedLink));
  }

  return parsePasswordResetOobCode(uri) != null;
}
