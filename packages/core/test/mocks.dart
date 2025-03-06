import 'package:core/src/repositories/export_repositories.dart';
import 'package:core/src/wrappers/export.dart';
import 'package:isar/isar.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<TabsRepository>(as: #MockTabsRepository),
  MockSpec<EntryRepository>(as: #MockEntryRepository),
  MockSpec<Isar>(as: #MockIsar),
  MockSpec<IFilePickerWrapper>(as: #MockFilePickerWrapper)
])
void main() {}
