# Clean Architecture Implementation Guide

## Overview

This guide will help you refactor your Flutter codebase to implement true clean architecture following the dependency rule and separation of concerns.

## Current State vs Target State

### Current Issues in Your Codebase

1. **Mixed Responsibilities**: Your `HomeBloc` contains business logic that should be in use cases
2. **Wrong Layer Dependencies**: DTOs are mixed with domain entities in the models package
3. **Missing Abstractions**: Direct dependencies on external services like Isar
4. **Inappropriate Data Types**: Using `int` IDs instead of proper domain identifiers

### Target Clean Architecture

```sh
┌─────────────────────────────────────────────────┐
│                  UI Layer                       │
│  (Widgets, BLoCs for UI state only)            │
└─────────────────┬───────────────────────────────┘
                  │ depends on
┌─────────────────▼───────────────────────────────┐
│               Application Layer                  │
│     (Use Case Implementations, App Services)    │
└─────────────────┬───────────────────────────────┘
                  │ depends on
┌─────────────────▼───────────────────────────────┐
│               Domain Layer                       │
│   (Entities, Repository Interfaces, Use Cases)  │
└─────────────────▲───────────────────────────────┘
                  │ implements
┌─────────────────┴───────────────────────────────┐
│                Data Layer                        │
│ (Repository Impl, DTOs, Wrappers, Interceptors) │
└─────────────────────────────────────────────────┘
```

## Package Structure

### Domain Layer (`packages/domain/`)

```sh
lib/
├── src/
│   ├── entities/              # Pure business objects
│   │   ├── entry.dart         # Entry entity (String IDs, business logic)
│   │   ├── tab.dart           # Tab entity
│   │   └── feedback.dart      # Feedback entity
│   ├── repositories/          # Repository interfaces only
│   │   ├── i_entry_repository.dart
│   │   ├── i_tab_repository.dart
│   │   └── i_feedback_repository.dart
│   ├── use_cases/             # Business use case interfaces
│   │   ├── entry/
│   │   │   ├── get_entries_use_case.dart
│   │   │   ├── add_entry_use_case.dart
│   │   │   ├── update_entry_use_case.dart
│   │   │   └── delete_entry_use_case.dart
│   │   └── tab/
│   │       ├── get_tabs_use_case.dart
│   │       └── ...
│   ├── value_objects/         # Domain value objects
│   │   ├── entry_title.dart
│   │   └── entry_subtitle.dart
│   └── services/              # Domain services
│       └── validation_service.dart
└── domain.dart               # Barrel file
```

**Key Rules:**
- ✅ No external dependencies (no HTTP, database, UI frameworks)
- ✅ Only pure Dart and your business logic
- ✅ Use String UUIDs instead of int IDs
- ✅ Contains business rules and validation

### Application Layer (`packages/application/`)

```sh
lib/
├── src/
│   ├── use_cases/            # Use case implementations
│   │   ├── entry/
│   │   │   ├── get_entries_use_case_impl.dart
│   │   │   └── ...
│   │   └── tab/
│   │       └── ...
│   ├── services/             # Application services
│   │   ├── entry_service.dart
│   │   └── tab_service.dart
│   └── dto/                  # Application DTOs (if needed)
│       └── app_dto.dart
└── application.dart          # Barrel file
```

**Key Rules:**
- ✅ Implements domain use cases
- ✅ Orchestrates multiple domain operations
- ✅ No UI or database-specific code
- ✅ Can depend on domain layer only

### Data Layer (`packages/data/`)

```sh
lib/
├── src/
│   ├── repositories/         # Repository implementations
│   │   ├── entry_repository_impl.dart
│   │   ├── tab_repository_impl.dart
│   │   └── feedback_repository_impl.dart
│   ├── datasources/          # Data sources
│   │   ├── local/
│   │   │   ├── entry_local_datasource.dart
│   │   │   └── tab_local_datasource.dart
│   │   └── remote/
│   │       ├── entry_remote_datasource.dart
│   │       └── tab_remote_datasource.dart
│   ├── dto/                  # Data Transfer Objects
│   │   ├── entry_dto.dart    # For database/API
│   │   ├── tab_dto.dart
│   │   └── api_response_dto.dart
│   ├── mappers/              # Entity ↔ DTO conversion
│   │   ├── entry_mapper.dart
│   │   └── tab_mapper.dart
│   ├── wrappers/             # External service wrappers
│   │   ├── database_wrapper.dart     # Abstracts Isar
│   │   ├── http_wrapper.dart         # Abstracts HTTP client
│   │   ├── storage_wrapper.dart      # Abstracts SharedPreferences
│   │   └── cache_wrapper.dart        # Abstracts caching
│   ├── interceptors/         # HTTP interceptors
│   │   ├── auth_interceptor.dart     # Authentication
│   │   ├── logging_interceptor.dart  # Request/response logging
│   │   ├── error_interceptor.dart    # Error handling
│   │   └── retry_interceptor.dart    # Retry logic
│   └── models/               # Database models
│       ├── entry_model.dart  # Isar collection model
│       └── tab_model.dart    # Isar collection model
└── data.dart                 # Barrel file
```

