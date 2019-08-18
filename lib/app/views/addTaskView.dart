import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:remindme/app/models/tasksListModel.dart';
import 'package:remindme/app/widgets/fieldWidget.dart';
import 'package:date_format/date_format.dart';

class AddTaskView extends StatefulWidget {
  AddTaskView({Key key}) : super(key: key);

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TimeOfDay _selectedTime;
  DateTime _selectedDate;
  DateTime _finalDateTime;
  int flag = 1;
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDesc = TextEditingController();
  String disp;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null)
      setState(() {
        _selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    Color col = Colors.blue[300];
    final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0;
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
            Container(
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  ClipPath(
                    clipper: WaveClipperOne(),
                    child: Container(
                      color: col,
                      height: 240,
                    ),
                  ),
                  Center(
                      child: SvgPicture.asset('assets/images/add.svg',
                          height: 230)),
                ],
              ),
            ),

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _finalDateTime == null? RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: col, //Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.date_range,
                  color: Colors.white,
                ),
                label: Text(
                  'Pick Date & Time',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await _selectDate(context);
                  await _selectTime(context);

                  DateTime dateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute);

                  if (dateTime != null)
                    setState(() {
                      _finalDateTime = dateTime;
                      // disp = convertStringFromDate();
                      flag = 0;
                    });
                  else {
                    setState(() {
                      flag = 1;
                    });
                  }
                },
              )
              : RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: col, // Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                label: Text(
                  convertStringFromDate(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await _selectDate(context);
                  await _selectTime(context);

                  DateTime dateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute);

                  if (dateTime != null)
                    setState(() {
                      _finalDateTime = dateTime;
                      flag = 0;
                    });
                  else {
                    setState(() {
                      flag = 1;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: showFab? FloatingActionButton(
        backgroundColor: col,
        onPressed: () async {
          flag == 0
              ? await submitData()
              : _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(
                    'Date and Time not selected',
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
                ));
        },
        tooltip: "Add the Task",
        child: Icon(Icons.done),
      ): null,
    );
  }

  Future submitData() async {
    var tasksModel = Provider.of<TasksModel>(context);

    print(taskName.text);
    Map<String, dynamic> task = {
      'title': taskName.text,
      'description': taskDesc.text,
      'dateTime': _finalDateTime.toString()
    };
    bool val = await tasksModel.addTask(task);
    if (val) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  String convertStringFromDate() {
                      final todayDate = _finalDateTime;
                      return formatDate(todayDate,
                            ['Remind on ',dd, '-', mm, '-', yy, ' at ', hh, ':', nn, ' ', am]
                            );
                      }
}

