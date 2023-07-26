import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import '../../auth.dart';

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              //decoration: const BoxDecoration(),
              child: Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Column(
              children: const [
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 80,
                ),
                Text(
                  'Admin Portal',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                )
              ],
              // Text(
              //   "Your Portal",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 30,
              //   ),
              // ),
            ),
          )),
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
