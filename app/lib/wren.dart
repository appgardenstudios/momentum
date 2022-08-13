import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class Wren {
  static Wren? _instance;
  static get instance {
    _instance ??= Wren._();

    return _instance;
  }

  Wren._();

  late Database _database;
  var uuid = const Uuid();

  static Future<void> init({required String path}) async {
    Wren.instance._database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE projects (
            id TEXT PRIMARY KEY,
            name TEXT,
            task_time TEXT,
            created_on TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> createProject(
      {required String name, required String taskTime}) async {
    await Wren.instance._database.insert('projects', {
      'id': Wren.instance.uuid.v4(),
      'name': name,
      'task_time': taskTime,
      'created_on': DateTime.now().toIso8601String(),
    });
  }
}
