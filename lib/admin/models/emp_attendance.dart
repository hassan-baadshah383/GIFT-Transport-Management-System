import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class EmployeAttendance with ChangeNotifier {
  String id;
  String employeeId;
  String punchDatetime;
  String status;

  EmployeAttendance({
    @required this.id,
    @required this.employeeId,
    @required this.punchDatetime,
    @required this.status,
  });

  List<EmployeAttendance> _attendanceDetails = [];
  List<String> _employeIds = [];
  List<String> filteredId = [];

  List<EmployeAttendance> get attendanceDetails {
    return [..._attendanceDetails];
  }

  List<String> get employeIds {
    return [..._employeIds];
  }

  Future<void> fetchAttendanceId() async {
    const url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/attendance.json';
    final responce = await http.get(Uri.parse(url));
    final extractedData = json.decode(responce.body) as Map<String, dynamic>;
    List<String> ids = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((aId, attendanceDataMap) {
      ids.add(aId);
    });
    final allIds = ids.toSet().toList();
    _employeIds = allIds;
    notifyListeners();
  }

  Future<void> fetchAttendanceData(String eId) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/attendance.json';
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<EmployeAttendance> attendanceData = [];
    print({extractedData, 'Extracted Data'});
    extractedData.forEach((aId, attendanceDataMap) {
      if (aId == eId) {
        attendanceDataMap.forEach((date, statusMap) {
          final status = statusMap['Status'] as String;
          attendanceData.add(EmployeAttendance(
            employeeId: aId,
            punchDatetime: date,
            status: status,
          ));
        });
      }
    });
    _attendanceDetails = attendanceData;
    notifyListeners();
  }

  void filterSearch(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      final filteredAttendance = _employeIds
          .where((element) =>
              element.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      filteredId = filteredAttendance;
      notifyListeners();
    }
  }
}
