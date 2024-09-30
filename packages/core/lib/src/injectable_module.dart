import 'package:core/src/global_keys.dart';
import 'package:core/src/showcase_manager.dart';
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
    final _sharedPref = await SharedPreferences.getInstance();

    _sharedPref.setBool(Keys.hasShowcaseStarted, false);
    _sharedPref.setBool(Keys.isStepOneFinished, false);
    _sharedPref.setBool(Keys.isStepTwoFinished, false);
    _sharedPref.setBool(Keys.isStepThreeFinished, false);
    _sharedPref.setBool(Keys.isStepFourFinished, false);
    _sharedPref.setBool(Keys.isShowcaseFinished, false);

    return _sharedPref;
  }

  @lazySingleton
  ShowcaseManager get showcaseManager => ShowcaseManager();
}
