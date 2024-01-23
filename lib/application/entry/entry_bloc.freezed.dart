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
  String get tabId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String tabId) onGetEntryCards,
    required TResult Function(String tabId, String title, String subtitle)
        onPressedAddEntry,
    required TResult Function(String tabId, String entryId)
        onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String tabId)? onGetEntryCards,
    TResult? Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult? Function(String tabId, String entryId)? onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String tabId)? onGetEntryCards,
    TResult Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult Function(String tabId, String entryId)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetEntryCards value) onGetEntryCards,
    required TResult Function(OnPressedAddEntry value) onPressedAddEntry,
    required TResult Function(OnLongPressedDeleteEntry value)
        onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetEntryCards value)? onGetEntryCards,
    TResult? Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult? Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetEntryCards value)? onGetEntryCards,
    TResult Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EntryEventCopyWith<EntryEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryEventCopyWith<$Res> {
  factory $EntryEventCopyWith(
          EntryEvent value, $Res Function(EntryEvent) then) =
      _$EntryEventCopyWithImpl<$Res, EntryEvent>;
  @useResult
  $Res call({String tabId});
}

/// @nodoc
class _$EntryEventCopyWithImpl<$Res, $Val extends EntryEvent>
    implements $EntryEventCopyWith<$Res> {
  _$EntryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabId = null,
  }) {
    return _then(_value.copyWith(
      tabId: null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnGetEntryCardsImplCopyWith<$Res>
    implements $EntryEventCopyWith<$Res> {
  factory _$$OnGetEntryCardsImplCopyWith(_$OnGetEntryCardsImpl value,
          $Res Function(_$OnGetEntryCardsImpl) then) =
      __$$OnGetEntryCardsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tabId});
}

/// @nodoc
class __$$OnGetEntryCardsImplCopyWithImpl<$Res>
    extends _$EntryEventCopyWithImpl<$Res, _$OnGetEntryCardsImpl>
    implements _$$OnGetEntryCardsImplCopyWith<$Res> {
  __$$OnGetEntryCardsImplCopyWithImpl(
      _$OnGetEntryCardsImpl _value, $Res Function(_$OnGetEntryCardsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabId = null,
  }) {
    return _then(_$OnGetEntryCardsImpl(
      null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OnGetEntryCardsImpl implements OnGetEntryCards {
  const _$OnGetEntryCardsImpl(this.tabId);

  @override
  final String tabId;

  @override
  String toString() {
    return 'EntryEvent.onGetEntryCards(tabId: $tabId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnGetEntryCardsImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnGetEntryCardsImplCopyWith<_$OnGetEntryCardsImpl> get copyWith =>
      __$$OnGetEntryCardsImplCopyWithImpl<_$OnGetEntryCardsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String tabId) onGetEntryCards,
    required TResult Function(String tabId, String title, String subtitle)
        onPressedAddEntry,
    required TResult Function(String tabId, String entryId)
        onLongPressedDeleteEntry,
  }) {
    return onGetEntryCards(tabId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String tabId)? onGetEntryCards,
    TResult? Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult? Function(String tabId, String entryId)? onLongPressedDeleteEntry,
  }) {
    return onGetEntryCards?.call(tabId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String tabId)? onGetEntryCards,
    TResult Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult Function(String tabId, String entryId)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onGetEntryCards != null) {
      return onGetEntryCards(tabId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetEntryCards value) onGetEntryCards,
    required TResult Function(OnPressedAddEntry value) onPressedAddEntry,
    required TResult Function(OnLongPressedDeleteEntry value)
        onLongPressedDeleteEntry,
  }) {
    return onGetEntryCards(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetEntryCards value)? onGetEntryCards,
    TResult? Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult? Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
  }) {
    return onGetEntryCards?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetEntryCards value)? onGetEntryCards,
    TResult Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onGetEntryCards != null) {
      return onGetEntryCards(this);
    }
    return orElse();
  }
}

abstract class OnGetEntryCards implements EntryEvent {
  const factory OnGetEntryCards(final String tabId) = _$OnGetEntryCardsImpl;

  @override
  String get tabId;
  @override
  @JsonKey(ignore: true)
  _$$OnGetEntryCardsImplCopyWith<_$OnGetEntryCardsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnPressedAddEntryImplCopyWith<$Res>
    implements $EntryEventCopyWith<$Res> {
  factory _$$OnPressedAddEntryImplCopyWith(_$OnPressedAddEntryImpl value,
          $Res Function(_$OnPressedAddEntryImpl) then) =
      __$$OnPressedAddEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tabId, String title, String subtitle});
}

