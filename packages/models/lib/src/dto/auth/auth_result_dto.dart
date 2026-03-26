import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_result_dto.g.dart';

@CopyWith()
@JsonSerializable()
class AuthResultDTO extends Equatable {
  const AuthResultDTO({
    required this.accessToken,
    required this.userId,
  });

  factory AuthResultDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthResultDTOFromJson(json);

  final String accessToken;
  final String userId;

  Map<String, dynamic> toJson() => _$AuthResultDTOToJson(this);

  @override
  List<Object?> get props => [accessToken, userId];
}
