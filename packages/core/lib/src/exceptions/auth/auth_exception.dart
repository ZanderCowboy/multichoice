/// Exception for auth-related failures (signup, sign-in, OAuth).
class AuthException implements Exception {
  const AuthException(this.message);

  const AuthException.userCreationFailed() : this('User creation failed');

  const AuthException.tokenUnavailable()
      : this('Failed to get authentication token');

  const AuthException.signInFailed() : this('Sign in failed');

  const AuthException.signInCancelled() : this('Sign in cancelled');

  const AuthException.noSignedInUser()
      : this('No signed-in user. Sign in to change your password.');

  factory AuthException.firebaseMessage(String message) =>
      AuthException(message);

  factory AuthException.signUpFailed(Object error) =>
      AuthException('Sign up failed: $error');

  factory AuthException.emailSignInFailed(Object error) =>
      AuthException('Sign in failed: $error');

  factory AuthException.googleSignInFailed(Object error) =>
      AuthException('Google sign-in failed: $error');

  final String message;

  @override
  String toString() => message;
}
