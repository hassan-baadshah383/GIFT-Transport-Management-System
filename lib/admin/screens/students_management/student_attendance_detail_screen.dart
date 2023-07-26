import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gtms/admin/models/emp_attendance.dart';
import 'package:gtms/admin/widgets/student_attendance_detail_widget.dart';
import 'package:gtms/student/models/student.dart';
import 'package:provider/provider.dart';
import 'package:gtms/admin/models/attendance.dart';
import 'package:gtms/admin/providers/api_service.dart';
import 'package:gtms/student/providers/students.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

class StudentsAttendanceDetails extends StatefulWidget {
  static const routeName = '/studentAttendanceDetails';

  @override
  State<StudentsAttendanceDetails> createState() =>
      _StudentsAttendanceDetailsState();
}

class _StudentsAttendanceDetailsState extends State<StudentsAttendanceDetails> {
  List<String> students = [
    '00000012',
    '00000020',
    '00000021',
    '00000022',
    '00000028',
    '00000031',
    '00001979'
  ];
  bool _isLoading = false;
  bool _showSearchBar = false;

  @override
  void initState() {
    _syncPage();
    super.initState();
  }

  void _syncPage() async {
    setState(() {
      _isLoading = true;
    });
    await students.forEach((std) {
      setInitialStatus(std, DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });
    await _fetchAttendanceData();
    await fetchData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void setInitialStatus(String studentId, String date) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/attendance/${studentId}/${date}.json';
    final response = await https.get(Uri.parse(url));
    if (response.statusCode == 200 && response.body != 'null') {
      return;
    }
    await https.patch(Uri.parse(url),
        body: json.encode({
          'Status': '00',
        }));
  }

  void _fetchAttendanceData() async {
    DateTime now = DateTime.now();
    try {
      List<Attendance> attendance = await APIService.getAttendanceData(
          DateFormat('yyyy-MM-dd').format(now),
          DateFormat('yyyy-MM-dd').format(now));
      print({attendance, 'Attendance'});
      attendance.forEach((element) {
        print({element.punchDatetime, 'DateTime'});
        _postAttendanceData(element.employeeId,
            element.punchDatetime.substring(0, 10), element.status);
      });
    } catch (e) {
      print({e, 'Error APi'});
    }
  }

  void _postAttendanceData(String studentId, String date, String status) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/attendance/${studentId}/${date}.json';
    final response = await https.get(Uri.parse(url));
    if (response.statusCode == 200 && response.body != 'null') {
      return;
    }
    await https.patch(Uri.parse(url),
        body: json.encode({
          'Status': status,
        }));
  }

  Future<void> fetchData() async {
    await Provider.of<EmployeAttendance>(context, listen: false)
        .fetchAttendanceId();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceData = Provider.of<EmployeAttendance>(context);
    List<String> employeIds = attendanceData.employeIds;
    if (employeIds.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }
    List<String> filteredIds = attendanceData.filteredId;

    Widget appBarTitle = const Text('Students Details');

    if (_showSearchBar) {
      appBarTitle = TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          hintText: 'Search...',
        ),
        onChanged: (String value) {
          attendanceData.filterSearch(value);
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
                    attendanceData.filterSearch('');
                    attendanceData.filteredId = [];
                  },
                  icon: const Icon(Icons.close),
                ),
            ]),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : employeIds.isEmpty
                ? const Center(child: Text('No any student enrolled.'))
                : RefreshIndicator(
                    backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
                    onRefresh: () async {
                      _syncPage();
                    },
                    child: Column(
                      children: [
                        if (kIsWeb)
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            child: ElevatedButton(
                                onPressed: () async {
                                  _syncPage();
                                },
                                child: Text('Sync Attendance Data')),
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ListView.builder(
                                itemBuilder: ((context, index) {
                                  return Column(
                                    children: [
                                      filteredIds.isNotEmpty
                                          ? StudentAttendanceDetailWidget(
                                              employeeId: filteredIds[index],
                                            )
                                          : StudentAttendanceDetailWidget(
                                              employeeId: employeIds[index],
                                            )
                                    ],
                                  );
                                }),
                                itemCount: filteredIds.isNotEmpty
                                    ? filteredIds.length
                                    : employeIds.length),
                          ),
                        ),
                      ],
                    ),
                  ));
  }
}