/// @nodoc
class __$$OnPressedAddEntryImplCopyWithImpl<$Res>
    extends _$EntryEventCopyWithImpl<$Res, _$OnPressedAddEntryImpl>
    implements _$$OnPressedAddEntryImplCopyWith<$Res> {
  __$$OnPressedAddEntryImplCopyWithImpl(_$OnPressedAddEntryImpl _value,
      $Res Function(_$OnPressedAddEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabId = null,
    Object? title = null,
    Object? subtitle = null,
  }) {
    return _then(_$OnPressedAddEntryImpl(
      null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as String,
      null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OnPressedAddEntryImpl implements OnPressedAddEntry {
  const _$OnPressedAddEntryImpl(this.tabId, this.title, this.subtitle);

  @override
  final String tabId;
  @override
  final String title;
  @override
  final String subtitle;

  @override
  String toString() {
    return 'EntryEvent.onPressedAddEntry(tabId: $tabId, title: $title, subtitle: $subtitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnPressedAddEntryImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId, title, subtitle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnPressedAddEntryImplCopyWith<_$OnPressedAddEntryImpl> get copyWith =>
      __$$OnPressedAddEntryImplCopyWithImpl<_$OnPressedAddEntryImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String tabId) onGetEntryCards,
    required TResult Function(String tabId, String title, String subtitle)
        onPressedAddEntry,
    required TResult Function(String tabId, String entryId)
        onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry(tabId, title, subtitle);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String tabId)? onGetEntryCards,
    TResult? Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult? Function(String tabId, String entryId)? onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry?.call(tabId, title, subtitle);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String tabId)? onGetEntryCards,
    TResult Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult Function(String tabId, String entryId)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onPressedAddEntry != null) {
      return onPressedAddEntry(tabId, title, subtitle);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetEntryCards value) onGetEntryCards,
    required TResult Function(OnPressedAddEntry value) onPressedAddEntry,
    required TResult Function(OnLongPressedDeleteEntry value)
        onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetEntryCards value)? onGetEntryCards,
    TResult? Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult? Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
  }) {
    return onPressedAddEntry?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetEntryCards value)? onGetEntryCards,
    TResult Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onPressedAddEntry != null) {
      return onPressedAddEntry(this);
    }
    return orElse();
  }
}

abstract class OnPressedAddEntry implements EntryEvent {
  const factory OnPressedAddEntry(
          final String tabId, final String title, final String subtitle) =
      _$OnPressedAddEntryImpl;

  @override
  String get tabId;
  String get title;
  String get subtitle;
  @override
  @JsonKey(ignore: true)
  _$$OnPressedAddEntryImplCopyWith<_$OnPressedAddEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnLongPressedDeleteEntryImplCopyWith<$Res>
    implements $EntryEventCopyWith<$Res> {
  factory _$$OnLongPressedDeleteEntryImplCopyWith(
          _$OnLongPressedDeleteEntryImpl value,
          $Res Function(_$OnLongPressedDeleteEntryImpl) then) =
      __$$OnLongPressedDeleteEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tabId, String entryId});
}

/// @nodoc
class __$$OnLongPressedDeleteEntryImplCopyWithImpl<$Res>
    extends _$EntryEventCopyWithImpl<$Res, _$OnLongPressedDeleteEntryImpl>
    implements _$$OnLongPressedDeleteEntryImplCopyWith<$Res> {
  __$$OnLongPressedDeleteEntryImplCopyWithImpl(
      _$OnLongPressedDeleteEntryImpl _value,
      $Res Function(_$OnLongPressedDeleteEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabId = null,
    Object? entryId = null,
  }) {
    return _then(_$OnLongPressedDeleteEntryImpl(
      null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as String,
      null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OnLongPressedDeleteEntryImpl implements OnLongPressedDeleteEntry {
  const _$OnLongPressedDeleteEntryImpl(this.tabId, this.entryId);

  @override
  final String tabId;
  @override
  final String entryId;

  @override
  String toString() {
    return 'EntryEvent.onLongPressedDeleteEntry(tabId: $tabId, entryId: $entryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnLongPressedDeleteEntryImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId) &&
            (identical(other.entryId, entryId) || other.entryId == entryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId, entryId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnLongPressedDeleteEntryImplCopyWith<_$OnLongPressedDeleteEntryImpl>
      get copyWith => __$$OnLongPressedDeleteEntryImplCopyWithImpl<
          _$OnLongPressedDeleteEntryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String tabId) onGetEntryCards,
    required TResult Function(String tabId, String title, String subtitle)
        onPressedAddEntry,
    required TResult Function(String tabId, String entryId)
        onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry(tabId, entryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String tabId)? onGetEntryCards,
    TResult? Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult? Function(String tabId, String entryId)? onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry?.call(tabId, entryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String tabId)? onGetEntryCards,
    TResult Function(String tabId, String title, String subtitle)?
        onPressedAddEntry,
    TResult Function(String tabId, String entryId)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteEntry != null) {
      return onLongPressedDeleteEntry(tabId, entryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetEntryCards value) onGetEntryCards,
    required TResult Function(OnPressedAddEntry value) onPressedAddEntry,
    required TResult Function(OnLongPressedDeleteEntry value)
        onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetEntryCards value)? onGetEntryCards,
    TResult? Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult? Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
  }) {
    return onLongPressedDeleteEntry?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetEntryCards value)? onGetEntryCards,
    TResult Function(OnPressedAddEntry value)? onPressedAddEntry,
    TResult Function(OnLongPressedDeleteEntry value)? onLongPressedDeleteEntry,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteEntry != null) {
      return onLongPressedDeleteEntry(this);
    }
    return orElse();
  }
}

