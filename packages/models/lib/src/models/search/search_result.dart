import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@CopyWith()
@JsonSerializable()
class SearchResult extends Equatable {
  const SearchResult({
    required this.isTab,
    required this.item,
    required this.matchScore,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  final bool isTab;
  final dynamic item;
  final double matchScore;

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  List<Object?> get props => [isTab, item, matchScore];
}
