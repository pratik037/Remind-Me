class Task{
  int _id;
  String _title;
  String _description;
  DateTime _dateTime;

Task(this._title, this._description, this._dateTime);

Task.map(dynamic obj) {
  this._id = obj['id'];
  this._title = obj['title'];
  this._description = obj['description'];
  this._dateTime = obj['date'];
}

int get id => _id;
String get title => _title;
String get desc => _description;
DateTime get date => _dateTime;

Map<String, dynamic> toMap(){
  var taskMap = new Map<String,dynamic>();
  if(_id != null){
    taskMap['id'] = _id;
  }

  taskMap['title'] = _title;
  taskMap['description'] = _description;
  taskMap['dateTime'] = _dateTime.toString();


  return taskMap;
}

Task.fromMap(Map<String,dynamic> taskMap){
  this._id = taskMap['id'];
  this._title = taskMap['title'];
  this._description = taskMap['description'];
  this._dateTime = DateTime.parse(taskMap['dateTime']) ;
}
}