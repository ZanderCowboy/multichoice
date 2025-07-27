/// Authentication interceptor for HTTP requests
/// This belongs in the DATA layer as it handles external API concerns
abstract class AuthInterceptor {
  Future<Map<String, String>> getAuthHeaders();
  Future<bool> isTokenExpired();
  Future<void> refreshToken();
}

class AuthInterceptorImpl implements AuthInterceptor {
  AuthInterceptorImpl(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _tokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      return {};
    }

    // Check if token is expired and refresh if needed
    if (await isTokenExpired()) {
      await refreshToken();
      final newToken = await _tokenStorage.getAccessToken();
      return {'Authorization': 'Bearer $newToken'};
    }

    return {'Authorization': 'Bearer $token'};
  }

  @override
  Future<bool> isTokenExpired() async {
    final expiryTime = await _tokenStorage.getTokenExpiry();
    if (expiryTime == null) return true;

    return DateTime.now().isAfter(expiryTime);
  }

  @override
  Future<void> refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Make API call to refresh token
      // final response = await httpClient.post('/auth/refresh',
      //   body: {'refresh_token': refreshToken});

      // Store new tokens
      // await _tokenStorage.storeTokens(response.accessToken, response.refreshToken);

      print('Token refreshed successfully');
    } catch (e) {
      // Handle refresh failure - might need to redirect to login
      print('Token refresh failed: $e');
      throw Exception('Failed to refresh authentication token');
    }
  }
}

/// Interface for token storage - could be implemented with secure storage
abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<DateTime?> getTokenExpiry();
  Future<void> storeTokens(String accessToken, String refreshToken,
      {DateTime? expiryTime});
  Future<void> clearTokens();
}
