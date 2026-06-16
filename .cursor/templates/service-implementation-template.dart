// Service implementation template
// Path: packages/core/lib/src/services/implementations/<feature>_service.dart
// Register via build_runner (injectable) — no manual module needed.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: I<Feature>Service)
class <Feature>Service implements I<Feature>Service {
  <Feature>Service();

  @override
  Future<void> exampleMethod() async {
    // Implementation
  }
}
