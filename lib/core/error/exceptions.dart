class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

class BusinessRuleException implements Exception {
  final String message;
  const BusinessRuleException(this.message);

  @override
  String toString() => 'BusinessRuleException: $message';
}
