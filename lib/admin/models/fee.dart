import 'package:flutter/material.dart';

class StudentFee with ChangeNotifier {
  int rollNo;
  String sId;
  String name;
  bool isFeePaid;

  StudentFee(
      {@required this.rollNo,
      @required this.sId,
      @required this.name,
      @required this.isFeePaid});
}
