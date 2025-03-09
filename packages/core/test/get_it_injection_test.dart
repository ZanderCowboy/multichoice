import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:core/src/get_it_injection.dart';
import 'package:clock/clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getApplicationDocumentsDirectory':
          return '';
        default:
          return null;
      }
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            MethodChannel('plugins.flutter.io/shared_preferences'),
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getAll':
          return <String, dynamic>{};
        default:
          return null;
      }
    });

    await configureCoreDependencies();
  });

  test('Clock should be registered as a singleton', () {
    final clock = GetIt.instance<Clock>();
    expect(clock, isA<Clock>());
  });
}
