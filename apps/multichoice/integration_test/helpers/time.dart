import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> get oneSecond async => pump(const Duration(seconds: 1));

  Future<void> get threeSeconds async => pump(const Duration(seconds: 3));

  /// Pumps for 30 seconds
  Future<void> get hold async => pump(const Duration(seconds: 30));
}
