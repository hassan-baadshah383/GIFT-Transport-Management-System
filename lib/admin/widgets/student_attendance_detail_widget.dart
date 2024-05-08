import 'package:flutter/material.dart';

import 'package:gtms/admin/screens/students_management/attendance_detail_screen.dart';

class StudentAttendanceDetailWidget extends StatefulWidget {
  String employeeId;

  StudentAttendanceDetailWidget({
    required this.employeeId,
  });

  @override
  State<StudentAttendanceDetailWidget> createState() =>
      _StudentAttendanceDetailWidgetState();
}

class _StudentAttendanceDetailWidgetState
    extends State<StudentAttendanceDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
            child: FittedBox(
          child:
              Padding(padding: EdgeInsets.all(5.0), child: Icon(Icons.person)),
        )),
        title: Text(widget.employeeId),
        trailing: FittedBox(
            child: TextButton(
                onPressed: (() {
                  Navigator.of(context)
                      .pushNamed(AttendanceDetailScreen.routeName, arguments: {
                    'id': widget.employeeId,
                  });
                }),
                child: const Text(
                  'Check Attendance',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
      ),
    );
  }
}
