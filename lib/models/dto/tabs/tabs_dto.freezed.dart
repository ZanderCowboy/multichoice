// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tabs_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TabsDTO _$TabsDTOFromJson(Map<String, dynamic> json) {
  return _TabsDTO.fromJson(json);
}

/// @nodoc
mixin _$TabsDTO {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TabsDTOCopyWith<TabsDTO> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TabsDTOCopyWith<$Res> {
  factory $TabsDTOCopyWith(TabsDTO value, $Res Function(TabsDTO) then) =
      _$TabsDTOCopyWithImpl<$Res, TabsDTO>;
  @useResult
  $Res call({int id, String title, String? subtitle, DateTime? timestamp});
}

/// @nodoc
class _$TabsDTOCopyWithImpl<$Res, $Val extends TabsDTO>
    implements $TabsDTOCopyWith<$Res> {
  _$TabsDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TabsDTOImplCopyWith<$Res> implements $TabsDTOCopyWith<$Res> {
  factory _$$TabsDTOImplCopyWith(
          _$TabsDTOImpl value, $Res Function(_$TabsDTOImpl) then) =
      __$$TabsDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, String? subtitle, DateTime? timestamp});
}

/// @nodoc
class __$$TabsDTOImplCopyWithImpl<$Res>
    extends _$TabsDTOCopyWithImpl<$Res, _$TabsDTOImpl>
    implements _$$TabsDTOImplCopyWith<$Res> {
  __$$TabsDTOImplCopyWithImpl(
      _$TabsDTOImpl _value, $Res Function(_$TabsDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$TabsDTOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TabsDTOImpl implements _TabsDTO {
  _$TabsDTOImpl(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.timestamp});

  factory _$TabsDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$TabsDTOImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'TabsDTO(id: $id, title: $title, subtitle: $subtitle, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TabsDTOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, subtitle, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TabsDTOImplCopyWith<_$TabsDTOImpl> get copyWith =>
      __$$TabsDTOImplCopyWithImpl<_$TabsDTOImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TabsDTOImplToJson(
      this,
    );
  }
}

abstract class _TabsDTO implements TabsDTO {
  factory _TabsDTO(
      {required final int id,
      required final String title,
      required final String? subtitle,
      required final DateTime? timestamp}) = _$TabsDTOImpl;

  factory _TabsDTO.fromJson(Map<String, dynamic> json) = _$TabsDTOImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get subtitle;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$TabsDTOImplCopyWith<_$TabsDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
