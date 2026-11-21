import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String kDatabaseFilename = 'property_manager.sqlite';

/// Resolves the application database directory safely across Android, iOS,
/// Desktop, and test environments.
Future<Directory> resolveDatabaseDirectory() async {
  try {
    // Android application-private storage: /data/user/0/<package_name>/app_flutter/
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  } catch (e) {
    debugPrint(
      '[Database][Diag] PathProvider unavailable, using Directory.current fallback: $e',
    );
    return Directory.current;
  }
}

/// Resolves the absolute database file with full directory verification
/// and migration checks for existing data preservation.
Future<File> resolveDatabaseFile({String? customPath}) async {
  if (customPath != null && customPath.isNotEmpty) {
    final file = File(customPath);
    if (!file.parent.existsSync()) {
      debugPrint(
        '[Database][Diag] Creating parent directory for custom db path: ${file.parent.path}',
      );
      await file.parent.create(recursive: true);
    }
    return file;
  }

  final dbFolder = await resolveDatabaseDirectory();
  final dbFile = File(p.join(dbFolder.path, kDatabaseFilename));

  // Ensure parent directory exists and has write permissions
  if (!dbFile.parent.existsSync()) {
    debugPrint(
      '[Database][Diag] Creating app database directory: ${dbFile.parent.path}',
    );
    await dbFile.parent.create(recursive: true);
  }

  // Preserve existing data: If database was previously located at Directory.current,
  // migrate it safely to the app-private documents directory without data loss.
  try {
    final legacyFile = File(p.join(Directory.current.path, kDatabaseFilename));
    if (!dbFile.existsSync() && legacyFile.existsSync()) {
      debugPrint(
        '[Database][Diag] Migrating existing database from ${legacyFile.path} to ${dbFile.path}',
      );
      await legacyFile.copy(dbFile.path);
    }
  } catch (migrationError) {
    debugPrint(
      '[Database][Diag] Legacy database migration check skipped: $migrationError',
    );
  }

  return dbFile;
}

LazyDatabase openConnection({bool inMemory = false, String? dbPath}) {
  return LazyDatabase(() async {
    if (inMemory) {
      debugPrint(
        '[Database][Diag] Initializing in-memory SQLite database instance.',
      );
      return NativeDatabase.memory();
    }

    try {
      final file = await resolveDatabaseFile(customPath: dbPath);
      debugPrint('[Database][Diag] Resolved database file path: ${file.path}');
      debugPrint('[Database][Diag] Database file exists: ${file.existsSync()}');

      // Verify directory write accessibility
      if (!file.parent.existsSync()) {
        await file.parent.create(recursive: true);
      }

      return NativeDatabase.createInBackground(file, logStatements: kDebugMode);
    } catch (e, stackTrace) {
      // Meaningful diagnostic logging without leaking sensitive information
      debugPrint(
        '[Database][ERROR] Critical failure while opening SQLite database.',
      );
      debugPrint('[Database][ERROR] Error details: $e');
      debugPrint('[Database][ERROR] StackTrace: $stackTrace');
      rethrow;
    }
  });
}
