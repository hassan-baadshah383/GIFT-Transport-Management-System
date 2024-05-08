import 'package:flutter/material.dart';
import '/student/widgets/drawer.dart';

class AttendanceDetails extends StatefulWidget {
  static const routeName = '/attendanceDetails';
  @override
  _AttendanceDetailsState createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  List<Map<String, dynamic>> attendanceData = [
    {'date': '2022-03-01', 'status': 'Present'},
    {'date': '2022-03-02', 'status': 'Present'},
    {'date': '2022-03-03', 'status': 'Absent'},
    {'date': '2022-03-04', 'status': 'Present'},
    {'date': '2022-03-05', 'status': 'Present'},
  ];

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Detail'),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
        ),
        drawer: AppDrawer(),
        body: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: DataTable(
              // horizontalMargin: deviceSize.width,
              // dataRowMinHeight: 60,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey[200] ?? Colors.grey),
              dataRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              columnSpacing: 30.0,
              columns: [
                DataColumn(
                  label: Text(
                    'Date',
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
              ],
              rows: attendanceData
                  .map(
                    (attendance) => DataRow(cells: [
                      DataCell(
                        Text(
                          attendance['date'],
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: attendance['status'] == 'Present'
                                ? Colors.green[50]
                                : Colors.red[50],
                          ),
                          child: Text(
                            attendance['status'],
                            style: TextStyle(
                              color: attendance['status'] == 'Present'
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
