import 'package:mockito/annotations.dart';
import 'package:multichoice/repositories/export_repositories.dart';

@GenerateNiceMocks([
  MockSpec<TabsRepository>(as: #MockTabsRepository),
  MockSpec<EntryRepository>(as: #MockEntryRepository),
])
void main() {}