**Key Rules:**
- ✅ Implements domain repository interfaces
- ✅ Handles all external dependencies (databases, APIs, storage)
- ✅ Maps between domain entities and external data formats
- ✅ Contains infrastructure concerns

### UI Layer (`apps/multichoice/`)

```sh
lib/
├── presentation/
│   ├── home/
│   │   ├── home_page.dart
│   │   ├── widgets/
│   │   └── bloc/
│   │       ├── home_bloc.dart        # UI state only
│   │       ├── home_event.dart
│   │       └── home_state.dart
│   ├── details/
│   └── ...
├── shared/
│   ├── widgets/              # Shared UI components
│   └── utils/                # UI utilities
└── main.dart
```

**Key Rules:**
- ✅ BLoCs only manage UI state, not business logic
- ✅ Call application layer use cases
- ✅ No direct repository access
- ✅ Handle user interactions and display data

## Migration Strategy

### Phase 1: Move Business Logic Out of BLoCs

```dart
// ❌ Current: Business logic in BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Future<void> _handleAddEntry(Emitter<HomeState> emit) async {
    // Business validation logic here - WRONG LAYER
    final updatedTitle = Validator.trimWhitespace(entry.title);
    if (updatedTitle.isNotEmpty) {
      await _entryRepository.addEntry(/* ... */);
    }
  }
}

// ✅ Target: BLoC delegates to use case
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AddEntryUseCase _addEntryUseCase;
  
  Future<void> _handleAddEntry(Emitter<HomeState> emit) async {
    try {
      await _addEntryUseCase.execute(AddEntryRequest(
        tabId: state.selectedTabId,
        title: state.entryTitle,
        subtitle: state.entrySubtitle,
      ));
      // Only handle UI state changes
      emit(state.copyWith(isLoading: false, showSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

### Phase 2: Create Proper Domain Entities

```dart
// ❌ Current: Database-influenced entity
class Entry {
  final int id;  // Database auto-increment ID
  final int tabId;  // Foreign key reference
  // Missing business logic
}

// ✅ Target: Pure domain entity
class Entry {
  final String id;  // UUID for domain independence
  final String tabId;  // Reference to tab UUID
  final String title;
  final String subtitle;
  final DateTime createdAt;
  
  // Business logic
  bool get isValid => title.trim().isNotEmpty;
  bool get hasSubtitle => subtitle.trim().isNotEmpty;
}
```

### Phase 3: Abstract External Dependencies

```dart
// ❌ Current: Direct Isar dependency
class EntryRepository implements IEntryRepository {
  final Isar db;  // Direct dependency on external framework
}

// ✅ Target: Abstracted dependency
class EntryRepositoryImpl implements IEntryRepository {
  final DatabaseWrapper _database;  // Abstracted dependency
  final EntryMapper _mapper;
  
  @override
  Future<List<Entry>> getEntriesByTabId(String tabId) async {
    final dtos = await _database.transaction(() async {
      // Database operations
    });
    return dtos.map(_mapper.toDomain).toList();
  }
}
```

## Common Mistakes to Avoid

### 1. ❌ Putting DTOs in Domain Layer

```dart
// Wrong - DTOs belong in data layer
packages/domain/lib/src/dto/entry_dto.dart  // ❌

// Correct - DTOs in data layer
packages/data/lib/src/dto/entry_dto.dart    // ✅
```

### 2. ❌ Business Logic in UI Layer

```dart
// Wrong - validation in widget
class EntryForm extends StatelessWidget {
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => value?.isEmpty == true ? 'Required' : null,  // ❌
    );
  }
}

// Correct - validation in domain
class Entry {
  bool get isValid => title.trim().isNotEmpty;  // ✅
}
```

### 3. ❌ Direct External Dependencies in Domain

```dart
// Wrong - HTTP client in domain
abstract class IEntryRepository {
  Future<List<Entry>> syncWithServer(http.Client client);  // ❌
}

// Correct - pure domain interface
abstract class IEntryRepository {
  Future<List<Entry>> getEntriesByTabId(String tabId);  // ✅
}
```

## Next Steps

1. **Start with Domain Layer**: Create your core entities and repository interfaces
2. **Implement Use Cases**: Move business logic from BLoCs to use case classes
3. **Create Data Layer**: Implement repositories with proper abstractions
4. **Refactor UI Layer**: Simplify BLoCs to only handle UI state
5. **Add Dependency Injection**: Wire everything together with proper IoC

This structure will give you:
- ✅ **Testability**: Each layer can be unit tested independently
- ✅ **Maintainability**: Clear separation of concerns
- ✅ **Flexibility**: Easy to swap out external dependencies
- ✅ **Reusability**: Domain logic can be shared across platforms
- ✅ **Independence**: Business logic doesn't depend on frameworks

Would you like me to help you implement any specific part of this architecture?
