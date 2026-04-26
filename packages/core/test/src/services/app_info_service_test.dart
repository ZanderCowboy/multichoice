import 'package:core/src/services/implementations/app_info_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:isar_community/isar.dart';

import '../helpers/fake_path_provider_platform.dart';
import '../../injection.dart';

void main() {
  late AppInfoService appInfoService;
  late Isar db;

  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();

    PackageInfo.setMockInitialValues(
      appName: 'Test App',
      packageName: 'com.example.test',
      version: '1.0.0',
      buildNumber: '45',
      buildSignature: 'signature',
    );

    db = await configureIsarInstance();
  });

  setUp(() async {
    appInfoService = AppInfoService();
  });

  tearDownAll(() async {
    await db.close();
  });

  test('should return correct app version', () async {
    // Arrange
    const expectedVersion = '1.0.0+45';

    // Act
    final result = await appInfoService.getAppVersion();

    // Assert
    expect(result, expectedVersion);
  });

  group('isUpdateAvailable', () {
    test('returns false when latest version is empty', () async {
      final result = await appInfoService.isUpdateAvailable('');
      expect(result, false);
    });

    test('returns false when latest version is invalid', () async {
      final result = await appInfoService.isUpdateAvailable('not-a-version');
      expect(result, false);
    });

    test('returns false when latest version equals current version', () async {
      final result = await appInfoService.isUpdateAvailable('1.0.0');
      expect(result, false);
    });

    test('returns true when latest version is greater than current version',
        () async {
      final result = await appInfoService.isUpdateAvailable('1.1.0');
      expect(result, true);
    });

    test('returns false when latest version is lower than current version',
        () async {
      final result = await appInfoService.isUpdateAvailable('0.9.9');
      expect(result, false);
    });
  });
}
