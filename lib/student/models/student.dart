import 'package:flutter/cupertino.dart';

class Student with ChangeNotifier {
  String id;
  int rollNo;
  String name;
  String email;
  String password;
  int phone;
  String cnic;
  String location;
  bool isFeePaid;

  Student({
    required this.id,
    required this.rollNo,
    required this.name,
    required this.email,
    this.password = '',
    required this.phone,
    required this.cnic,
    required this.location,
    this.isFeePaid = false,
  });
}
