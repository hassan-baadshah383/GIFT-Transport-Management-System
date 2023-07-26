import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import 'package:gtms/driver/providers/drivers.dart';
import '/auth.dart';
import '../screens/bus_details_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final driverData = Provider.of<DriverData>(context).driversData;
    return Drawer(
      width: kIsWeb ? 400 : 270,
      child: ListView(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(0, 0, 128, 1),
            Color.fromRGBO(0, 0, 128, 1),
            Color.fromRGBO(230, 126, 0, 1),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: DrawerHeader(
              decoration: const BoxDecoration(
                  //color: Colors.blue,
                  ),
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
                        driverData.isEmpty ? '' : driverData.first.name,
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
            Navigator.of(context).pushNamed(DriverBusDetailsScreen.routeName);
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
