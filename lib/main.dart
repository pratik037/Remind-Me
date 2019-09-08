import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:remindme/app/models/taskModel.dart';
import 'package:remindme/app/models/tasksListModel.dart';
import 'package:remindme/app/views/homepageview.dart';

import 'app/views/addTaskView.dart';

void main() async {
  final int helloId = 0;
  await AndroidAlarmManager.initialize();

  runApp(RemindMe());

  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), helloId, checkSendNotification);
}

void checkSendNotification() async {
  TasksModel tasksmodel = TasksModel();

  print('starting process');

  await tasksmodel.getAllTasks();

  print(tasksmodel.allTasks.length);

  if (tasksmodel.allTasks.length > 0) {
    tasksmodel.allTasks.forEach((task) {
      print(task.title);
      DateTime current = DateTime.now();
      print('Difference is : ' + '${current.difference(task.date)}');
      bool shouldNotify = current.difference(task.date) <= Duration(minutes: 1);
      if (shouldNotify) {
        showNotification(task: task);
      }
    });
  }
}

void showNotification({@required Task task}) {
  print('Reached Notification');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('ic_launcher');
  var initializationSettings =
      new InitializationSettings(initializationSettingsAndroid, null);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: null);

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'remindme_1', 'Pratik Singhal', 'A Remind me App',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(
      0, '${task.title}', task.desc, platformChannelSpecifics);
}

class RemindMe extends StatefulWidget {
  @override
  _RemindMeState createState() => _RemindMeState();
}

class _RemindMeState extends State<RemindMe> {
  TasksModel _tasksModel;

  @override
  void initState() {
    _tasksModel = TasksModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (BuildContext context) {
            return _tasksModel;
          },
        )
      ],
      child: MaterialApp(
        title: 'Remind Me',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomePageView(tasksModel: _tasksModel),
          '/add': (BuildContext context) => AddTaskView(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
