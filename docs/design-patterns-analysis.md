# Design Patterns in Multichoice Flutter App

This document provides a comprehensive analysis of the design patterns implemented in the Multichoice Flutter application codebase. The application demonstrates excellent architectural principles with clear separation of concerns and proper implementation of various design patterns.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Creational Patterns](#creational-patterns)
3. [Structural Patterns](#structural-patterns)
4. [Behavioral Patterns](#behavioral-patterns)
5. [Architectural Patterns](#architectural-patterns)
6. [Flutter-Specific Patterns](#flutter-specific-patterns)
7. [Summary](#summary)

## Architecture Overview

The codebase follows a **Clean Architecture** pattern with modular package structure:

```
packages/
├── core/           # Business logic and use cases
├── models/         # Data models and DTOs
├── theme/          # UI theming
└── ui_kit/         # Reusable UI components
```

This structure promotes separation of concerns, testability, and maintainability.

## Creational Patterns

### 1. Factory Pattern

The codebase extensively uses factory constructors for object creation, particularly in DTOs and UI components.

#### DTO Factory Constructors

```dart
// packages/models/lib/src/dto/tabs/tabs_dto.dart
factory TabsDTO.empty() => TabsDTO(
  id: 0,
  title: '',
  subtitle: '',
  timestamp: DateTime.now(),
  entries: [],
);

// packages/models/lib/src/dto/entry/entry_dto.dart
factory EntryDTO.empty() => EntryDTO(
  id: 0,
  tabId: 0,
  title: '',
  subtitle: '',
  timestamp: DateTime.now(),
);
```

#### UI Component Factories

```dart
// packages/ui_kit/lib/src/widgets/loaders/circular_loader.dart
/// Creates a small loader (32x32 with 4px stroke)
factory CircularLoader.small({
  Key? key,
  double? value,
  Color? backgroundColor,
  Color? color,
  // ... other parameters
}) {
  return CircularLoader._(
    key: key,
    size: 32.0,
    strokeWidth: 4.0,
    // ... other properties
  );
}

factory CircularLoader.medium({ /* ... */ })
factory CircularLoader.large({ /* ... */ })
factory CircularLoader.custom({ /* ... */ })
```

### 2. Singleton Pattern

The application uses singletons for shared resources and services.

#### Service Locator Singleton

```dart
// packages/core/lib/src/get_it_injection.dart
final coreSl = GetIt.instance;
```

#### Controller Singleton

```dart
// packages/core/lib/src/controllers/implementations/product_tour_controller.dart
@Singleton(as: IProductTourController)
class ProductTourController implements IProductTourController {
  // Implementation
}
```

### 3. Builder Pattern

Used for creating complex objects and widgets.

#### Dialog Builder

```dart
// packages/ui_kit/lib/src/custom_dialog.dart
class CustomDialog<T> {
  CustomDialog.show({
    required this.context,
    this.title,
    this.actions,
    this.content,
  }) {
    showDialog<T>(
      context: context,
      builder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}
```

#### Widget Test Builder

```dart
// apps/multichoice/test/helpers/widget_wrapper.dart
Widget widgetWrapper({required Widget child}) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}
```

## Structural Patterns

### 1. Repository Pattern

The repository pattern abstracts data access logic and provides a clean interface for data operations.

#### Repository Interface

```dart
// packages/core/lib/src/repositories/interfaces/tabs/i_tabs_repository.dart
abstract class ITabsRepository {
  Future<int> addTab({
    required String? title,
    required String? subtitle,
  });

  Future<TabsDTO> getTab({required int tabId});
  Future<List<TabsDTO>> readTabs();
  Future<int> updateTab({
    required int id,
    required String title,
    required String subtitle,
  });
  Future<bool> deleteTab({required int? tabId});
  Future<bool> deleteTabs();
}
```

#### Repository Implementation

```dart
// packages/core/lib/src/repositories/implementation/tabs/tabs_repository.dart
@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository(this.db);

  final isar.Isar db;

  @override
  Future<int> addTab({
    required String? title,
    required String? subtitle,
  }) async {
    try {
      return await db.writeTxn(() async {
        final result = db.tabs.put(
          Tabs(
            uuid: const Uuid().v4(),
            title: title ?? '',
            subtitle: subtitle,
            timestamp: clock.now(),
            entryIds: [],
          ),
        );
        return result;
      });
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }
  // ... other implementations
}
```

### 2. Adapter Pattern (Mapper Pattern)

The mapper pattern adapts data between different layers (database models to DTOs).

```dart
// packages/models/lib/src/mappers/tabs/tabs_dto_mapper.dart
@AutoMappr([
  MapType<Tabs, TabsDTO>(
    fields: [
      Field('id', custom: TabsMapper.mapUuid),
      Field('title'),
      Field('subtitle', custom: TabsMapper.mapSubtitle),
      Field('timestamp', custom: TabsMapper.mapTimestamp),
      Field('entries', custom: TabsMapper.mapEntryIds),
    ],
  ),
])
class TabsMapper extends $TabsMapper {
  static int mapUuid(Tabs content) => content.id;
  static String mapSubtitle(Tabs content) => content.subtitle ?? '';
  static DateTime mapTimestamp(Tabs content) => content.timestamp ?? DateTime.now();
  static List<EntryDTO> mapEntryIds(Tabs content) {
    return (content.entryIds ?? [])
        .map((id) => EntryDTO.empty().copyWith(id: id))
        .toList();
  }
}
```

### 3. Decorator Pattern

The decorator pattern is used to extend widget functionality without modifying the original widget.

#### Tour Widget Wrapper

```dart
// apps/multichoice/lib/utils/product_tour/tour_widget_wrapper.dart
class TourWidgetWrapper extends StatelessWidget {
  const TourWidgetWrapper({
    required this.step,
    required this.child,
    this.tabId,
    super.key,
  });

  final Widget child;
  final ProductTourStep step;
  final int? tabId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.currentStep != step) {
          return child;  // Return original widget
        }

        final key = getProductTourKey(step, tabId: tabId);
        final showcaseData = _getProductTourData(step);

        if (key != null && context.mounted) {
          return Showcase(  // Decorated widget
            key: key,
            title: showcaseData.title,
            description: showcaseData.description,
            // ... other showcase properties
            child: child,
          );
        }

        return child;
      },
    );
  }
}
```

#### Custom Scroll Behavior

```dart
// packages/ui_kit/lib/src/custom_scroll_behaviour.dart
class CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
```

### 4. Facade Pattern

The service layer acts as a facade to simplify complex subsystem interactions.

```dart
// packages/core/lib/src/services/implementations/app_storage_service.dart
@LazySingleton(as: IAppStorageService)
class AppStorageService implements IAppStorageService {
  final _sharedPreferences = coreSl<SharedPreferences>();

  @override
  Future<bool> get isDarkMode async {
    final isDarkMode = _sharedPreferences.getBool(StorageKeys.isDarkMode.key);
    return isDarkMode ?? false;
  }

  @override
  Future<void> setIsDarkMode(bool isDarkMode) async {
    await _sharedPreferences.setBool(
      StorageKeys.isDarkMode.key,
      isDarkMode,
    );
  }
  // ... other storage operations
}
```

## Behavioral Patterns

### 1. Observer Pattern

Implemented through the BLoC pattern and Flutter's reactive framework.

#### BLoC Observer

```dart
// apps/multichoice/lib/bootstrap.dart
class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType} $event');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    log('$transition');
  }
}
```

### 2. Command Pattern

Events in the BLoC pattern represent commands that encapsulate requests.

```dart
// packages/core/lib/src/application/home/home_event.dart
@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onGetTabs() = OnGetTabs;
  const factory HomeEvent.onGetTab(int tabId) = OnGetTab;
  const factory HomeEvent.onPressedAddTab() = OnPressedAddTab;
  const factory HomeEvent.onPressedAddEntry() = OnPressedAddEntry;
  const factory HomeEvent.onLongPressedDeleteTab(int tabId) = OnLongPressedDeleteTab;
  const factory HomeEvent.onLongPressedDeleteEntry(int tabId, int entryId) = OnLongPressedDeleteEntry;
  // ... other commands
}
```

### 3. State Pattern

The BLoC pattern implements state management with clear state transitions.

```dart
// packages/core/lib/src/application/home/home_state.dart
@freezed
class HomeState with _$HomeState {
  factory HomeState({
    required List<TabsDTO>? tabs,
    required bool isLoading,
    required bool isAddingTab,
    required bool isAddingEntry,
    required bool isEditingTab,
    required bool isEditingEntry,
    String? errorMessage,
    // ... other state properties
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
    tabs: null,
    isLoading: true,
    isAddingTab: false,
    isAddingEntry: false,
    isEditingTab: false,
    isEditingEntry: false,
  );
}
```

### 4. Strategy Pattern

Different strategies for error handling and data processing.

#### Error Handling Strategy

```dart
// packages/core/lib/src/repositories/implementation/feedback/feedback_repository.dart
@override
Future<Either<FeedbackException, void>> submitFeedback(FeedbackDTO feedback) async {
  try {
    final model = _mapper.convert<FeedbackDTO, FeedbackModel>(feedback);
    await _firestore.collection(_collection).add(model.toFirestore());
    return const Right(null);  // Success strategy
  } catch (e) {
    return Left(FeedbackException('Failed to submit feedback: $e'));  // Error strategy
  }
}
```

### 5. Template Method Pattern

Base classes define the structure while subclasses implement specific behavior.

```dart
// apps/multichoice/lib/presentation/shared/widgets/add_widgets/_base.dart
class _BaseCard extends StatelessWidget {
  const _BaseCard({
    required this.semanticLabel,
    this.elevation,
    this.color,
    this.shape,
    this.child,
    this.icon,
    this.padding,
    this.margin,
    this.iconSize,
    this.onPressed,
  }) : assert(
          (child != null) || (icon != null),
          'Either child or icon must be non-null',
        );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Card(
        elevation: elevation,
        margin: margin,
        color: color,
        shape: shape,
        child: child ??
            Padding(
              padding: padding ?? allPadding6,
              child: IconButton(
                icon: icon ?? const Icon(Icons.not_interested_rounded),
                iconSize: iconSize ?? 10,
                onPressed: onPressed,
              ),
            ),
      ),
    );
  }
}
```

## Architectural Patterns

### 1. Dependency Injection Pattern

The application uses GetIt with Injectable for comprehensive dependency management.

#### Module Configuration

```dart
// packages/core/lib/src/injectable_module.dart
@module
abstract class InjectableModule {
  @preResolve
  Future<Isar> get isar async {
    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [TabsSchema, EntrySchema],
      directory: directory.path,
      name: 'MultichoiceDB',
    );
    return isar;
  }

  @preResolve
  Future<SharedPreferences> get sharedPref async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref;
  }

  @lazySingleton
  FilePicker get filePicker => FilePicker.platform;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
```

#### Dependency Registration

```dart
// packages/core/lib/src/get_it_injection.dart
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureCoreDependencies() async {
  return coreSl.init();
}
```

### 2. Clean Architecture Pattern

Clear separation between layers with dependency inversion.

```
├── Application Layer (BLoCs, Use Cases)
├── Domain Layer (Entities, Repositories)
├── Infrastructure Layer (Database, External APIs)
└── Presentation Layer (UI, Widgets)
```

### 3. MVVM Pattern (with BLoC)

Model-View-ViewModel pattern implemented through BLoC.

```dart
// packages/core/lib/src/application/home/home_bloc.dart
@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._tabsRepository,
    this._entryRepository,
  ) : super(HomeState.initial()) {
    on<HomeEvent>(_onEvent);
  }

  Future<void> _onEvent(HomeEvent event, Emitter<HomeState> emit) async {
    switch (event) {
      case OnGetTabs():
        await _handleGetTabs(emit);
      case OnGetTab(:final tabId):
        await _handleGetTab(tabId, emit);
      // ... handle other events
    }
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}
```

## Flutter-Specific Patterns

### 1. BLoC Pattern

Business Logic Component pattern for state management.

```dart
// Usage in UI
BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    if (state.isLoading) {
      return const CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: state.tabs?.length ?? 0,
      itemBuilder: (context, index) {
        final tab = state.tabs![index];
        return ListTile(
          title: Text(tab.title),
          subtitle: Text(tab.subtitle),
        );
      },
    );
  },
)
```

### 2. Provider Pattern

Used for dependency injection in widget tree.

```dart
// apps/multichoice/lib/presentation/home/home_page.dart
return MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => AppLayout(),
    ),
    BlocProvider(
      create: (_) => coreSl<HomeBloc>()
        ..add(const HomeEvent.onGetTabs()),
    ),
    BlocProvider(
      create: (_) => coreSl<SearchBloc>(),
    ),
  ],
  child: const HomePage(),
);
```

### 3. Widget Composition Pattern

Building complex UIs through widget composition.

```dart
// apps/multichoice/lib/presentation/shared/widgets/add_widgets/tab.dart
class AddTabCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BaseCard(  // Composition with base card
      semanticLabel: semanticLabel ?? 'AddTab',
      elevation: 5,
      color: color ?? context.theme.appColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular12,
      ),
      child: Padding(
        padding: allPadding6,
        child: SizedBox(
          key: context.keys.addTabSizedBox,
          width: width,
          child: IconButton(
            iconSize: 36,
            onPressed: onPressed,
            icon: const Icon(Icons.add_outlined),
          ),
        ),
      ),
    );
  }
}
```

## Summary

The Multichoice Flutter application demonstrates excellent implementation of design patterns:

### **Creational Patterns:**

- **Factory Pattern**: Extensive use in DTOs and UI components for object creation
- **Singleton Pattern**: Service locator and shared controllers
- **Builder Pattern**: Complex widget and dialog construction

### **Structural Patterns:**

- **Repository Pattern**: Clean data access abstraction
- **Adapter/Mapper Pattern**: Data transformation between layers
- **Decorator Pattern**: Widget functionality extension
- **Facade Pattern**: Simplified service interfaces

### **Behavioral Patterns:**

- **Observer Pattern**: BLoC-based reactive state management
- **Command Pattern**: Event encapsulation in BLoCs
- **State Pattern**: Clear state management and transitions
- **Strategy Pattern**: Flexible algorithm selection
- **Template Method Pattern**: Shared behavior with customization

### **Architectural Patterns:**

- **Clean Architecture**: Clear separation of concerns
- **Dependency Injection**: Loose coupling and testability
- **MVVM with BLoC**: Separation of UI and business logic

### **Flutter-Specific Patterns:**

- **BLoC Pattern**: Reactive state management
- **Provider Pattern**: Dependency injection in widget tree
- **Widget Composition**: Flexible UI construction

This architecture promotes:
- **Maintainability**: Clear structure and separation of concerns
- **Testability**: Dependency injection and interface-based design
- **Scalability**: Modular architecture and loose coupling
- **Reusability**: Shared components and services
- **Code Quality**: Consistent patterns and best practices

The codebase serves as an excellent example of how to structure a Flutter application using proven design patterns and architectural principles.
