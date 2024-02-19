// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EntryDTO _$EntryDTOFromJson(Map<String, dynamic> json) {
  return _EntryDTO.fromJson(json);
}

/// @nodoc
mixin _$EntryDTO {
  int get id => throw _privateConstructorUsedError;
  int get tabId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EntryDTOCopyWith<EntryDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryDTOCopyWith<$Res> {
  factory $EntryDTOCopyWith(EntryDTO value, $Res Function(EntryDTO) then) =
      _$EntryDTOCopyWithImpl<$Res, EntryDTO>;
  @useResult
  $Res call(
      {int id, int tabId, String title, String subtitle, DateTime? timestamp});
}

/// @nodoc
class _$EntryDTOCopyWithImpl<$Res, $Val extends EntryDTO>
    implements $EntryDTOCopyWith<$Res> {
  _$EntryDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tabId = null,
    Object? title = null,
    Object? subtitle = null,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tabId: null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntryDTOImplCopyWith<$Res>
    implements $EntryDTOCopyWith<$Res> {
  factory _$$EntryDTOImplCopyWith(
          _$EntryDTOImpl value, $Res Function(_$EntryDTOImpl) then) =
      __$$EntryDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, int tabId, String title, String subtitle, DateTime? timestamp});
}

/// @nodoc
class __$$EntryDTOImplCopyWithImpl<$Res>
    extends _$EntryDTOCopyWithImpl<$Res, _$EntryDTOImpl>
    implements _$$EntryDTOImplCopyWith<$Res> {
  __$$EntryDTOImplCopyWithImpl(
      _$EntryDTOImpl _value, $Res Function(_$EntryDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tabId = null,
    Object? title = null,
    Object? subtitle = null,
    Object? timestamp = freezed,
  }) {
    return _then(_$EntryDTOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tabId: null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntryDTOImpl implements _EntryDTO {
  _$EntryDTOImpl(
      {required this.id,
      required this.tabId,
      required this.title,
      required this.subtitle,
      required this.timestamp});

  factory _$EntryDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryDTOImplFromJson(json);

  @override
  final int id;
  @override
  final int tabId;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'EntryDTO(id: $id, tabId: $tabId, title: $title, subtitle: $subtitle, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryDTOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tabId, tabId) || other.tabId == tabId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tabId, title, subtitle, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryDTOImplCopyWith<_$EntryDTOImpl> get copyWith =>
      __$$EntryDTOImplCopyWithImpl<_$EntryDTOImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryDTOImplToJson(
      this,
    );
  }
}

abstract class _EntryDTO implements EntryDTO {
  factory _EntryDTO(
      {required final int id,
      required final int tabId,
      required final String title,
      required final String subtitle,
      required final DateTime? timestamp}) = _$EntryDTOImpl;

  factory _EntryDTO.fromJson(Map<String, dynamic> json) =
      _$EntryDTOImpl.fromJson;

  @override
  int get id;
  @override
  int get tabId;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$EntryDTOImplCopyWith<_$EntryDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
