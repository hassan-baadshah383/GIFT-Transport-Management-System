import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import './routes_details_screen.dart';

class RoutesManagement extends StatelessWidget {
  const RoutesManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        !kIsWeb
            ? SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child:
                    Image.asset('assets/images/route2.jpg', fit: BoxFit.cover),
              )
            : SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Image.asset(
                  'assets/images/route2.jpg',
                  fit: BoxFit.cover,
                ),
              ),
        Container(
          color: Colors.black26,
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
                'Routes Management',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
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
                          Color.fromRGBO(230, 126, 0, 1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: ListTile(
                    leading: const Icon(
                      Icons.route_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Routes details',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                    ),
                    onTap: (() {
                      Navigator.of(context)
                          .pushNamed(RoutesDetailsScreen.routeName);
                    })),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
