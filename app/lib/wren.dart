import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:momentum/data/project.dart';
import 'package:momentum/data/task.dart';

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
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE projects (
            id TEXT PRIMARY KEY,
            name TEXT,
            task_time TEXT,
            created_on TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            status TEXT,
            created_on TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<String> createProject(
      {required String name, required String taskTime}) async {
    var id = Wren.instance.uuid.v4();
    await Wren.instance._database.insert('projects', {
      'id': id,
      'name': name,
      'task_time': taskTime,
      'created_on': DateTime.now().toIso8601String(),
    });

    return id;
  }

  static Future<Project?> getProject() async {
    List<Map> result = await Wren.instance._database.query(
      'projects',
      columns: ['id', 'name', 'task_time', 'created_on'],
      limit: 1,
    );
    if (result.isNotEmpty) {
      var item = result.first;
      return Project(
        id: item['id'],
        name: item['name'],
        taskTime: item['task_time'],
        createdOn: item['created_on'],
      );
    }
    return null;
  }

  static Future<String> createTask(
      {required String name, required String description}) async {
    var id = Wren.instance.uuid.v4();
    await Wren.instance._database.insert('tasks', {
      'id': id,
      'name': name,
      'description': description,
      'status': 'open',
      'created_on': DateTime.now().toIso8601String(),
    });

    return id;
  }

  static Future<List<Task>> getTasks() async {
    List<Map> result = await Wren.instance._database.query(
      'tasks',
      columns: ['id', 'name', 'description', 'status', 'created_on'],
      where: 'status = ?',
      whereArgs: ['open'],
      limit: 3,
    );
    return result
        .map((item) => Task(
              id: item['id'],
              name: item['name'],
              description: item['description'],
              status: item['status'],
              createdOn: item['created_on'],
            ))
        .toList();
  }

  static Future<void> markTaskAsDone(String id) async {
    await Wren.instance._database.update(
      'tasks',
      {'status': 'done'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
