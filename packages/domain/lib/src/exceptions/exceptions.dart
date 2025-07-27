// Base exception class
abstract class DomainException implements Exception {
  const DomainException(this.message);
  final String message;

  @override
  String toString() => 'DomainException: $message';
}

// Business Logic Exceptions
class ValidationException extends DomainException {
  const ValidationException(super.message);
}

class BusinessRuleException extends DomainException {
  const BusinessRuleException(super.message);
}

// Data Layer Exceptions
class DataException extends DomainException {
  const DataException(super.message);
}

class DatabaseException extends DataException {
  const DatabaseException(super.message);
}

class NetworkException extends DataException {
  const NetworkException(super.message);
}

// Specific Exceptions
class CollectionNotFoundException extends DataException {
  const CollectionNotFoundException(super.message);
}

class ItemNotFoundException extends DataException {
  const ItemNotFoundException(super.message);
}

class UnknownDatabaseException extends DatabaseException {
  const UnknownDatabaseException(super.message);
}

class RepositoryException extends DataException {
  const RepositoryException(super.message);
}
