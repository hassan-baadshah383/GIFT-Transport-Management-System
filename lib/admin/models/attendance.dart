import 'dart:convert';

class Attendance {
  int no;
  String employeeId;
  String punchDatetime;
  String deviceNo;
  String status;

  Attendance({
    required this.no,
    required this.employeeId,
    required this.punchDatetime,
    required this.deviceNo,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      no: json['No'],
      employeeId: json['Employee ID'],
      punchDatetime: json['PunchDatetime'],
      deviceNo: json['Device No'],
      status: json['Status'],
    );
  }

  static List<Attendance> fromJsonList(String jsonString) {
    List<dynamic> data = json.decode(jsonString);
    return data.map((attendance) => Attendance.fromJson(attendance)).toList();
  }
}
