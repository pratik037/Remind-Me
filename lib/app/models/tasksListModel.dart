import 'package:flutter/material.dart';
import 'package:remindme/app/database/dbHelper.dart';
import 'package:remindme/app/models/taskModel.dart';

class TasksModel extends ChangeNotifier {
  List<Task> _tasks = [];
  DatabaseHelper db = DatabaseHelper();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Task> get allTasks => _tasks;

  Future getAllTasks() async {
    // // isloading true
    _isLoading = true;

    // // notifylisteners
    notifyListeners();

    List<Task> fetched = [];

    // Get tasks from db
    db.getAllTasks().then((tasks) {
      // iterate through list of maps received from db to create list of TASK
      tasks.forEach((task) {
        fetched.add(Task.fromMap(task));
        print("Fetched is: ");
        print(fetched.length);
      });
      // assign the new List<Task> to _tasks
    print('${fetched.length} fetched');
    if (fetched.length > 0) {
      
      _tasks = fetched;
    }

    //isloading false
    _isLoading = false;

    // // notifylisteners
    notifyListeners();
    });
    
  }

  Future<bool> addTask(Map<String, dynamic> task) async {
    var res = await db.saveTask(task);
    if (res != null) {
      return true;
    } else
      return false;
  }

  void markCompleted(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
