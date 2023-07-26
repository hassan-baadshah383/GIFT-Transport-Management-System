import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/attendance.dart';

class APIService {
  final String baseUrl = "http://pioneerattendance.com:50/api";
  final String employeeDataEndpoint = "/EmployeeData/DateRange/";

  static Future<List<Attendance>> getAttendanceData(
      String startDate, String endDate) async {
    String url =
        'http://pioneerattendance.com:50/api/EmployeeData/DateRange/${startDate}/${endDate}';
    // print(url);
    // String url =
    //     'http://pioneerattendance.com:50/api/EmployeeData/DateRange/2023-04-11/2023-04-11';
    final response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    final jsonString = response.body;

    if (response.statusCode == 200) {
      List<Attendance> attendanceList = Attendance.fromJsonList(jsonString);
      return attendanceList;
    } else {
      throw Exception('Failed to load attendance data');
    }
  }
}
