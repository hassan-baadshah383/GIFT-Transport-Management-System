import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:gtms/admin/models/fee.dart';

class FeeProvider with ChangeNotifier {
  List<StudentFee> _studentFees = [];
  List<StudentFee> _paidStudentsList = [];
  List<StudentFee> _unPaidStudentsList = [];

  List<StudentFee> get studentFees {
    return [..._studentFees];
  }

  List<StudentFee> get paidStudentsList {
    return [..._paidStudentsList];
  }

  List<StudentFee> get unPaidStudentsList {
    return [..._unPaidStudentsList];
  }

  Future<void> fetchData() async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/students.json';
    final response = await https.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<StudentFee> fee = [];
    extractedData.forEach((id, data) {
      fee.add(StudentFee(
          rollNo: data['rollNo'],
          sId: id,
          name: data['name'],
          isFeePaid: data['isFeePaid']));
    });
    _studentFees = fee;
    _studentFees
        .forEach((element) => print({element.isFeePaid, 'Is Fee Paid Method'}));
    notifyListeners();
  }

  Future<void> updateData(String id, bool isFeePaid) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/students/$id.json';
    final response = await https.patch(Uri.parse(url),
        body: json.encode({
          'isFeePaid': isFeePaid,
        }));
  }

  void paidStudents() {
    final p =
        _studentFees.where((element) => element.isFeePaid == true).toList();
    _paidStudentsList = p;
  }

  void unPaidStudents() {
    final p =
        _studentFees.where((element) => element.isFeePaid == false).toList();
    _unPaidStudentsList = p;
  }
}
