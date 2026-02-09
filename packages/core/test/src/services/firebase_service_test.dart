import 'dart:convert';

import 'package:core/src/services/implementations/firebase_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockFirebaseRemoteConfig mockRemoteConfig;
  late FirebaseService firebaseService;

  setUp(() {
    mockRemoteConfig = MockFirebaseRemoteConfig();

    when(
      mockRemoteConfig.setConfigSettings(any),
    ).thenAnswer((_) async {});

    when(
      mockRemoteConfig.setDefaults(any),
    ).thenAnswer((_) async {});

    when(
      mockRemoteConfig.fetchAndActivate(),
    ).thenAnswer((_) async => true);

    when(
      mockRemoteConfig.getString(any),
    ).thenReturn('');

    when(
      mockRemoteConfig.getBool(any),
    ).thenReturn(false);

    when(mockRemoteConfig.settings).thenReturn(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(hours: 2),
      ),
    );

    firebaseService = FirebaseService(remoteConfig: mockRemoteConfig);
  });

  group('FirebaseService - initialize', () {
    test(
      'should configure settings and defaults on first initialize',
      () async {
        await firebaseService.initialize();

        verify(
          mockRemoteConfig.setConfigSettings(
            any,
          ),
        ).called(1);
        verify(
          mockRemoteConfig.setDefaults(
            any,
          ),
        ).called(1);
      },
    );

    test('should not reinitialize when already initialized', () async {
      await firebaseService.initialize();
      await firebaseService.initialize();

      verify(
        mockRemoteConfig.setConfigSettings(
          any,
        ),
      ).called(1);
      verify(
        mockRemoteConfig.setDefaults(
          any,
        ),
      ).called(1);
    });

    test('should rethrow errors during initialization', () async {
      when(
        mockRemoteConfig.setConfigSettings(any),
      ).thenThrow(Exception('init error'));

      expect(
        () => firebaseService.initialize(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FirebaseService - fetchAndActivate', () {
    test('should initialize before fetching when not initialized', () async {
      await firebaseService.fetchAndActivate();

      verify(
        mockRemoteConfig.setConfigSettings(any),
      ).called(1);
      verify(
        mockRemoteConfig.setDefaults(any),
      ).called(1);
      verify(
        mockRemoteConfig.fetchAndActivate(),
      ).called(1);
    });

    test('should rethrow errors from fetchAndActivate', () async {
      when(
        mockRemoteConfig.fetchAndActivate(),
      ).thenThrow(Exception('fetch error'));

      expect(
        () => firebaseService.fetchAndActivate(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FirebaseService - forceFetchAndActivate', () {
    test(
      'should temporarily set minimumFetchInterval to zero and then restore',
      () async {
        final originalSettings = RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 15),
          minimumFetchInterval: const Duration(hours: 3),
        );

        when(mockRemoteConfig.settings).thenReturn(originalSettings);

        await firebaseService.forceFetchAndActivate();

        verifyInOrder([
          mockRemoteConfig.setConfigSettings(
            argThat(
              isA<RemoteConfigSettings>().having(
                (s) => s.minimumFetchInterval,
                'minimumFetchInterval',
                Duration.zero,
              ),
            ),
          ),
          mockRemoteConfig.fetchAndActivate(),
          mockRemoteConfig.setConfigSettings(
            argThat(
              equals(originalSettings),
            ),
          ),
        ]);
      },
    );

    test('should rethrow errors during forceFetchAndActivate', () async {
      when(
        mockRemoteConfig.fetchAndActivate(),
      ).thenThrow(Exception('force fetch error'));

      expect(
        () => firebaseService.forceFetchAndActivate(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FirebaseService - getConfig', () {
    test('should initialize before reading config', () async {
      when(
        mockRemoteConfig.getString(any),
      ).thenReturn('{"value": 1}');

      final result = await firebaseService.getConfig<int>(
        FirebaseConfigKeys.changelog,
        (json) => json['value'] as int,
      );

      expect(result, 1);
      verify(mockRemoteConfig.setConfigSettings(any)).called(1);
      verify(mockRemoteConfig.setDefaults(any)).called(1);
      verify(
        mockRemoteConfig.getString(FirebaseConfigKeys.changelog.key),
      ).called(1);
    });

    test('should return null when config string is empty', () async {
      when(
        mockRemoteConfig.getString(any),
      ).thenReturn('');

      final result = await firebaseService.getConfig<int>(
        FirebaseConfigKeys.changelog,
        (json) => json['value'] as int,
      );

      expect(result, isNull);
    });

    test('should return parsed value when JSON is valid', () async {
      when(
        mockRemoteConfig.getString(any),
      ).thenReturn('{"value": 42}');

      final result = await firebaseService.getConfig<int>(
        FirebaseConfigKeys.changelog,
        (json) => json['value'] as int,
      );

      expect(result, 42);
    });

    test('should return null when JSON is invalid', () async {
      when(
        mockRemoteConfig.getString(any),
      ).thenReturn('not-json');

      final result = await firebaseService.getConfig<int>(
        FirebaseConfigKeys.changelog,
        (json) => json['value'] as int,
      );

      expect(result, isNull);
    });

    test('should return null when fromJson throws', () async {
      when(
        mockRemoteConfig.getString(any),
      ).thenReturn(jsonEncode({'value': 10}));

      final result = await firebaseService.getConfig<int>(
        FirebaseConfigKeys.changelog,
        (json) => throw Exception('parse error'),
      );

      expect(result, isNull);
    });
  });

  group('FirebaseService - isEnabled', () {
    test(
      'should return false and not call getBool when not initialized',
      () async {
        final service = FirebaseService(remoteConfig: mockRemoteConfig);

        final result = service.isEnabled(FirebaseConfigKeys.changelog);

        expect(result, false);
        verifyNever(mockRemoteConfig.getBool(any));
      },
    );

    test('should return value from getBool when initialized', () async {
      when(
        mockRemoteConfig.getBool(any),
      ).thenReturn(true);

      await firebaseService.initialize();

      final result = firebaseService.isEnabled(FirebaseConfigKeys.changelog);

      expect(result, true);
      verify(
        mockRemoteConfig.getBool(FirebaseConfigKeys.changelog.key),
      ).called(1);
    });

    test('should return false when getBool throws', () async {
      when(
        mockRemoteConfig.getBool(any),
      ).thenThrow(Exception('bool error'));

      await firebaseService.initialize();

      final result = firebaseService.isEnabled(FirebaseConfigKeys.changelog);

      expect(result, false);
    });
  });

  group('FirebaseService - getString', () {
    test('should initialize before getting string', () async {
      when(
        mockRemoteConfig.getString(any),
      ).thenReturn('hello');

      final result = await firebaseService.getString(
        FirebaseConfigKeys.welcomeMessage,
      );

      expect(result, 'hello');
      verify(mockRemoteConfig.setConfigSettings(any)).called(1);
      verify(mockRemoteConfig.setDefaults(any)).called(1);
      verify(
        mockRemoteConfig.getString(FirebaseConfigKeys.welcomeMessage.key),
      ).called(1);
    });

    test('should return null when getString throws', () async {
      when(
        mockRemoteConfig.getString(any),
      ).thenThrow(Exception('string error'));

      final result = await firebaseService.getString(
        FirebaseConfigKeys.welcomeMessage,
      );

      expect(result, isNull);
    });
  });
}
