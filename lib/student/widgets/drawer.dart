import 'package:flutter/material.dart';
import 'package:gtms/student/screens/bus_location_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../auth.dart';
import '../screens/attendance_details_screen.dart';
import '../screens/student_bus_details_screen.dart';
import '../providers/students.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final studentData = Provider.of<StudentData>(context);
    return Drawer(
      width: kIsWeb ? 400 : 270,
      child: ListView(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(0, 0, 128, 1),
            Color.fromRGBO(0, 0, 128, 1),
            Color.fromRGBO(230, 126, 0, 1)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: DrawerHeader(
              decoration: const BoxDecoration(),
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                      Text(
                        studentData.studentName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 16),
                      )
                    ],
                  ))),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          leading: const Icon(
            Icons.home,
          ),
          title: const Text('Home'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(BusLocationScreen.routeName);
          },
          leading: const Icon(
            Icons.location_pin,
          ),
          title: const Text('Bus Location'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(AttendanceDetails.routeName);
          },
          leading: const Icon(
            Icons.calendar_month,
          ),
          title: const Text('Attendance Details'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(BusDetailsScreen.routeName);
          },
          leading: const Icon(
            (Icons.directions_bus),
          ),
          title: const Text('Bus Details'),
        ),

        // const Divider(),
        // ListTile(
        //   onTap: () {
        //     // Navigator.of(context).pushReplacementNamed(UserProducts.routeName);
        //   },
        //   leading: const Icon(
        //     (Icons.edit),
        //   ),
        //   title: const Text('Manage Products'),
        // ),
        const Divider(),
        ListTile(
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
          },
          leading: const Icon(
            (Icons.exit_to_app),
          ),
          title: const Text('Logout'),
        ),
        const Divider(),
      ]),
    );
  }
}
