import 'package:core/src/services/implementations/login_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late LoginService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = LoginService(mockStorage);
  });

  group('LoginService storeLoginInfo', () {
    test('writes access token and login status', () async {
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await service.storeLoginInfo('tok');

      verify(mockStorage.write(key: 'access_token', value: 'tok')).called(1);
      verify(mockStorage.write(key: 'login_status', value: 'true')).called(1);
    });
  });

  group('LoginService isUserLoggedIn', () {
    test('returns false when token is null', () async {
      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => null);

      expect(await service.isUserLoggedIn(), false);
    });

    test('returns false when token is empty', () async {
      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => '');

      expect(await service.isUserLoggedIn(), false);
    });

    test('returns true when token is non-empty', () async {
      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => 'x');

      expect(await service.isUserLoggedIn(), true);
    });
  });

  group('LoginService getAccessToken', () {
    test('returns empty string when missing', () async {
      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => null);

      expect(await service.getAccessToken(), '');
    });

    test('returns stored value', () async {
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => 'abc');

      expect(await service.getAccessToken(), 'abc');
    });
  });

  group('LoginService deleteLoginInfo', () {
    test('deletes session and profile keys', () async {
      when(mockStorage.delete(key: anyNamed('key'))).thenAnswer((_) async {});

      await service.deleteLoginInfo();

      verify(mockStorage.delete(key: 'access_token')).called(1);
      verify(mockStorage.delete(key: 'login_status')).called(1);
      verify(mockStorage.delete(key: 'profile_email')).called(1);
      verify(mockStorage.delete(key: 'profile_username')).called(1);
    });
  });

  group('LoginService storeUserProfile', () {
    test('writes only non-empty email', () async {
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await service.storeUserProfile(email: 'a@b.com');

      verify(mockStorage.write(key: 'profile_email', value: 'a@b.com')).called(1);
    });

    test('writes only non-empty username', () async {
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await service.storeUserProfile(username: 'bob');

      verify(mockStorage.write(key: 'profile_username', value: 'bob')).called(1);
    });

    test('skips empty strings', () async {
      await service.storeUserProfile(email: '', username: '');

      verifyNever(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')));
    });
  });

  group('LoginService getProfileEmail', () {
    test('returns null when missing or empty', () async {
      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => null);
      expect(await service.getProfileEmail(), null);

      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => '');
      expect(await service.getProfileEmail(), null);
    });

    test('returns value when non-empty', () async {
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => 'e@e.com');

      expect(await service.getProfileEmail(), 'e@e.com');
    });
  });

  group('LoginService getProfileUsername', () {
    test('returns null when missing or empty', () async {
      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => null);
      expect(await service.getProfileUsername(), null);

      when(mockStorage.read(key: anyNamed('key'))).thenAnswer((_) async => '');
      expect(await service.getProfileUsername(), null);
    });

    test('returns value when non-empty', () async {
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => 'alice');

      expect(await service.getProfileUsername(), 'alice');
    });
  });
}
