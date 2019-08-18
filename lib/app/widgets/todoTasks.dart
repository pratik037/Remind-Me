import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remindme/app/models/taskModel.dart';
class TodoTaskList extends StatelessWidget {
  const TodoTaskList({
    Key key,
    @required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Material(
              elevation: 4,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30)),
              child: Container(
                constraints: BoxConstraints(minHeight: 150),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${DateFormat.yMMMMd().format(task.date)}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${task.date.hour} : ${task.date.minute}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    
                      Text(
                        task.title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    
                    
                    Divider(color: Colors.black, endIndent: 250,),
                    Text(
                      task.desc,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  task.date.compareTo(DateTime.now()) > 0
                      ? 'Upcoming'.toUpperCase()
                      : 'Reminded'.toUpperCase(),
                  style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 14,
                      color: Colors.grey),
                ),
              ),
            ),
          ],
        ));
  }
}

