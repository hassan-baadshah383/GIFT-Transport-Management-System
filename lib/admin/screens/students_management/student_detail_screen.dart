import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gtms/admin/widgets/student_detail_widget.dart';
import 'package:gtms/student/models/student.dart';
import 'package:gtms/student/providers/students.dart';

class StudentDetailScreen extends StatefulWidget {
  static const routeName = '/StudentDetailScreen';

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  bool _isLoading = false;
  bool _showSearchBar = false;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<StudentData>(context, listen: false)
        .fetchStudent('', true);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studData = Provider.of<StudentData>(context);
    final studDetails = studData.studentsData;
    List<Student> filteredStudents = studData.filteredStudentDetails;

    Widget appBarTitle = const Text('Students Details');

    if (_showSearchBar) {
      appBarTitle = TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          hintText: 'Search...',
        ),
        onChanged: (String value) {
          studData.filterSearch(value);
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
            title: appBarTitle,
            backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
            actions: [
              if (!_showSearchBar)
                IconButton(
                    onPressed: (() {
                      setState(() {
                        _showSearchBar = true;
                      });
                    }),
                    icon: const Icon(Icons.search)),
              if (_showSearchBar)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showSearchBar = false;
                    });
                    studData.filterSearch('');
                    filteredStudents = [];
                  },
                  icon: const Icon(Icons.close),
                ),
            ]),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : studDetails.isEmpty
                ? const Center(child: Text('No any student enrolled.'))
                : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView.builder(
                              itemBuilder: ((context, index) {
                                return Column(
                                  children: [
                                    filteredStudents.isNotEmpty
                                        ? StudentDetailWidget(
                                            id: filteredStudents[index].id,
                                            rollNo:
                                                filteredStudents[index].rollNo,
                                            name: filteredStudents[index].name,
                                            email:
                                                filteredStudents[index].email,
                                            phone:
                                                filteredStudents[index].phone,
                                            cnic: filteredStudents[index].cnic,
                                            location: filteredStudents[index]
                                                .location,
                                          )
                                        : StudentDetailWidget(
                                            id: studDetails[index].id,
                                            rollNo: studDetails[index].rollNo,
                                            name: studDetails[index].name,
                                            email: studDetails[index].email,
                                            phone: studDetails[index].phone,
                                            cnic: studDetails[index].cnic,
                                            location:
                                                studDetails[index].location,
                                          )
                                  ],
                                );
                              }),
                              itemCount: filteredStudents.isNotEmpty
                                  ? filteredStudents.length
                                  : studDetails.length),
                        ),
                      ),
                    ],
                  ));
  }
}
