import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/database_service.dart';
import 'package:multichoice/get_it_injection.config.dart';

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
