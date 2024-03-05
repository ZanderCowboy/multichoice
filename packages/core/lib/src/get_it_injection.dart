import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:core/src/get_it_injection.config.dart';
import 'package:core/src/services/interfaces/i_database_service.dart';

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
