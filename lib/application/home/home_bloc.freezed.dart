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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onGetTabs,
    required TResult Function(String title, String subtitle) onPressedAddTab,
    required TResult Function(int tabId) onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onGetTabs,
    TResult? Function(String title, String subtitle)? onPressedAddTab,
    TResult? Function(int tabId)? onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onGetTabs,
    TResult Function(String title, String subtitle)? onPressedAddTab,
    TResult Function(int tabId)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetTabs value) onGetTabs,
    required TResult Function(OnPressedAddTab value) onPressedAddTab,
    required TResult Function(OnLongPressedDeleteTab value)
        onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetTabs value)? onGetTabs,
    TResult? Function(OnPressedAddTab value)? onPressedAddTab,
    TResult? Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetTabs value)? onGetTabs,
    TResult Function(OnPressedAddTab value)? onPressedAddTab,
    TResult Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
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
abstract class _$$OnGetTabsImplCopyWith<$Res> {
  factory _$$OnGetTabsImplCopyWith(
          _$OnGetTabsImpl value, $Res Function(_$OnGetTabsImpl) then) =
      __$$OnGetTabsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnGetTabsImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$OnGetTabsImpl>
    implements _$$OnGetTabsImplCopyWith<$Res> {
  __$$OnGetTabsImplCopyWithImpl(
      _$OnGetTabsImpl _value, $Res Function(_$OnGetTabsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OnGetTabsImpl implements OnGetTabs {
  const _$OnGetTabsImpl();

  @override
  String toString() {
    return 'HomeEvent.onGetTabs()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnGetTabsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onGetTabs,
    required TResult Function(String title, String subtitle) onPressedAddTab,
    required TResult Function(int tabId) onLongPressedDeleteTab,
  }) {
    return onGetTabs();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onGetTabs,
    TResult? Function(String title, String subtitle)? onPressedAddTab,
    TResult? Function(int tabId)? onLongPressedDeleteTab,
  }) {
    return onGetTabs?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onGetTabs,
    TResult Function(String title, String subtitle)? onPressedAddTab,
    TResult Function(int tabId)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onGetTabs != null) {
      return onGetTabs();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetTabs value) onGetTabs,
    required TResult Function(OnPressedAddTab value) onPressedAddTab,
    required TResult Function(OnLongPressedDeleteTab value)
        onLongPressedDeleteTab,
  }) {
    return onGetTabs(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetTabs value)? onGetTabs,
    TResult? Function(OnPressedAddTab value)? onPressedAddTab,
    TResult? Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
  }) {
    return onGetTabs?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetTabs value)? onGetTabs,
    TResult Function(OnPressedAddTab value)? onPressedAddTab,
    TResult Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onGetTabs != null) {
      return onGetTabs(this);
    }
    return orElse();
  }
}

abstract class OnGetTabs implements HomeEvent {
  const factory OnGetTabs() = _$OnGetTabsImpl;
}

/// @nodoc
abstract class _$$OnPressedAddTabImplCopyWith<$Res> {
  factory _$$OnPressedAddTabImplCopyWith(_$OnPressedAddTabImpl value,
          $Res Function(_$OnPressedAddTabImpl) then) =
      __$$OnPressedAddTabImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String title, String subtitle});
}

/// @nodoc
class __$$OnPressedAddTabImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$OnPressedAddTabImpl>
    implements _$$OnPressedAddTabImplCopyWith<$Res> {
  __$$OnPressedAddTabImplCopyWithImpl(
      _$OnPressedAddTabImpl _value, $Res Function(_$OnPressedAddTabImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subtitle = null,
  }) {
    return _then(_$OnPressedAddTabImpl(
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

class _$OnPressedAddTabImpl implements OnPressedAddTab {
  const _$OnPressedAddTabImpl(this.title, this.subtitle);

  @override
  final String title;
  @override
  final String subtitle;

  @override
  String toString() {
    return 'HomeEvent.onPressedAddTab(title: $title, subtitle: $subtitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnPressedAddTabImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, subtitle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnPressedAddTabImplCopyWith<_$OnPressedAddTabImpl> get copyWith =>
      __$$OnPressedAddTabImplCopyWithImpl<_$OnPressedAddTabImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onGetTabs,
    required TResult Function(String title, String subtitle) onPressedAddTab,
    required TResult Function(int tabId) onLongPressedDeleteTab,
  }) {
    return onPressedAddTab(title, subtitle);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onGetTabs,
    TResult? Function(String title, String subtitle)? onPressedAddTab,
    TResult? Function(int tabId)? onLongPressedDeleteTab,
  }) {
    return onPressedAddTab?.call(title, subtitle);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onGetTabs,
    TResult Function(String title, String subtitle)? onPressedAddTab,
    TResult Function(int tabId)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onPressedAddTab != null) {
      return onPressedAddTab(title, subtitle);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetTabs value) onGetTabs,
    required TResult Function(OnPressedAddTab value) onPressedAddTab,
    required TResult Function(OnLongPressedDeleteTab value)
        onLongPressedDeleteTab,
  }) {
    return onPressedAddTab(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetTabs value)? onGetTabs,
    TResult? Function(OnPressedAddTab value)? onPressedAddTab,
    TResult? Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
  }) {
    return onPressedAddTab?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetTabs value)? onGetTabs,
    TResult Function(OnPressedAddTab value)? onPressedAddTab,
    TResult Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onPressedAddTab != null) {
      return onPressedAddTab(this);
    }
    return orElse();
  }
}

abstract class OnPressedAddTab implements HomeEvent {
  const factory OnPressedAddTab(final String title, final String subtitle) =
      _$OnPressedAddTabImpl;

