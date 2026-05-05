library;

// This is the data layer - contains repository implementations, data sources, DTOs, and external adapters
//
// Intended structure:
// - src/repositories/ - Repository implementations (EntryRepositoryImpl, TabRepositoryImpl)
// - src/datasources/ - Data sources (LocalDataSource, RemoteDataSource)
// - src/dto/ - Data Transfer Objects for external APIs/databases
// - src/mappers/ - DTO to Entity mappers
// - src/wrappers/ - External service wrappers (HttpWrapper, DatabaseWrapper, StorageWrapper)
// - src/interceptors/ - HTTP interceptors (AuthInterceptor, LoggingInterceptor)
// - src/models/ - Database/API models (separate from domain entities)

// TODO: Create and export data layer components
// export 'src/repositories/export.dart';
export 'src/datasources/local/export.dart';
// export 'src/dto/export.dart';
// export 'src/mappers/export.dart';
export 'src/wrappers/export.dart';
// export 'src/interceptors/export.dart';
export 'src/models/export.dart';
