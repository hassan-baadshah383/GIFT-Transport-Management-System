import 'package:flutter/material.dart';
import 'package:gtms/admin/screens/students_management/edit_student_screen.dart';
import 'package:gtms/admin/screens/students_management/student_detail_description.dart';
import 'package:gtms/student/providers/students.dart';
import 'package:provider/provider.dart';

class StudentDetailWidget extends StatefulWidget {
  String id;
  int rollNo;
  String name;
  String email;
  int phone;
  String cnic;
  String location;

  StudentDetailWidget({
    @required this.id,
    @required this.rollNo,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.cnic,
    @required this.location,
  });

  @override
  State<StudentDetailWidget> createState() => _StudentDetailWidgetState();
}

class _StudentDetailWidgetState extends State<StudentDetailWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final studData = Provider.of<StudentData>(context);
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(StudentDetailDescription.routeName, arguments: {
            'name': widget.name,
            'rollNo': widget.rollNo,
            'email': widget.email,
            'phone': widget.phone,
            'cnic': widget.cnic,
            'location': widget.location,
          });
        },
        leading: const CircleAvatar(
            child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),
        )),
        title: Text(widget.name),
        subtitle: Text(widget.location),
        trailing: FittedBox(
            child: Row(
          children: [
            IconButton(
                onPressed: (() {
                  Navigator.of(context)
                      .pushNamed(EditStudentScreen.routeName, arguments: {
                    'id': widget.id,
                    'rollNo': widget.rollNo,
                    'name': widget.name,
                    'email': widget.email,
                    'phone': widget.phone,
                    'cnic': widget.cnic,
                    'location': widget.location
                  });
                }),
                icon: const Icon(Icons.edit)),
            _isLoading
                ? const CircularProgressIndicator()
                : IconButton(
                    onPressed: (() async {
                      setState(() {
                        _isLoading = true;
                      });
                      await studData
                          .deleteStudent(widget.cnic, widget.id)
                          .then((value) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          'Student Deleted!',
                          textAlign: TextAlign.center,
                        )));
                      });
                      setState(() {
                        _isLoading = false;
                      });
                    }),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
          ],
        )),
      ),
    );
  }
}
