import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remindme/app/models/tasksListModel.dart';
import 'package:remindme/app/widgets/dtBtn.dart';
import 'package:remindme/app/widgets/fieldWidget.dart';
import 'package:remindme/app/widgets/headContainer.dart';

class AddTaskView extends StatefulWidget {
  AddTaskView({Key key}) : super(key: key);

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController taskName = TextEditingController();
  TextEditingController taskDesc = TextEditingController();
  String disp;

  @override
  Widget build(BuildContext context) {
    Color col = Colors.blue[300];
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    var tasksModel = Provider.of<TasksModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: col,
        iconTheme: IconThemeData(color: Colors.black, opacity: 0.8),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeadContainer(col: col),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Task Details",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto'),
              ),
            ),
            Field(
              name: "Name",
              controller: taskName,
            ),
            Field(
              name: "Description",
              controller: taskDesc,
            ),

            //DATE TIME Button
            DateTimeButton()
          ],
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              backgroundColor: col,
              onPressed: () async {
                tasksModel.taskMap['dateTime'] != null
                    ? await submitData()
                    : _scaffoldKey.currentState.showSnackBar(addPageSnack());
              },
              tooltip: "Add the Task",
              child: Icon(Icons.done),
            )
          : null,
    );
  }

  SnackBar addPageSnack() {
    return SnackBar(
      content: Text(
        'Please select date and time of the future.',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: "Dismiss",
        textColor: Colors.yellow,
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
      duration: Duration(seconds: 3),
    );
  }

  Future submitData() async {
    var tasksModel = Provider.of<TasksModel>(context);

    Map<String, dynamic> task = tasksModel.taskMap;

    task['title'] = taskName.text;
    task['description'] = taskDesc.text;

    tasksModel.taskMap = task;

    bool val = await tasksModel.addTask(task);
    if (val) {
      tasksModel.taskMap = {};
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
