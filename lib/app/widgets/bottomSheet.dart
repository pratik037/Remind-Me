import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:remindme/app/models/taskModel.dart';
import 'package:remindme/app/models/tasksListModel.dart';
import 'package:remindme/app/widgets/dtBtn.dart';
import 'package:remindme/app/widgets/fieldWidget.dart';

class BttomSheet extends StatelessWidget {
  const BttomSheet({
    Key key,
    @required this.task,
    @required this.title,
    @required this.desc,
  }) : super(key: key);

  final Task task;
  final TextEditingController title;
  final TextEditingController desc;
  

  @override
  Widget build(BuildContext context) {
    var tasksModel = Provider.of<TasksModel>(context);
    return InkWell(
      onTap: task.date.compareTo(DateTime.now()) > 0
          ? () {
              //this code takes care of updating the reminders.
              // Has fields to update the reminder details.
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  builder: (BuildContext context) {
                    return ListView(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 2,
                              width: 60,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Update Reminder",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Reminder Title : ${task.title}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Reminder Date : ${DateFormat.yMMMMd().format(task.date)}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Reminder Time : ${DateFormat("hh:mm a").format(task.date)}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Field(name: "New Title", controller: title),
                            Field(name: "New Description", controller: desc),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                DateTimeButton(),
                                RaisedButton.icon(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  icon: Icon(Icons.done),
                                  label: Text("Update"),
                                  onPressed:null
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius: BorderRadius.circular(50)),
                              child: SvgPicture.asset('assets/images/edit.svg'),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                  context: context);
            }
          :
          //This code takes care when the task is already reminded.
          //Just shows the details in a bottom sheet
          () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 2,
                          width: 60,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Reminder Detail",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Reminder Title : ${task.title}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Reminded on : ${DateFormat.yMMMMd().format(task.date)}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Reminded at : ${DateFormat("hh:mm a").format(task.date)}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              // color: Colors.green,
                              borderRadius: BorderRadius.circular(50)),
                          child: SvgPicture.asset('assets/images/complete.svg'),
                        )
                      ],
                    );
                  },
                  context: context);
            },
      child: Container(
        constraints: BoxConstraints(minHeight: 150),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${DateFormat.yMMMMd().format(task.date)}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  DateFormat("hh:mm a").format(task.date),
                  // '${task.date.hour} : ${task.date.minute}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Text(
              task.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.black,
              endIndent: 250,
            ),
            Text(
              task.desc,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  //   SnackBar addPageSnack() {
  //   return SnackBar(
  //     content: Text(
  //       'Please select date and time of the future.',
  //       style: TextStyle(
  //         fontSize: 18,
  //         color: Colors.white,
  //       ),
  //     ),
  //     action: SnackBarAction(
  //       label: "Dismiss",
  //       textColor: Colors.yellow,
  //       onPressed: () {
  //         _scaffoldKey.currentState.hideCurrentSnackBar();
  //       },
  //     ),
  //     duration: Duration(seconds: 3),
  //   );
  // }

  // Future submitData() async {
  //   var tasksModel = Provider.of<TasksModel>(context);

  //   Map<String, dynamic> task = tasksModel.taskMap;

  //   task['title'] = title.text;
  //   task['description'] = desc.text;

  //   tasksModel.taskMap = task;

  //   bool val = await tasksModel.addTask(task);
  //   if (val) {
  //     tasksModel.taskMap = {};
  //     Navigator.pushReplacementNamed(context, '/');
  //   }
  // }
}
