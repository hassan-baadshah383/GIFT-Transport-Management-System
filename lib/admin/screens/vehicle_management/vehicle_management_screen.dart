import 'package:flutter/material.dart';

import '/admin/screens/vehicle_management/car_detail_screen.dart';
import '/admin/screens/vehicle_management/bus_detail_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class VehicleManagement extends StatelessWidget {
  const VehicleManagement({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        !kIsWeb
            ? SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Image.asset('assets/images/gift_bus.jpg',
                    fit: BoxFit.cover),
              )
            : SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Image.asset('assets/images/vehicle_management_web.jpg',
                    fit: BoxFit.cover),
              ),
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
                  'Vehicle Management',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
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
                          Color.fromRGBO(230, 126, 0, 1)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: ListTile(
                  leading: const Icon(
                    Icons.directions_car_filled_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Cars details',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context)
                      .pushNamed(CarDetailScreen.routeName),
                ),
              ),
            ),
            Card(
              margin: kIsWeb
                  ? EdgeInsets.only(left: 100, right: 100, top: 10)
                  : EdgeInsets.only(top: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Colors.amber[900],
              elevation: 5,
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 128, 1),
                          Color.fromRGBO(230, 126, 0, 1)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: ListTile(
                  leading: const Icon(
                    Icons.directions_bus_filled_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Bus details',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context)
                      .pushNamed(AdminBusDetailScreen.routeName),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
