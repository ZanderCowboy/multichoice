import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:clock/clock.dart';

import 'injection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    configureTestDependencies();
  });

  test('Clock should be registered as a singleton', () {
    final clock = GetIt.instance<Clock>();
    expect(clock, isA<Clock>());
  });
}
