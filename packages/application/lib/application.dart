library;

// This is the application layer - contains use case implementations and application services
//
// Intended structure:
// - src/use_cases/ - Use case implementations (GetEntriesUseCaseImpl, AddEntryUseCaseImpl)
// - src/services/ - Application services that orchestrate multiple use cases
// - src/dto/ - Application DTOs (if different from domain entities)
// - src/mappers/ - Entity to DTO mappers for this layer

// TODO: Create and export application use cases and services
export 'src/use_cases/export.dart';
// export 'src/services/export.dart';
// export 'src/dto/export.dart';
// export 'src/mappers/export.dart';
