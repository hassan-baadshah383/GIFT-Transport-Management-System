import 'package:flutter/material.dart';

class Bus with ChangeNotifier {
  String id;
  String number;
  String driver;
  String route;
  DateTime date;
  bool isRented;

  Bus({
    required this.id,
    required this.number,
    required this.driver,
    required this.route,
    required this.date,
    required this.isRented,
  });
}
