import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remindme/app/models/taskModel.dart';
import 'package:remindme/app/models/tasksListModel.dart';
import 'package:provider/provider.dart';
import 'package:remindme/app/widgets/todoTasks.dart';

class HomePageView extends StatefulWidget {
  final TasksModel tasksModel;

  const HomePageView({Key key, @required this.tasksModel}) : super(key: key);
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  var homeImage = 'assets/images/tasks.svg';
  TasksModel tasksModel;

  @override
  void initState() {
    tasksModel = this.widget.tasksModel;
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      _initiateFetch();
    });

    super.initState();
  }

  void _initiateFetch() async {
    await tasksModel.getAllTasks();
  }

  Future<bool> _exitApp(BuildContext context) {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    var tsk = Provider.of<TasksModel>(context);
    // print('tskModel length:  ${tsk.allTasks.length}');
    // print('tasksModel length: ${tasksModel.allTasks.length}');
    return WillPopScope(
      onWillPop: () {
        _exitApp(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Container(
                      //alignment: Alignment.topLeft,
                      child: SvgPicture.asset(homeImage),
                      // child: Image,
                    ),
                  ),
                ),
                Text(
                  "Reminders",
                  style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: Colors.black38,
                  endIndent: 150,
                  indent: 150,
                )
              ]),
            ),
            tsk.isLoading
                ? SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        height: 20,
                        width: 5,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    ]),
                  )
                : tsk.allTasks.length == 0
                    ? SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            height: MediaQuery.of(context).size.height * 0.27,
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Hmmm, No Reminders...",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            Task task = tsk.allTasks[i];
                            return Dismissible(
                              key: Key(task.id.toString()),
                              background: Container(
                                padding: EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                color: Colors.transparent,
                                child: Icon(Icons.delete),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                tsk.pseudo = task;
                                tsk.flag = true;
                                tsk.deleteTask(task);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    '${task.title} deleted',
                                  ),
                                  duration: Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: "Undo",
                                    onPressed: () {
                                      List<Task> revisedList = tsk.allTasks;
                                      revisedList.insert(i, tsk.pseudo);
                                      tsk.allTasks = revisedList;
                                      tsk.flag = false;
                                      tsk.check(task.id);
                                    },
                                  ),
                                ));
                                Future.delayed(Duration(seconds: 3))
                                    .whenComplete(() {
                                  tsk.check(task.id);
                                });
                              },
                              child: TodoTaskList(task: task,),
                            );
                          },
                          childCount: tsk.allTasks.length,
                        ),
                      )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          backgroundColor: Colors.amber,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
