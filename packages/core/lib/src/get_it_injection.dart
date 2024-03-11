import 'package:core/src/get_it_injection.config.dart';
import 'package:core/src/services/implementations/database_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final coreSl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureCoreDependencies() async {
  coreSl.registerLazySingleton<DatabaseService>(() => DatabaseService.instance);

  return coreSl.init();
}
