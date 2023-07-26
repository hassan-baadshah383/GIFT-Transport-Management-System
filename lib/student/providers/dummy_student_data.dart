import 'package:flutter/material.dart';

import '../models/dashboard_item_properties.dart';
import '../screens/attendance_details_screen.dart';
import '../screens/student_bus_details_screen.dart';
import '../screens/bus_location_screen.dart';

class StudentActionData {
  final dummyStudentList = [
    DashboardItemProperties(
        'Bus Details',
        const Icon(
          Icons.directions_bus,
          size: 80,
          color: Color.fromARGB(255, 57, 47, 47),
        ),
        BusDetailsScreen.routeName,
        Colors.teal),
    DashboardItemProperties(
        'Attendance Detail',
        const Icon(
          Icons.calendar_month,
          size: 80,
          color: Colors.white,
        ),
        AttendanceDetails.routeName,
        Colors.deepOrangeAccent),
    DashboardItemProperties(
      'View Bus Location',
      const Icon(
        Icons.location_pin,
        size: 80,
        color: Color.fromARGB(255, 182, 12, 197),
      ),
      BusLocationScreen.routeName,
      const Color.fromARGB(255, 41, 0, 138),
    ),
  ];
}
