import 'package:flutter/material.dart';

class Driver with ChangeNotifier {
  String id;
  String creatorId;
  String name;
  String email;
  String password;
  String licenseCategory;
  int phone;
  String cnic;
  bool isEnable;

  Driver({
    @required this.id,
    @required this.creatorId,
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.cnic,
    @required this.phone,
    @required this.licenseCategory,
    @required this.isEnable,
  });
}