abstract class OnLongPressedDeleteEntry implements EntryEvent {
  const factory OnLongPressedDeleteEntry(
          final String tabId, final String entryId) =
      _$OnLongPressedDeleteEntryImpl;

  @override
  String get tabId;
  String get entryId;
  @override
  @JsonKey(ignore: true)
  _$$OnLongPressedDeleteEntryImplCopyWith<_$OnLongPressedDeleteEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EntryState {
  Entry get entry => throw _privateConstructorUsedError;
  List<Entry>? get entryCards => throw _privateConstructorUsedError;
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
      {Entry entry,
      List<Entry>? entryCards,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});

  $EntryCopyWith<$Res> get entry;
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
    Object? entry = null,
    Object? entryCards = freezed,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      entry: null == entry
          ? _value.entry
          : entry // ignore: cast_nullable_to_non_nullable
              as Entry,
      entryCards: freezed == entryCards
          ? _value.entryCards
          : entryCards // ignore: cast_nullable_to_non_nullable
              as List<Entry>?,
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

  @override
  @pragma('vm:prefer-inline')
  $EntryCopyWith<$Res> get entry {
    return $EntryCopyWith<$Res>(_value.entry, (value) {
      return _then(_value.copyWith(entry: value) as $Val);
    });
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
      {Entry entry,
      List<Entry>? entryCards,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});

  @override
  $EntryCopyWith<$Res> get entry;
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
    Object? entry = null,
    Object? entryCards = freezed,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$EntryStateImpl(
      entry: null == entry
          ? _value.entry
          : entry // ignore: cast_nullable_to_non_nullable
              as Entry,
      entryCards: freezed == entryCards
          ? _value._entryCards
          : entryCards // ignore: cast_nullable_to_non_nullable
              as List<Entry>?,
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
      {required this.entry,
      required final List<Entry>? entryCards,
      required this.isLoading,
      required this.isDeleted,
      required this.isAdded,
      required this.errorMessage})
      : _entryCards = entryCards;

  @override
  final Entry entry;
  final List<Entry>? _entryCards;
  @override
  List<Entry>? get entryCards {
    final value = _entryCards;
    if (value == null) return null;
    if (_entryCards is EqualUnmodifiableListView) return _entryCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'EntryState(entry: $entry, entryCards: $entryCards, isLoading: $isLoading, isDeleted: $isDeleted, isAdded: $isAdded, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryStateImpl &&
            (identical(other.entry, entry) || other.entry == entry) &&
            const DeepCollectionEquality()
                .equals(other._entryCards, _entryCards) &&
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
      runtimeType,
      entry,
      const DeepCollectionEquality().hash(_entryCards),
      isLoading,
      isDeleted,
      isAdded,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryStateImplCopyWith<_$EntryStateImpl> get copyWith =>
      __$$EntryStateImplCopyWithImpl<_$EntryStateImpl>(this, _$identity);
}

abstract class _EntryState implements EntryState {
  const factory _EntryState(
      {required final Entry entry,
      required final List<Entry>? entryCards,
      required final bool isLoading,
      required final bool isDeleted,
      required final bool isAdded,
      required final String? errorMessage}) = _$EntryStateImpl;

  @override
  Entry get entry;
  @override
  List<Entry>? get entryCards;
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
