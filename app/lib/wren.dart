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
            status TEXT,
            task_time TEXT,
            created_on TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            project_id TEXT,
            name TEXT,
            status TEXT,
            description TEXT,
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
      'status': 'open',
      'task_time': taskTime,
      'created_on': DateTime.now().toIso8601String(),
    });

    return id;
  }

  static Future<Project?> getProject() async {
    List<Map> result = await Wren.instance._database.query(
      'projects',
      columns: ['id', 'name', 'status', 'task_time', 'created_on'],
      where: 'status = ?',
      whereArgs: ['open'],
      limit: 1,
    );
    if (result.isNotEmpty) {
      var item = result.first;
      return Project(
        id: item['id'],
        name: item['name'],
        status: item['status'],
        taskTime: item['task_time'],
        createdOn: item['created_on'],
      );
    }
    return null;
  }

  static Future<void> updateProject(
      {required String id,
      required String name,
      required String taskTime}) async {
    await Wren.instance._database.update(
      'projects',
      {'name': name, 'task_time': taskTime},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateProjectStatus(
      {required String id, required String status}) async {
    await Wren.instance._database.update(
      'tasks',
      {'status': status},
      where: 'project_id = ?',
      whereArgs: [id],
    );
    await Wren.instance._database.update(
      'projects',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<String> createTask(
      {required String projectId,
      required String name,
      required String description}) async {
    var id = Wren.instance.uuid.v4();
    await Wren.instance._database.insert('tasks', {
      'id': id,
      'project_id': projectId,
      'name': name,
      'status': 'open',
      'description': description,
      'created_on': DateTime.now().toIso8601String(),
    });

    return id;
  }

  static Future<List<Task>> getTasks() async {
    List<Map> result = await Wren.instance._database.query(
      'tasks',
      columns: [
        'id',
        'project_id',
        'name',
        'status',
        'description',
        'created_on'
      ],
      where: 'status = ?',
      whereArgs: ['open'],
      limit: 3,
    );
    return result
        .map((item) => Task(
              id: item['id'],
              projectId: item['project_id'],
              name: item['name'],
              status: item['status'],
              description: item['description'],
              createdOn: item['created_on'],
            ))
        .toList();
  }

  static Future<Task?> getTask(String id) async {
    List<Map> result = await Wren.instance._database.query(
      'tasks',
      columns: [
        'id',
        'project_id',
        'name',
        'status',
        'description',
        'created_on'
      ],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      var item = result.first;
      return Task(
        id: item['id'],
        projectId: item['project_id'],
        name: item['name'],
        status: item['status'],
        description: item['description'],
        createdOn: item['created_on'],
      );
    }
    return null;
  }

  static Future<void> updateTaskStatus(
      {required String id, required String status}) async {
    await Wren.instance._database.update(
      'tasks',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateTask(
      {required String id,
      required String name,
      required String description}) async {
    await Wren.instance._database.update(
      'tasks',
      {'name': name, 'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
