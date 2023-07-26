import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gtms/admin/screens/admin_homepage_screen.dart';
import 'package:gtms/admin/widgets/admin_drawer.dart';

import 'driver_management/driver_management.dart';
import 'routes_management/routes_management.dart';
import 'students_management/student_management.dart';
import 'vehicle_management/vehicle_management_screen.dart';
import 'package:provider/provider.dart';
import 'package:gtms/auth.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    // if(kIsWeb){
    //   return DefaultTabController(
    //     length: 4,
    //     child: Scaffold(
    //         appBar: AppBar(
    //           title: const Text('Dashboard'),
    //           backgroundColor: Colors.blue[900],
    //           bottom: TabBar(tabs: [
    //             DropdownButton(items: items, onChanged: onChanged),
    //             Tab(
    //               text: 'Drivers',
    //             ),
    //             Tab(
    //               text: 'Students',
    //             ),
    //             Tab(
    //               text: 'Routes',
    //             )
    //           ]),
    //         ),
    //         body:  TabBarView(
    //           children: [
    //             VehicleManagement(),
    //             DriverManagement(),
    //             StudentManagement(),
    //             RoutesManagement(),
    //           ],
    //         )));
    // }
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
              actions: [
                IconButton(
                    onPressed: (() => authData.logout()),
                    icon: Icon(Icons.logout))
              ],
              bottom: const TabBar(
                tabs: [
                  FittedBox(
                    child: Tab(
                      text: 'Home',
                    ),
                  ),
                  FittedBox(
                    child: Tab(
                      text: 'Vehicles',
                    ),
                  ),
                  FittedBox(
                    child: Tab(
                      text: 'Drivers',
                    ),
                  ),
                  FittedBox(
                    child: Tab(
                      text: 'Students',
                    ),
                  ),
                  FittedBox(
                    child: Tab(
                      text: 'Routes',
                    ),
                  )
                ],
              ),
            ),
            drawer: AdminDrawer(),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                AdminMapScreen(),
                VehicleManagement(),
                DriverManagement(),
                StudentManagement(),
                RoutesManagement(),
              ],
            )));
  }
}
