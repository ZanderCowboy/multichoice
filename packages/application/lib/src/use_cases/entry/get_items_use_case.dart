import 'package:domain/domain.dart';

class GetItemsUseCaseImpl implements IGetItemsUseCase {
  const GetItemsUseCaseImpl(this._itemRepository);

  final IItemRepository _itemRepository;

  @override
  Future<List<Item>> execute(String collectionId) async {
    // Business rule: validate tabId
    if (collectionId.trim().isEmpty) {
      throw ArgumentError('Collection ID cannot be empty');
    }

    // Get entries from repository
    final entries = await _itemRepository.getItems();

    // Business rule: filter out invalid entries
    final validEntries =
        entries.where((entry) => entry.collectionId == collectionId).toList();

    // Business rule: sort by creation date (newest first)
    validEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return validEntries;
  }
}
