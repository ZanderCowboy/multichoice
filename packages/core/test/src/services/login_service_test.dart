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

  group('LoginService storeUsernameEmailMapping', () {
    test('persists normalized username to email mapping', () async {
      when(mockStorage.read(key: 'username_email_map'))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await service.storeUsernameEmailMapping('Alice', 'alice@example.com');

      final captured = verify(
        mockStorage.write(key: 'username_email_map', value: captureAnyNamed('value')),
      ).captured.single as String;
      expect(captured, contains('"alice":"alice@example.com"'));
    });

    test('merges with existing map', () async {
      when(mockStorage.read(key: 'username_email_map')).thenAnswer(
        (_) async => '{"bob":"bob@example.com"}',
      );
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await service.storeUsernameEmailMapping('alice', 'alice@example.com');

      final captured = verify(
        mockStorage.write(key: 'username_email_map', value: captureAnyNamed('value')),
      ).captured.single as String;
      expect(captured, contains('"bob":"bob@example.com"'));
      expect(captured, contains('"alice":"alice@example.com"'));
    });

    test('skips when username or email is empty', () async {
      await service.storeUsernameEmailMapping('', 'a@b.com');
      await service.storeUsernameEmailMapping('user', '');

      verifyNever(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')));
    });
  });

  group('LoginService resolveEmailForLogin', () {
    test('returns trimmed email when identifier contains @', () async {
      expect(
        await service.resolveEmailForLogin('  user@example.com  '),
        'user@example.com',
      );
      verifyNever(mockStorage.read(key: anyNamed('key')));
    });

    test('returns mapped email for username', () async {
      when(mockStorage.read(key: 'username_email_map')).thenAnswer(
        (_) async => '{"alice":"alice@example.com"}',
      );

      expect(await service.resolveEmailForLogin('Alice'), 'alice@example.com');
    });

    test('returns null when username is not mapped', () async {
      when(mockStorage.read(key: 'username_email_map'))
          .thenAnswer((_) async => '{}');

      expect(await service.resolveEmailForLogin('unknown'), null);
    });

    test('returns empty map when stored json is invalid', () async {
      when(mockStorage.read(key: 'username_email_map'))
          .thenAnswer((_) async => 'not-json');

      expect(await service.resolveEmailForLogin('alice'), null);
    });
  });

  group('LoginService username confirmation', () {
    test('markUsernameConfirmed skips empty user id', () async {
      await service.markUsernameConfirmed('');

      verifyNever(mockStorage.read(key: anyNamed('key')));
      verifyNever(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')));
    });

    test('markUsernameConfirmed persists user id', () async {
      when(mockStorage.read(key: 'username_confirmed_user_ids'))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await service.markUsernameConfirmed('uid-1');

      verify(
        mockStorage.write(
          key: 'username_confirmed_user_ids',
          value: '["uid-1"]',
        ),
      ).called(1);
    });

    test('isUsernameConfirmed returns false for empty user id', () async {
      expect(await service.isUsernameConfirmed(''), false);
      verifyNever(mockStorage.read(key: anyNamed('key')));
    });

    test('isUsernameConfirmed returns true when user id is stored', () async {
      when(mockStorage.read(key: 'username_confirmed_user_ids')).thenAnswer(
        (_) async => '["uid-1","uid-2"]',
      );

      expect(await service.isUsernameConfirmed('uid-2'), true);
      expect(await service.isUsernameConfirmed('uid-3'), false);
    });

    test('isUsernameConfirmed returns false when stored json is invalid', () async {
      when(mockStorage.read(key: 'username_confirmed_user_ids'))
          .thenAnswer((_) async => 'not-json');

      expect(await service.isUsernameConfirmed('uid-1'), false);
    });
  });
}
