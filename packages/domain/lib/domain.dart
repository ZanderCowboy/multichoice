library;

// This is the domain layer - contains business entities, repository interfaces, and use cases
//
// Intended structure:
// - src/entities/ - Pure business objects (Entry, Tab, etc.)
// - src/repositories/ - Repository interfaces (IEntryRepository, ITabRepository)
// - src/use_cases/ - Business use cases (GetEntriesUseCase, AddEntryUseCase)
// - src/value_objects/ - Value objects for validation (EntryTitle, EntrySubtitle)
// - src/services/ - Domain services (ValidationService)

// TODO: Create and export domain entities, repositories, and use cases
export 'src/entities/export.dart';
export 'src/repositories/export.dart';
export 'src/use_cases/export.dart';
export 'src/exceptions/exceptions.dart';
// export 'src/value_objects/export.dart';
// export 'src/services/export.dart';
