import 'dart:convert';

import 'package:core/src/services/interfaces/i_login_service.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _accessTokenKey = 'access_token';
const _loginStatusKey = 'login_status';
const _profileEmailKey = 'profile_email';
const _profileUsernameKey = 'profile_username';
const _usernameEmailMapKey = 'username_email_map';
const _usernameConfirmedUserIdsKey = 'username_confirmed_user_ids';

@LazySingleton(as: ILoginService)
class LoginService extends ILoginService {
  LoginService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> storeLoginInfo(String accessToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _loginStatusKey, value: 'true');
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey) ?? '';
  }

  @override
  Future<void> deleteLoginInfo() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _loginStatusKey);
    await _secureStorage.delete(key: _profileEmailKey);
    await _secureStorage.delete(key: _profileUsernameKey);
  }

  @override
  Future<void> storeUserProfile({String? email, String? username}) async {
    if (email != null && email.isNotEmpty) {
      await _secureStorage.write(key: _profileEmailKey, value: email);
    }
    if (username != null && username.isNotEmpty) {
      await _secureStorage.write(key: _profileUsernameKey, value: username);
    }
  }

  @override
  Future<String?> getProfileEmail() async {
    final v = await _secureStorage.read(key: _profileEmailKey);
    return v?.isEmpty ?? true ? null : v;
  }

  @override
  Future<String?> getProfileUsername() async {
    final v = await _secureStorage.read(key: _profileUsernameKey);
    return v?.isEmpty ?? true ? null : v;
  }

  @override
  Future<void> storeUsernameEmailMapping(String username, String email) async {
    final normalizedUsername = username.trim().toLowerCase();
    final normalizedEmail = email.trim();
    if (normalizedUsername.isEmpty || normalizedEmail.isEmpty) {
      return;
    }

    final map = await _readUsernameEmailMap();
    map[normalizedUsername] = normalizedEmail;
    await _secureStorage.write(
      key: _usernameEmailMapKey,
      value: jsonEncode(map),
    );
  }

  @override
  Future<String?> resolveEmailForLogin(String identifier) async {
    final trimmed = identifier.trim();
    if (trimmed.contains('@')) {
      return trimmed;
    }

    final map = await _readUsernameEmailMap();
    return map[trimmed.toLowerCase()];
  }

  Future<Map<String, String>> _readUsernameEmailMap() async {
    final raw = await _secureStorage.read(key: _usernameEmailMapKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return {};
      }
      return decoded.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    } catch (_) {
      return {};
    }
  }

  @override
  Future<void> markUsernameConfirmed(String userId) async {
    if (userId.isEmpty) {
      return;
    }

    final confirmed = await _readUsernameConfirmedUserIds();
    confirmed.add(userId);
    await _secureStorage.write(
      key: _usernameConfirmedUserIdsKey,
      value: jsonEncode(confirmed.toList()),
    );
  }

  @override
  Future<bool> isUsernameConfirmed(String userId) async {
    if (userId.isEmpty) {
      return false;
    }
    final confirmed = await _readUsernameConfirmedUserIds();
    return confirmed.contains(userId);
  }

  Future<Set<String>> _readUsernameConfirmedUserIds() async {
    final raw = await _secureStorage.read(key: _usernameConfirmedUserIdsKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return {};
      }
      return decoded.map((e) => e.toString()).toSet();
    } catch (_) {
      return {};
    }
  }
}
