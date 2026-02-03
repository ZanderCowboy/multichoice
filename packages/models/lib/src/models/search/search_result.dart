import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@CopyWith()
@JsonSerializable()
class SearchResult {
  const SearchResult({
    required this.isTab,
    required this.item,
    required this.matchScore,
  });

  final bool isTab;
  final dynamic item;
  final double matchScore;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          isTab == other.isTab &&
          item == other.item &&
          matchScore == other.matchScore;

  @override
  int get hashCode => isTab.hashCode ^ item.hashCode ^ matchScore.hashCode;

  @override
  String toString() =>
      'SearchResult(isTab: $isTab, item: $item, matchScore: $matchScore)';
}
