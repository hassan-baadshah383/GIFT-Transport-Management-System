import 'dart:convert';

class Attendance {
  int no;
  String employeeId;
  String punchDatetime;
  String deviceNo;
  String status;

  Attendance({
    this.no,
    this.employeeId,
    this.punchDatetime,
    this.deviceNo,
    this.status,
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
