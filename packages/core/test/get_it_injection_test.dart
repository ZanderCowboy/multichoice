import 'package:core/src/services/implementations/app_info_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'injection.dart';

final getIt = GetIt.instance;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    configureTestDependencies();
    getIt.registerSingleton(AppInfoService());
  });

  test('TabsRepository should be registered as a singleton', () {
    final appInfoService = GetIt.instance<AppInfoService>();
    expect(appInfoService, isA<AppInfoService>());
  });
}
