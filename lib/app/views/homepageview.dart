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
    // print(tsk.allTasks.length);
    return WillPopScope(
        onWillPop: (){
          _exitApp(context);
        },
          child: Scaffold(
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
                  "Tasks to be done: ",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                ),
              ]),
            ),
            tsk.isLoading
                ? SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CircularProgressIndicator(),
                      )
                    ]),
                  )
                : tsk.allTasks.length == 0
                    ? SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Tasks pending",
                              style: TextStyle(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            Task task = tsk.allTasks[i];
                            return TodoTaskList(task: task);
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
