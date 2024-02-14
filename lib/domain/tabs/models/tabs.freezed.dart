// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tabs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tabs _$TabsFromJson(Map<String, dynamic> json) {
  return _Tabs.fromJson(json);
}

/// @nodoc
mixin _$Tabs {
  String get uuid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TabsCopyWith<Tabs> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TabsCopyWith<$Res> {
  factory $TabsCopyWith(Tabs value, $Res Function(Tabs) then) =
      _$TabsCopyWithImpl<$Res, Tabs>;
  @useResult
  $Res call({String uuid, String title, String subtitle});
}

/// @nodoc
class _$TabsCopyWithImpl<$Res, $Val extends Tabs>
    implements $TabsCopyWith<$Res> {
  _$TabsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = null,
    Object? subtitle = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TabsImplCopyWith<$Res> implements $TabsCopyWith<$Res> {
  factory _$$TabsImplCopyWith(
          _$TabsImpl value, $Res Function(_$TabsImpl) then) =
      __$$TabsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uuid, String title, String subtitle});
}

/// @nodoc
class __$$TabsImplCopyWithImpl<$Res>
    extends _$TabsCopyWithImpl<$Res, _$TabsImpl>
    implements _$$TabsImplCopyWith<$Res> {
  __$$TabsImplCopyWithImpl(_$TabsImpl _value, $Res Function(_$TabsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = null,
    Object? subtitle = null,
  }) {
    return _then(_$TabsImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TabsImpl extends _Tabs {
  const _$TabsImpl(
      {required this.uuid, required this.title, required this.subtitle})
      : super._();

  factory _$TabsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TabsImplFromJson(json);

  @override
  final String uuid;
  @override
  final String title;
  @override
  final String subtitle;

  @override
  String toString() {
    return 'Tabs(uuid: $uuid, title: $title, subtitle: $subtitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TabsImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, title, subtitle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TabsImplCopyWith<_$TabsImpl> get copyWith =>
      __$$TabsImplCopyWithImpl<_$TabsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TabsImplToJson(
      this,
    );
  }
}

abstract class _Tabs extends Tabs {
  const factory _Tabs(
      {required final String uuid,
      required final String title,
      required final String subtitle}) = _$TabsImpl;
  const _Tabs._() : super._();

  factory _Tabs.fromJson(Map<String, dynamic> json) = _$TabsImpl.fromJson;

  @override
  String get uuid;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  @JsonKey(ignore: true)
  _$$TabsImplCopyWith<_$TabsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
