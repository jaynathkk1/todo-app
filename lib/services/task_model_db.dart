import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;
  String priority;
  String dueDate;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.dueDate,
  });

  // Convert a Task into a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority,
      'dueDate': dueDate,
    };
  }

  // Convert a Map into a Task object
  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        isCompleted = map['isCompleted'] == 1,
        priority = map['priority'],
        dueDate = map['dueDate'];

}

class TaskDatabaseHelper {
  static final TaskDatabaseHelper instance = TaskDatabaseHelper._init();

  static Database? _database;

  TaskDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final dbLocation = join(dbPath, path);
    return openDatabase(dbLocation, version: 1, onCreate: _onCreate);
  }

  //Create data
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL,
        priority TEXT NOT NULL,
        dueDate TEXT NOT NULL
      )
    ''');
  }
  //Fetch data
  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks');
    return taskMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
  }
  // Fetch data by id
  Future<Task?> getTaskById(int id) async {
    final db = await instance.database;

    // Query the database to find the task by id
    final List<Map<String, dynamic>> taskMaps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],  // Pass the id to match
    );

    // If a task is found, return the Task object, otherwise return null
    if (taskMaps.isNotEmpty) {
      return Task.fromMap(taskMaps.first); // Return the first matching task
    } else {
      return null; // Return null if no task found with the given id
    }
  }

  //Add Data
  Future<int> addTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  //Update Data from id
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete Data from id
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
