import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:multichoice/domain/export_domain.dart';
import 'package:path_provider/path_provider.dart';

@module
abstract class InjectableModule {
  @preResolve
  Future<Isar> get isar async {
    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        TabsSchema,
        EntrySchema,
      ],
      directory: directory.path,
      name: 'MultichoiceDB',
    );

    return isar;
  }
}