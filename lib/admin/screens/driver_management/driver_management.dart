import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:gtms/admin/screens/driver_management/driver_details_screen.dart';

class DriverManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        !kIsWeb
            ? SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Image.asset('assets/images/driver_person.jpg',
                    fit: BoxFit.cover),
              )
            : SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Image.asset('assets/images/driver_management_web.jpg',
                    fit: BoxFit.cover)),
        Container(
          color: Colors.black38,
        ),
        Column(
          children: [
            Container(
              decoration: kIsWeb
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black54,
                    )
                  : BoxDecoration(
                      color: Colors.black54,
                    ),
              margin: const EdgeInsets.only(top: 20),
              height: 50,
              width: !kIsWeb ? double.infinity : deviceSize.width * 0.4,
              child: const Center(
                  child: Text(
                'Driver Management',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(
              height: 90,
            ),
            Card(
              margin: kIsWeb
                  ? EdgeInsets.only(left: 100, right: 100)
                  : EdgeInsets.only(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              elevation: 5,
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 128, 1),
                          Color.fromRGBO(230, 126, 0, 1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Driver details',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context)
                      .pushNamed(DriverDetailsScreen.routeName),
                ),
              ),
            ),
            //ElevatedButton(onPressed: (() {}), child: Text('Add Vehicle'))
          ],
        ),
      ],
    );
  }
}
