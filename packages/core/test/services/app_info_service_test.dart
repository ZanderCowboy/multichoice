import 'package:core/src/services/implementations/app_info_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:isar/isar.dart';

import '../helpers/fake_path_provider_platform.dart';
import '../injection.dart';

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

  tearDown(() async {
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
}
