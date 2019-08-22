import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remindme/app/models/tasksListModel.dart';

class DateTimeButton extends StatefulWidget {
  @override
  _DateTimeButtonState createState() => _DateTimeButtonState();
}

class _DateTimeButtonState extends State<DateTimeButton> {
  TimeOfDay _selectedTime;
  DateTime _selectedDate;
  DateTime _finalDateTime;

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

  String convertStringFromDate() {
    final todayDate = _finalDateTime;
    return formatDate(todayDate,
        ['Remind on ', dd, '-', mm, '-', yy, ' at ', hh, ':', nn, ' ', am]);
  }

  @override
  Widget build(BuildContext context) {
    Color col = Colors.blue[300];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _finalDateTime == null
          ? RaisedButton.icon(
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
              onPressed: _handleDateTimePick,
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: _handleDateTimePick,
            ),
    );
  }

  void _handleDateTimePick() async {
    await _selectDate(context);
    await _selectTime(context);

    var tasksModel = Provider.of<TasksModel>(context);

    DateTime dateTime = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

    if (dateTime != null) {
      setState(() {
        _finalDateTime = dateTime;
      });

      Map<String, dynamic> map = tasksModel.taskMap;

      map['dateTime'] = dateTime.toString();

      tasksModel.taskMap = map;
    }
  }
}
