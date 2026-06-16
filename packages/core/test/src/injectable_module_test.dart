import 'package:core/src/injectable_module.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Concrete class to exercise [InjectableModule] getters in tests.
class _TestInjectableModule extends InjectableModule {}

void main() {
  late InjectableModule module;

  setUp(() {
    module = _TestInjectableModule();
  });

  test('flutterSecureStorage returns FlutterSecureStorage', () {
    expect(module.flutterSecureStorage, isA<FlutterSecureStorage>());
  });

  test('googleSignIn returns GoogleSignIn instance', () {
    expect(module.googleSignIn, isA<GoogleSignIn>());
  });
}