  String get title;
  String get subtitle;
  @JsonKey(ignore: true)
  _$$OnPressedAddTabImplCopyWith<_$OnPressedAddTabImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnLongPressedDeleteTabImplCopyWith<$Res> {
  factory _$$OnLongPressedDeleteTabImplCopyWith(
          _$OnLongPressedDeleteTabImpl value,
          $Res Function(_$OnLongPressedDeleteTabImpl) then) =
      __$$OnLongPressedDeleteTabImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int tabId});
}

/// @nodoc
class __$$OnLongPressedDeleteTabImplCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$OnLongPressedDeleteTabImpl>
    implements _$$OnLongPressedDeleteTabImplCopyWith<$Res> {
  __$$OnLongPressedDeleteTabImplCopyWithImpl(
      _$OnLongPressedDeleteTabImpl _value,
      $Res Function(_$OnLongPressedDeleteTabImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabId = null,
  }) {
    return _then(_$OnLongPressedDeleteTabImpl(
      null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$OnLongPressedDeleteTabImpl implements OnLongPressedDeleteTab {
  const _$OnLongPressedDeleteTabImpl(this.tabId);

  @override
  final int tabId;

  @override
  String toString() {
    return 'HomeEvent.onLongPressedDeleteTab(tabId: $tabId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnLongPressedDeleteTabImpl &&
            (identical(other.tabId, tabId) || other.tabId == tabId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tabId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnLongPressedDeleteTabImplCopyWith<_$OnLongPressedDeleteTabImpl>
      get copyWith => __$$OnLongPressedDeleteTabImplCopyWithImpl<
          _$OnLongPressedDeleteTabImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onGetTabs,
    required TResult Function(String title, String subtitle) onPressedAddTab,
    required TResult Function(int tabId) onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab(tabId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onGetTabs,
    TResult? Function(String title, String subtitle)? onPressedAddTab,
    TResult? Function(int tabId)? onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab?.call(tabId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onGetTabs,
    TResult Function(String title, String subtitle)? onPressedAddTab,
    TResult Function(int tabId)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteTab != null) {
      return onLongPressedDeleteTab(tabId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnGetTabs value) onGetTabs,
    required TResult Function(OnPressedAddTab value) onPressedAddTab,
    required TResult Function(OnLongPressedDeleteTab value)
        onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnGetTabs value)? onGetTabs,
    TResult? Function(OnPressedAddTab value)? onPressedAddTab,
    TResult? Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
  }) {
    return onLongPressedDeleteTab?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnGetTabs value)? onGetTabs,
    TResult Function(OnPressedAddTab value)? onPressedAddTab,
    TResult Function(OnLongPressedDeleteTab value)? onLongPressedDeleteTab,
    required TResult orElse(),
  }) {
    if (onLongPressedDeleteTab != null) {
      return onLongPressedDeleteTab(this);
    }
    return orElse();
  }
}

abstract class OnLongPressedDeleteTab implements HomeEvent {
  const factory OnLongPressedDeleteTab(final int tabId) =
      _$OnLongPressedDeleteTabImpl;

  int get tabId;
  @JsonKey(ignore: true)
  _$$OnLongPressedDeleteTabImplCopyWith<_$OnLongPressedDeleteTabImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HomeState {
  Tabs get tab => throw _privateConstructorUsedError;
  List<Tabs> get tabs => throw _privateConstructorUsedError;
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
      {Tabs tab,
      List<Tabs> tabs,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});

  $TabsCopyWith<$Res> get tab;
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
    Object? tab = null,
    Object? tabs = null,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      tab: null == tab
          ? _value.tab
          : tab // ignore: cast_nullable_to_non_nullable
              as Tabs,
      tabs: null == tabs
          ? _value.tabs
          : tabs // ignore: cast_nullable_to_non_nullable
              as List<Tabs>,
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
  $TabsCopyWith<$Res> get tab {
    return $TabsCopyWith<$Res>(_value.tab, (value) {
      return _then(_value.copyWith(tab: value) as $Val);
    });
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
      {Tabs tab,
      List<Tabs> tabs,
      bool isLoading,
      bool isDeleted,
      bool isAdded,
      String? errorMessage});

  @override
  $TabsCopyWith<$Res> get tab;
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
    Object? tab = null,
    Object? tabs = null,
    Object? isLoading = null,
    Object? isDeleted = null,
    Object? isAdded = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HomeStateImpl(
      tab: null == tab
          ? _value.tab
          : tab // ignore: cast_nullable_to_non_nullable
              as Tabs,
      tabs: null == tabs
          ? _value._tabs
          : tabs // ignore: cast_nullable_to_non_nullable
              as List<Tabs>,
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
      {required this.tab,
      required final List<Tabs> tabs,
      required this.isLoading,
      required this.isDeleted,
      required this.isAdded,
      required this.errorMessage})
      : _tabs = tabs;

  @override
  final Tabs tab;
  final List<Tabs> _tabs;
  @override
  List<Tabs> get tabs {
    if (_tabs is EqualUnmodifiableListView) return _tabs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tabs);
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
    return 'HomeState(tab: $tab, tabs: $tabs, isLoading: $isLoading, isDeleted: $isDeleted, isAdded: $isAdded, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.tab, tab) || other.tab == tab) &&
            const DeepCollectionEquality().equals(other._tabs, _tabs) &&
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
      tab,
      const DeepCollectionEquality().hash(_tabs),
      isLoading,
      isDeleted,
      isAdded,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {required final Tabs tab,
      required final List<Tabs> tabs,
      required final bool isLoading,
      required final bool isDeleted,
      required final bool isAdded,
      required final String? errorMessage}) = _$HomeStateImpl;

  @override
  Tabs get tab;
  @override
  List<Tabs> get tabs;
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
