import 'package:flutter/material.dart';

import '/driver/screens/driver_profile_screen.dart';
import '../models/dashboard_item_properties.dart';
import '../screens/bus_details_screen.dart';

class DriverActionData {
  final dummyStudentList = [
    DashboardItemProperties(
        'Bus Details',
        const Icon(
          Icons.directions_bus,
          size: 80,
          color: Color.fromARGB(255, 57, 47, 47),
        ),
        DriverBusDetailsScreen.routeName,
        Colors.teal),
    DashboardItemProperties(
        'Profile',
        const Icon(
          Icons.person,
          size: 80,
          color: Colors.white,
        ),
        DriverProfile.routeName,
        Colors.red[900] ?? Colors.red),
  ];
}
