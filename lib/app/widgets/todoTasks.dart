import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:remindme/app/models/taskModel.dart';
import 'package:remindme/app/widgets/fieldWidget.dart';
import '../widgets/bottomSheet.dart';

class TodoTaskList extends StatelessWidget {
  const TodoTaskList({
    Key key,
    @required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    TextEditingController title = TextEditingController();
    TextEditingController desc = TextEditingController();
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Material(
              elevation: 4,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
              child: BttomSheet(task: task, title: title, desc: desc),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  task.date.compareTo(DateTime.now()) > 0
                      ? 'Upcoming'.toUpperCase()
                      : 'Reminded'.toUpperCase(),
                  style: TextStyle(
                      letterSpacing: 2, fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
          ],
        ));
  }
}


