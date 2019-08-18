import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remindme/app/models/tasksListModel.dart';
import 'package:remindme/app/views/homepageview.dart';

import 'app/views/addTaskView.dart';

void main() => runApp(RemindMe());

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
          '/add' : (BuildContext context) => AddTaskView(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
