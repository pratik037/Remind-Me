import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:remindme/app/models/taskModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  final String tableTask = 'taskTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';
  final String columnDateTime = 'dateTime';

  static Database _db;
  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tasks.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableTask($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnDescription TEXT, $columnDateTime TEXT)');
  }

  Future<int> saveTask(Map<String, dynamic> task) async{
    var dbClient = await db;
    var result = await dbClient.insert(tableTask, task);

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async{
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(tableTask, columns: [columnId, columnTitle, columnDescription, columnDateTime]);
    return result;
  }

  Future<int> getCount()async{
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableTask'));
  }

  Future<Task> getTask(int id) async{
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableTask, 
    columns: [columnId, columnTitle, columnDescription, columnDateTime],
    where: '$columnId = ?',
    whereArgs: [id]
    );

    if(result.length > 0){
      return Task.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteTask(int id)async{
    var dbClient = await db;
    return await dbClient.delete(tableTask, where:'$columnId = ?', whereArgs: [id] );
  }

  Future<int> updateTask(Task task) async{
    var dbClient = await db;
    return await dbClient.update(tableTask, task.toMap(), where: '$columnId = ?' , whereArgs: [task.id]);
  }
  
  Future close() async{
    var dbClient = await db;
    return dbClient.close();
  }
}