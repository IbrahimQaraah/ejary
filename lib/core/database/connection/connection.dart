import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

LazyDatabase openConnection({bool inMemory = false, String? dbPath}) {
  return LazyDatabase(() async {
    if (inMemory) {
      return NativeDatabase.memory();
    }
    final path =
        dbPath ?? p.join(Directory.current.path, 'property_manager.sqlite');
    final file = File(path);
    return NativeDatabase.createInBackground(file);
  });
}
