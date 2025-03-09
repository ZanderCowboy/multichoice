import 'package:core/src/get_it_injection.config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:clock/clock.dart';

final coreSl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureCoreDependencies() async {
  coreSl.registerLazySingleton<Clock>(() => Clock());
  coreSl.registerLazySingleton<FilePicker>(() => FilePicker.platform);

  return coreSl.init();
}
