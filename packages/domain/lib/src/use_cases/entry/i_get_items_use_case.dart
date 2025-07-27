import 'package:domain/domain.dart';

/// Domain use case for getting entries
/// Contains business rules and validation logic
abstract class IGetItemsUseCase {
  Future<List<Item>> execute(String tabId);
}
