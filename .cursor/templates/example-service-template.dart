// Template for creating a new service
// Copy this file and replace <ServiceName> with your actual service name

import 'package:core/core.dart';

// 1. Create interface file: interfaces/i_<service_name>_service.dart
abstract class I<ServiceName>Service {
  Future<Result<void>> exampleMethod();
}

// 2. Create implementation file: implementations/<service_name>_service.dart
@injectable
class <ServiceName>Service implements I<ServiceName>Service {
  <ServiceName>Service();

  @override
  Future<Result<void>> exampleMethod() async {
    try {
      // Implementation here
      return Result.success(null);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}

// 3. Register in injectable_module.dart
// Add: @module
// abstract class <ServiceName>Module {
//   @lazySingleton
//   I<ServiceName>Service get <serviceName>Service => <ServiceName>Service();
// }
