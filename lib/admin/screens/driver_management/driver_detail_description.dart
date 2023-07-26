import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DriverDetailDescription extends StatelessWidget {
  static const routeName = '/driverDetailDescription';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final name = routesArgs['name'];
    final email = routesArgs['email'];
    final cnic = routesArgs['cnic'];
    final phone = routesArgs['phone'];
    final license = routesArgs['liscenseCategory'];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Driver Details'),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
          actions: const [
            Icon(
              Icons.person,
              size: kIsWeb ? 40 : 30,
            )
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Image.asset(
                'assets/images/gift_front2.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.black38,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                height: 130,
                //width: 70,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(top: 20, left: 70, right: 70),
                alignment: Alignment.center,
                //decoration: BoxDecoration(color: Colors.orange),
                child: Column(
                  children: const [
                    Icon(
                      Icons.description,
                      size: 70,
                      color: Colors.white,
                    ),
                    Text(
                      'Driver Details',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(0, 0, 128, 1),
                      Color.fromRGBO(230, 126, 0, 1)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(30)),
                height: kIsWeb ? 350 : 320,
                width: kIsWeb ? 600 : 300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Name:',
                          style: TextStyle(
                              fontSize: kIsWeb ? 22 : 18, color: Colors.white),
                        ),
                        Container(
                          width: kIsWeb ? 250 : 120,
                          height: kIsWeb ? 35 : 30,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: FittedBox(
                              child: Text(routesArgs.isEmpty ? '...' : name)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Email:',
                          style: TextStyle(
                              fontSize: kIsWeb ? 22 : 18, color: Colors.white),
                        ),
                        Container(
                          width: kIsWeb ? 250 : 120,
                          height: kIsWeb ? 35 : 30,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: FittedBox(
                              child: Text(routesArgs.isEmpty ? '...' : email)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CNIC:',
                          style: TextStyle(
                              fontSize: kIsWeb ? 22 : 18, color: Colors.white),
                        ),
                        Container(
                          width: kIsWeb ? 250 : 120,
                          height: kIsWeb ? 35 : 30,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: FittedBox(
                              child: Text(routesArgs.isEmpty ? '...' : cnic)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Phone:',
                          style: TextStyle(
                              fontSize: kIsWeb ? 22 : 18, color: Colors.white),
                        ),
                        Container(
                          width: kIsWeb ? 250 : 120,
                          height: kIsWeb ? 35 : 30,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: FittedBox(
                              child: Text(routesArgs.isEmpty
                                  ? '...'
                                  : '0${phone.toString()}')),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: kIsWeb ? 160 : 100,
                          child: FittedBox(
                            child: Text(
                              'License Category:',
                              style: TextStyle(
                                  fontSize: kIsWeb ? 22 : 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: kIsWeb ? 250 : 120,
                          height: kIsWeb ? 35 : 30,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: FittedBox(
                              child:
                                  Text(routesArgs.isEmpty ? '...' : license)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ));
  }
}
