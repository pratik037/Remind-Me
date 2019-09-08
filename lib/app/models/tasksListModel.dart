import 'package:flutter/material.dart';
import 'package:remindme/app/database/dbHelper.dart';
import 'package:remindme/app/models/taskModel.dart';

class TasksModel extends ChangeNotifier {
  List<Task> _tasks = [];
  Task _psuedo;
  DatabaseHelper db = DatabaseHelper();

  bool _flag = true;
  bool _isLoading = false;

  //Getter for FLAG
  bool get flagVal => _flag;

  //Setter for FLAG
  set flag(bool val) {
    _flag = val;
  }

  //Getter for loading
  bool get isLoading => _isLoading;



  //Getter for all tasks
  List<Task> get allTasks => _tasks;

  //Setter for all tasks
  set allTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }


  Map<String, dynamic> _taskMap = {};

  //Getter for taskMap
  Map<String, dynamic> get taskMap => _taskMap;

  Task get pseudo => _psuedo;

  set pseudo(Task task) {
    _psuedo = task;
    notifyListeners();
  }

  set taskMap(Map<String, dynamic> map) {
    _taskMap = map;
    notifyListeners();
  }

  Future getAllTasks() async {
    _isLoading = true;
    notifyListeners();

    List<Task> fetched = [];

    List<Map<String, dynamic>> tasks = await db.getAllTasks();

    tasks.forEach((task) {
      fetched.add(Task.fromMap(task));
      print("Fetched is: ");
      print(fetched.length);
    });

    // assign the new fetched List<Task> to _tasks
    if (fetched.length > 0) {
      _tasks = fetched;
    }
    _isLoading = false;
    notifyListeners();
  }

  //Add task to the DB

  Future<bool> addTask(Map<String, dynamic> task) async {
    var res = await db.saveTask(task);
    if (res != null) {
      return true;
    } else
      return false;
  }

  Future<bool> update(Map<String, dynamic> task) async{
    print("Inside Update fn");
    print(task);
    var res = await db.updateTask(task);
    if(res!= null){
      return true;
    }
    else
      return false;
  }

  void markCompleted(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    // db.deleteTask(task.id);
    notifyListeners();
  }

  void check(int id) {
    if (_flag) {
      deleteFromDb(id);
    }
  }

  void deleteFromDb(int id) {
    db.deleteTask(id);
    notifyListeners();
  }
}
