// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(VerticalTab verticalTab) onPressedAddTab,
    required TResult Function() onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(VerticalTab verticalTab)? onPressedAddTab,
    TResult? Function()? onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(VerticalTab verticalTab)? onPressedAddTab,
    TResult Function()? onLongPressedDeleteTab,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(onPressedAddTab value) onPressedAddTab,
    required TResult Function(onLongPressedDeleteTab value)
        onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(onPressedAddTab value)? onPressedAddTab,
    TResult? Function(onLongPressedDeleteTab value)? onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(onPressedAddTab value)? onPressedAddTab,
    TResult Function(onLongPressedDeleteTab value)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeEventCopyWith<$Res> {
  factory $HomeEventCopyWith(HomeEvent value, $Res Function(HomeEvent) then) =
      _$HomeEventCopyWithImpl<$Res, HomeEvent>;
}

/// @nodoc
class _$HomeEventCopyWithImpl<$Res, $Val extends HomeEvent>
    implements $HomeEventCopyWith<$Res> {
  _$HomeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$onPressedAddTabImplCopyWith<$Res> {
  factory _$$onPressedAddTabImplCopyWith(_$onPressedAddTabImpl value,
          $Res Function(_$onPressedAddTabImpl) then) =
      __$$onPressedAddTabImplCopyWithImpl<$Res>;
  @useResult
  $Res call({VerticalTab verticalTab});
}

/// @nodoc
class __$$onPressedAddTabImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$onPressedAddTabImpl>
    implements _$$onPressedAddTabImplCopyWith<$Res> {
  __$$onPressedAddTabImplCopyWithImpl(
      _$onPressedAddTabImpl _value, $Res Function(_$onPressedAddTabImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verticalTab = null,
  }) {
    return _then(_$onPressedAddTabImpl(
      null == verticalTab
          ? _value.verticalTab
          : verticalTab // ignore: cast_nullable_to_non_nullable
              as VerticalTab,
    ));
  }
}

/// @nodoc

class _$onPressedAddTabImpl implements onPressedAddTab {
  const _$onPressedAddTabImpl(this.verticalTab);

  @override
  final VerticalTab verticalTab;

  @override
  String toString() {
    return 'HomeEvent.onPressedAddTab(verticalTab: $verticalTab)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$onPressedAddTabImpl &&
            (identical(other.verticalTab, verticalTab) ||
                other.verticalTab == verticalTab));
  }

  @override
  int get hashCode => Object.hash(runtimeType, verticalTab);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$onPressedAddTabImplCopyWith<_$onPressedAddTabImpl> get copyWith =>
      __$$onPressedAddTabImplCopyWithImpl<_$onPressedAddTabImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(VerticalTab verticalTab) onPressedAddTab,
    required TResult Function() onLongPressedDeleteTab,
  }) {
    return onPressedAddTab(verticalTab);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(VerticalTab verticalTab)? onPressedAddTab,
    TResult? Function()? onLongPressedDeleteTab,
  }) {
    return onPressedAddTab?.call(verticalTab);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(VerticalTab verticalTab)? onPressedAddTab,
    TResult Function()? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onPressedAddTab != null) {
      return onPressedAddTab(verticalTab);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(onPressedAddTab value) onPressedAddTab,
    required TResult Function(onLongPressedDeleteTab value)
        onLongPressedDeleteTab,
  }) {
    return onPressedAddTab(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(onPressedAddTab value)? onPressedAddTab,
    TResult? Function(onLongPressedDeleteTab value)? onLongPressedDeleteTab,
  }) {
    return onPressedAddTab?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(onPressedAddTab value)? onPressedAddTab,
    TResult Function(onLongPressedDeleteTab value)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onPressedAddTab != null) {
      return onPressedAddTab(this);
    }
    return orElse();
  }
}

abstract class onPressedAddTab implements HomeEvent {
  const factory onPressedAddTab(final VerticalTab verticalTab) =
      _$onPressedAddTabImpl;

  VerticalTab get verticalTab;
  @JsonKey(ignore: true)
  _$$onPressedAddTabImplCopyWith<_$onPressedAddTabImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$onLongPressedDeleteTabImplCopyWith<$Res> {
  factory _$$onLongPressedDeleteTabImplCopyWith(
          _$onLongPressedDeleteTabImpl value,
          $Res Function(_$onLongPressedDeleteTabImpl) then) =
      __$$onLongPressedDeleteTabImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$onLongPressedDeleteTabImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$onLongPressedDeleteTabImpl>
    implements _$$onLongPressedDeleteTabImplCopyWith<$Res> {
  __$$onLongPressedDeleteTabImplCopyWithImpl(
      _$onLongPressedDeleteTabImpl _value,
      $Res Function(_$onLongPressedDeleteTabImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$onLongPressedDeleteTabImpl implements onLongPressedDeleteTab {
  const _$onLongPressedDeleteTabImpl();

  @override
  String toString() {
    return 'HomeEvent.onLongPressedDeleteTab()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$onLongPressedDeleteTabImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(VerticalTab verticalTab) onPressedAddTab,
    required TResult Function() onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(VerticalTab verticalTab)? onPressedAddTab,
    TResult? Function()? onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(VerticalTab verticalTab)? onPressedAddTab,
    TResult Function()? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteTab != null) {
      return onLongPressedDeleteTab();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(onPressedAddTab value) onPressedAddTab,
    required TResult Function(onLongPressedDeleteTab value)
        onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(onPressedAddTab value)? onPressedAddTab,
    TResult? Function(onLongPressedDeleteTab value)? onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(onPressedAddTab value)? onPressedAddTab,
    TResult Function(onLongPressedDeleteTab value)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteTab != null) {
      return onLongPressedDeleteTab(this);
    }
    return orElse();
  }
}

abstract class onLongPressedDeleteTab implements HomeEvent {
  const factory onLongPressedDeleteTab() = _$onLongPressedDeleteTabImpl;
}

/// @nodoc
mixin _$HomeState {
  VerticalTab get verticalTab => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  bool get isAdded => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {VerticalTab verticalTab,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verticalTab = null,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      verticalTab: null == verticalTab
          ? _value.verticalTab
          : verticalTab // ignore: cast_nullable_to_non_nullable
              as VerticalTab,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdded: null == isAdded
          ? _value.isAdded
          : isAdded // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {VerticalTab verticalTab,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verticalTab = null,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HomeStateImpl(
      verticalTab: null == verticalTab
          ? _value.verticalTab
          : verticalTab // ignore: cast_nullable_to_non_nullable
              as VerticalTab,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdded: null == isAdded
          ? _value.isAdded
          : isAdded // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {required this.verticalTab,
      required this.isLoading,
      required this.isDeleted,
      required this.isAdded,
      required this.errorMessage});

  @override
  final VerticalTab verticalTab;
  @override
  final bool isLoading;
  @override
  final bool isDeleted;
  @override
  final bool isAdded;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HomeState(verticalTab: $verticalTab, isLoading: $isLoading, isDeleted: $isDeleted, isAdded: $isAdded, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.verticalTab, verticalTab) ||
                other.verticalTab == verticalTab) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.isAdded, isAdded) || other.isAdded == isAdded) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, verticalTab, isLoading, isDeleted, isAdded, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {required final VerticalTab verticalTab,
      required final bool isLoading,
      required final bool isDeleted,
      required final bool isAdded,
      required final String? errorMessage}) = _$HomeStateImpl;

  @override
  VerticalTab get verticalTab;
  @override
  bool get isLoading;
  @override
  bool get isDeleted;
  @override
  bool get isAdded;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
