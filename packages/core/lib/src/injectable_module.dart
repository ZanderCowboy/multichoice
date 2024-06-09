import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:models/models.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @preResolve
  Future<SharedPreferences> get sharedPref async {
    final sharedPref = await SharedPreferences.getInstance();

    return sharedPref;
  }
}
