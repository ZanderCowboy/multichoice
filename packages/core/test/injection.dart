import 'package:isar/isar.dart';
import 'package:models/models.dart';

Future<Isar> configureTestCoreDependencies() async {
  await Isar.initializeIsarCore(download: true);
  return await Isar.open([TabsSchema, EntrySchema], directory: '');
}

Future<void> closeIsarInstance() async {
  if (Isar.getInstance()?.isOpen ?? false) {
    await Isar.getInstance()?.close();
  }
}
