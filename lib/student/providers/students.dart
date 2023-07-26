import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtms/admin/models/bus.dart';
import 'package:http/http.dart' as https;

import '/student/models/student.dart';

class StudentData with ChangeNotifier {
  List<Student> _studentsData = [];
  List<Student> _filteredStudentDetails = [];
  List<Bus> _studentBus = [];

  List<Student> get studentsData {
    return [..._studentsData];
  }

  List<Student> get filteredStudentDetails {
    return [..._filteredStudentDetails];
  }

  List<Bus> get studentBus {
    return [..._studentBus];
  }

  Future<void> addStudent(
      String name,
      int rollNo,
      String email,
      String password,
      int phone,
      String cnic,
      String location,
      String userId) async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/students.json';
    try {
      final responce = await https.post(Uri.parse(url),
          body: json.encode({
            'name': name,
            'rollNo': rollNo,
            'email': email,
            'password': password,
            'phone': phone,
            'cnic': cnic,
            'location': location,
            'creatorId': userId,
            'isFeePaid': false,
          }));
      final stud = Student(
        id: json.decode(responce.body)['name'],
        rollNo: rollNo,
        name: name,
        email: email,
        password: password,
        phone: phone,
        cnic: cnic,
        location: location,
        isFeePaid: false,
      );
      _studentsData.add(stud);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateStudent(
      {String id,
      int rollNo,
      String name,
      String email,
      String cnic,
      int phone,
      String location}) async {
    final studIndex = _studentsData.indexWhere((stud) {
      return stud.id == id;
    });
    if (studIndex >= 0) {
      final url =
          'https://gtms-fd7f3-default-rtdb.firebaseio.com/students/$id.json';
      await https.patch(Uri.parse(url),
          body: json.encode({
            'name': name,
            'rollNo': rollNo,
            'email': email,
            'cnic': cnic,
            'phone': phone,
            'location': location,
          }));
      final stud = Student(
          id: id,
          rollNo: rollNo,
          name: name,
          email: email,
          phone: phone,
          cnic: cnic,
          location: location);

      _studentsData[studIndex] = stud;
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String cnic, String id) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/students/$id.json';
    await https.delete(Uri.parse(url));
    final index = _studentsData.indexWhere((element) => element.cnic == cnic);
    _studentsData.removeAt(index);
    notifyListeners();
  }

  Future<void> fetchStudent(String userId, [bool isAdmin = false]) async {
    final id = isAdmin ? userId : '?orderBy="creatorId"&equalTo="$userId"';
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/students.json$id';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body) as Map<String, dynamic>;
    print({extractedData, 'extractedData'});
    final List<Student> sData = [];
    extractedData.forEach((studId, studData) {
      sData.add(Student(
        id: studId,
        name: studData['name'],
        rollNo: studData['rollNo'],
        email: studData['email'],
        password: studData['password'],
        phone: studData['phone'],
        cnic: studData['cnic'],
        location: studData['location'],
        isFeePaid: studData['isFeePaid'],
      ));
    });
    _studentsData = sData;
    notifyListeners();
  }

  void filterSearch(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      final filteredStudents = _studentsData
          .where((element) =>
              element.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.location
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.phone.toString().contains(enteredKeyword.toLowerCase()))
          .toList();
      _filteredStudentDetails = filteredStudents;
      notifyListeners();
    } else {
      _filteredStudentDetails = _studentsData;
      notifyListeners();
    }
  }

  Future<void> fetchBusDetails() async {
    //?orderBy="route"&equalTo="$name"
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/buses.json';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    List<Bus> bus = [];
    extractedData.forEach((key, data) {
      if (studentLocation
          .toLowerCase()
          .contains(data['route'].toString().toLowerCase())) {
        bus.add(Bus(
            id: key,
            number: data['Bus number'],
            driver: data['driver'],
            route: data['route'],
            date: DateTime.parse(data['date']),
            isRented: data['isRented'] == 'true' ? true : false));
      }
    });
    _studentBus = bus;
    notifyListeners();
  }

  String get studentName {
    final name = _studentsData.isEmpty ? '' : _studentsData.first.name;
    return name;
  }

  String get studentEmail {
    final email = _studentsData.isEmpty ? '' : _studentsData.first.email;
    return email;
  }

  String get studentCNIC {
    final cnic = _studentsData.isEmpty ? '' : _studentsData.first.cnic;
    return cnic;
  }

  int get studentPhone {
    final phone = _studentsData.isEmpty ? 0 : _studentsData.first.phone;
    return phone;
  }

  String get studentLocation {
    final loc = _studentsData.isEmpty ? '' : _studentsData.first.location;
    return loc;
  }

  int get studentRollNo {
    final roll = _studentsData.isEmpty ? 0 : _studentsData.first.rollNo;
    return roll;
  }

  bool get isFeePaid {
    return _studentsData.isEmpty ? true : _studentsData.first.isFeePaid;
  }
}
