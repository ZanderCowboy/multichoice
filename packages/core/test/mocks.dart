import 'package:core/src/repositories/export_repositories.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<TabsRepository>(as: #MockTabsRepository),
  MockSpec<EntryRepository>(as: #MockEntryRepository),
])
void main() {}
