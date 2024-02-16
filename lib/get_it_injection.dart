import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/get_it_injection.config.dart';
import 'package:multichoice/services/interfaces/i_database_service.dart';

final coreSl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
GetIt configureCoreDependencies() {
  coreSl.registerLazySingleton<DatabaseService>(() => DatabaseService.instance);

  return coreSl.init();
}
