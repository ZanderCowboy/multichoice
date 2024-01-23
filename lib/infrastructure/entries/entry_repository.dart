import 'package:injectable/injectable.dart';
import 'package:multichoice/data/persistance/models/tabs_list.dart';
import 'package:multichoice/domain/entry/i_entry_repository.dart';
import 'package:multichoice/domain/entry/models/entry.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: IEntryRepository)
class EntryRepository implements IEntryRepository {
  EntryRepository();

  final tabsList = TabsList.instance;

  @override
  Future<int> addEntry(
    String tabId,
    String title,
    String subtitle,
  ) async {
    tabsList.addEntryToTab(
      tabId,
      Entry(
        uuid: const Uuid().v4(),
        tabId: tabId,
        title: title,
        subtitle: subtitle,
      ),
    );

    return 0;
  }

  @override
  List<Entry> readEntries(String tabId) {
    final entries = tabsList.readEntries(tabId) ?? [];
    return entries;
  }

  @override
  Future<int> deleteEntry(String tabId, String entryId) async {
    tabsList.deleteEntryInTab(tabId, entryId);

    return 0;
  }
}
