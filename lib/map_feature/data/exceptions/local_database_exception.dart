import 'package:sqflite/sqflite.dart';

class LocalDatabaseException implements DatabaseException {
  final String message;

  LocalDatabaseException(this.message);

  @override
  String toString() {
    return 'StoreDatabaseException: $message';
  }

  @override
  int? getResultCode() {
    // TODO: implement getResultCode
    throw UnimplementedError();
  }

  @override
  bool isDatabaseClosedError() {
    // TODO: implement isDatabaseClosedError
    throw UnimplementedError();
  }

  @override
  bool isDuplicateColumnError([String? column]) {
    // TODO: implement isDuplicateColumnError
    throw UnimplementedError();
  }

  @override
  bool isNoSuchTableError([String? table]) {
    // TODO: implement isNoSuchTableError
    throw UnimplementedError();
  }

  @override
  bool isNotNullConstraintError([String? field]) {
    // TODO: implement isNotNullConstraintError
    throw UnimplementedError();
  }

  @override
  bool isOpenFailedError() {
    // TODO: implement isOpenFailedError
    throw UnimplementedError();
  }

  @override
  bool isReadOnlyError() {
    // TODO: implement isReadOnlyError
    throw UnimplementedError();
  }

  @override
  bool isSyntaxError() {
    // TODO: implement isSyntaxError
    throw UnimplementedError();
  }

  @override
  bool isUniqueConstraintError([String? field]) {
    // TODO: implement isUniqueConstraintError
    throw UnimplementedError();
  }

  @override
  // TODO: implement result
  Object? get result => throw UnimplementedError();
}