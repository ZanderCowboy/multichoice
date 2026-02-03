import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:models/models.dart';

Future<Isar> configureIsarInstance() async {
  await closeIsarInstance();
  await Isar.initializeIsarCore(download: true);
  return await Isar.open([TabsSchema, EntrySchema], directory: '');
}

Future<void> closeIsarInstance() async {
  if (Isar.getInstance()?.isOpen ?? false) {
    await Isar.getInstance()?.close();
  }
}

Future<void> configureTestDependencies() async {
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
        },
      );

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
        },
      );

  await configureCoreDependencies();
}
