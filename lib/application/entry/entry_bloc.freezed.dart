// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EntryEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(VerticalTab verticalTab, EntryCard entryCard)
        onPressedAddEntry,
    required TResult Function() onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(VerticalTab verticalTab, EntryCard entryCard)?
        onPressedAddEntry,
    TResult? Function()? onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(VerticalTab verticalTab, EntryCard entryCard)?
        onPressedAddEntry,
    TResult Function()? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(onPressedAddEntry value) onPressedAddEntry,
    required TResult Function(onLongPressedDeleteEntry value)
        onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(onPressedAddEntry value)? onPressedAddEntry,
    TResult? Function(onLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(onPressedAddEntry value)? onPressedAddEntry,
    TResult Function(onLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryEventCopyWith<$Res> {
  factory $EntryEventCopyWith(
          EntryEvent value, $Res Function(EntryEvent) then) =
      _$EntryEventCopyWithImpl<$Res, EntryEvent>;
}

/// @nodoc
class _$EntryEventCopyWithImpl<$Res, $Val extends EntryEvent>
    implements $EntryEventCopyWith<$Res> {
  _$EntryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$onPressedAddEntryImplCopyWith<$Res> {
  factory _$$onPressedAddEntryImplCopyWith(_$onPressedAddEntryImpl value,
          $Res Function(_$onPressedAddEntryImpl) then) =
      __$$onPressedAddEntryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({VerticalTab verticalTab, EntryCard entryCard});
}

/// @nodoc
class __$$onPressedAddEntryImplCopyWithImpl<$Res>
    extends _$EntryEventCopyWithImpl<$Res, _$onPressedAddEntryImpl>
    implements _$$onPressedAddEntryImplCopyWith<$Res> {
  __$$onPressedAddEntryImplCopyWithImpl(_$onPressedAddEntryImpl _value,
      $Res Function(_$onPressedAddEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verticalTab = null,
    Object? entryCard = null,
  }) {
    return _then(_$onPressedAddEntryImpl(
      null == verticalTab
          ? _value.verticalTab
          : verticalTab // ignore: cast_nullable_to_non_nullable
              as VerticalTab,
      null == entryCard
          ? _value.entryCard
          : entryCard // ignore: cast_nullable_to_non_nullable
              as EntryCard,
    ));
  }
}

/// @nodoc

class _$onPressedAddEntryImpl implements onPressedAddEntry {
  const _$onPressedAddEntryImpl(this.verticalTab, this.entryCard);

  @override
  final VerticalTab verticalTab;
  @override
  final EntryCard entryCard;

  @override
  String toString() {
    return 'EntryEvent.onPressedAddEntry(verticalTab: $verticalTab, entryCard: $entryCard)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$onPressedAddEntryImpl &&
            (identical(other.verticalTab, verticalTab) ||
                other.verticalTab == verticalTab) &&
            (identical(other.entryCard, entryCard) ||
                other.entryCard == entryCard));
  }

  @override
  int get hashCode => Object.hash(runtimeType, verticalTab, entryCard);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$onPressedAddEntryImplCopyWith<_$onPressedAddEntryImpl> get copyWith =>
      __$$onPressedAddEntryImplCopyWithImpl<_$onPressedAddEntryImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(VerticalTab verticalTab, EntryCard entryCard)
        onPressedAddEntry,
    required TResult Function() onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry(verticalTab, entryCard);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(VerticalTab verticalTab, EntryCard entryCard)?
        onPressedAddEntry,
    TResult? Function()? onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry?.call(verticalTab, entryCard);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(VerticalTab verticalTab, EntryCard entryCard)?
        onPressedAddEntry,
    TResult Function()? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onPressedAddEntry != null) {
      return onPressedAddEntry(verticalTab, entryCard);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(onPressedAddEntry value) onPressedAddEntry,
    required TResult Function(onLongPressedDeleteEntry value)
        onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(onPressedAddEntry value)? onPressedAddEntry,
    TResult? Function(onLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(onPressedAddEntry value)? onPressedAddEntry,
    TResult Function(onLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onPressedAddEntry != null) {
      return onPressedAddEntry(this);
    }
    return orElse();
  }
}

abstract class onPressedAddEntry implements EntryEvent {
  const factory onPressedAddEntry(
          final VerticalTab verticalTab, final EntryCard entryCard) =
      _$onPressedAddEntryImpl;

  VerticalTab get verticalTab;
  EntryCard get entryCard;
  @JsonKey(ignore: true)
  _$$onPressedAddEntryImplCopyWith<_$onPressedAddEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$onLongPressedDeleteEntryImplCopyWith<$Res> {
  factory _$$onLongPressedDeleteEntryImplCopyWith(
          _$onLongPressedDeleteEntryImpl value,
          $Res Function(_$onLongPressedDeleteEntryImpl) then) =
      __$$onLongPressedDeleteEntryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$onLongPressedDeleteEntryImplCopyWithImpl<$Res>
    extends _$EntryEventCopyWithImpl<$Res, _$onLongPressedDeleteEntryImpl>
    implements _$$onLongPressedDeleteEntryImplCopyWith<$Res> {
  __$$onLongPressedDeleteEntryImplCopyWithImpl(
      _$onLongPressedDeleteEntryImpl _value,
      $Res Function(_$onLongPressedDeleteEntryImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$onLongPressedDeleteEntryImpl implements onLongPressedDeleteEntry {
  const _$onLongPressedDeleteEntryImpl();

  @override
  String toString() {
    return 'EntryEvent.onLongPressedDeleteEntry()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$onLongPressedDeleteEntryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(VerticalTab verticalTab, EntryCard entryCard)
        onPressedAddEntry,
    required TResult Function() onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(VerticalTab verticalTab, EntryCard entryCard)?
        onPressedAddEntry,
    TResult? Function()? onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(VerticalTab verticalTab, EntryCard entryCard)?
        onPressedAddEntry,
    TResult Function()? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteEntry != null) {
      return onLongPressedDeleteEntry();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(onPressedAddEntry value) onPressedAddEntry,
    required TResult Function(onLongPressedDeleteEntry value)
        onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(onPressedAddEntry value)? onPressedAddEntry,
    TResult? Function(onLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(onPressedAddEntry value)? onPressedAddEntry,
    TResult Function(onLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteEntry != null) {
      return onLongPressedDeleteEntry(this);
    }
    return orElse();
  }
}

abstract class onLongPressedDeleteEntry implements EntryEvent {
  const factory onLongPressedDeleteEntry() = _$onLongPressedDeleteEntryImpl;
}

/// @nodoc
mixin _$EntryState {
  EntryCard get entryCard => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  bool get isAdded => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EntryStateCopyWith<EntryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryStateCopyWith<$Res> {
  factory $EntryStateCopyWith(
          EntryState value, $Res Function(EntryState) then) =
      _$EntryStateCopyWithImpl<$Res, EntryState>;
  @useResult
  $Res call(
      {EntryCard entryCard,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});
}

/// @nodoc
class _$EntryStateCopyWithImpl<$Res, $Val extends EntryState>
    implements $EntryStateCopyWith<$Res> {
  _$EntryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryCard = null,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      entryCard: null == entryCard
          ? _value.entryCard
          : entryCard // ignore: cast_nullable_to_non_nullable
              as EntryCard,
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
abstract class _$$EntryStateImplCopyWith<$Res>
    implements $EntryStateCopyWith<$Res> {
  factory _$$EntryStateImplCopyWith(
          _$EntryStateImpl value, $Res Function(_$EntryStateImpl) then) =
      __$$EntryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {EntryCard entryCard,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});
}

/// @nodoc
class __$$EntryStateImplCopyWithImpl<$Res>
    extends _$EntryStateCopyWithImpl<$Res, _$EntryStateImpl>
    implements _$$EntryStateImplCopyWith<$Res> {
  __$$EntryStateImplCopyWithImpl(
      _$EntryStateImpl _value, $Res Function(_$EntryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryCard = null,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$EntryStateImpl(
      entryCard: null == entryCard
          ? _value.entryCard
          : entryCard // ignore: cast_nullable_to_non_nullable
              as EntryCard,
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

class _$EntryStateImpl implements _EntryState {
  const _$EntryStateImpl(
      {required this.entryCard,
      required this.isLoading,
      required this.isDeleted,
      required this.isAdded,
      required this.errorMessage});

  @override
  final EntryCard entryCard;
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
    return 'EntryState(entryCard: $entryCard, isLoading: $isLoading, isDeleted: $isDeleted, isAdded: $isAdded, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryStateImpl &&
            (identical(other.entryCard, entryCard) ||
                other.entryCard == entryCard) &&
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
      runtimeType, entryCard, isLoading, isDeleted, isAdded, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryStateImplCopyWith<_$EntryStateImpl> get copyWith =>
      __$$EntryStateImplCopyWithImpl<_$EntryStateImpl>(this, _$identity);
}

abstract class _EntryState implements EntryState {
  const factory _EntryState(
      {required final EntryCard entryCard,
      required final bool isLoading,
      required final bool isDeleted,
      required final bool isAdded,
      required final String? errorMessage}) = _$EntryStateImpl;

  @override
  EntryCard get entryCard;
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
  _$$EntryStateImplCopyWith<_$EntryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
