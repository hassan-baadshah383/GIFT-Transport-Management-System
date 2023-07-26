import 'package:flutter/material.dart';
import 'package:gtms/admin/models/emp_attendance.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as https;
import 'dart:convert';

import '../../models/attendance.dart';
import '../../providers/api_service.dart';

class AttendanceDetailScreen extends StatefulWidget {
  static const routeName = '/attendanceDetailScreen';
  @override
  _AttendanceDetailScreenState createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final routeDetails =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final routeId = routeDetails['id'];
    await Provider.of<EmployeAttendance>(context, listen: false)
        .fetchAttendanceData(routeId);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fetchAttendanceData() async {
    setState(() {
      _isLoading = true;
    });
    DateTime now = DateTime.now();
    try {
      List<Attendance> attendance = await APIService.getAttendanceData(
          DateFormat('yyyy-MM-dd').format(now),
          DateFormat('yyyy-MM-dd').format(now));
      attendance.forEach((element) {
        postAttendanceData(
            element.employeeId, element.punchDatetime, element.status);
      });
    } catch (e) {
      print({e, 'Error APi'});
    }
    setState(() {
      _isLoading = false;
    });
  }

  void postAttendanceData(String studentId, String date, String status) async {
    try {
      final url =
          'https://gtms-fd7f3-default-rtdb.firebaseio.com/attendance/${studentId}/${date}.json';
      final response = await https.get(Uri.parse(url));
      if (response.statusCode == 200 && response.body != 'null') {
        return;
      }
      await https.post(Uri.parse(url),
          body: json.encode({
            'Status': status,
          }));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attData = Provider.of<EmployeAttendance>(context, listen: false);
    List<EmployeAttendance> attDetails = attData.attendanceDetails;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Detail'),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
          actions: [Icon(Icons.description)],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
                onRefresh: () async {
                  await _fetchAttendanceData();
                  await fetchData();
                  attDetails = attData.attendanceDetails;
                },
                child: ListView(children: [
                  Column(
                    children: [
                      if (kIsWeb)
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                              onPressed: () async {
                                await _fetchAttendanceData();
                                await fetchData();
                                attDetails = attData.attendanceDetails;
                              },
                              child: Text('Sync Attendance Data')),
                        ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          alignment:
                              kIsWeb ? Alignment.topCenter : Alignment.topLeft,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.grey[200]),
                                dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Student Id',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date & Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  // DataColumn(
                                  //   label: Text(
                                  //     'Mark',
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.grey[800],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                                rows: attDetails
                                    .map(
                                      (attendance) => DataRow(cells: [
                                        DataCell(
                                          Text(
                                            attendance.employeeId,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            attendance.punchDatetime,
                                            //.replaceRange(10, 11, ' '),
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            attendance.status == '01'
                                                ? 'Present'
                                                : 'Absent',
                                            style: TextStyle(
                                              color: attendance.status == '01'
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // DataCell(
                                        //   IconButton(
                                        //     icon: attendance.status == '01'
                                        //         ? const Icon(Icons.close,
                                        //             color: Colors.red)
                                        //         : const Icon(Icons.check,
                                        //             color: Colors.green),
                                        //     onPressed: () {
                                        //       setState(() {
                                        //         attendance.status =
                                        //             attendance.status == '01'
                                        //                 ? '00'
                                        //                 : '01';
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                      ]),
                                    )
                                    .toList(),
                              )),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
      ),
    );
  }
}
