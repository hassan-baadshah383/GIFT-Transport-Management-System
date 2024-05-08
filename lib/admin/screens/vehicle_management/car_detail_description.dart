import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

class CarDetailDescription extends StatelessWidget {
  static const routeName = '/carDetailDescription';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final details =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final String carNumber = details['number'].toString();
    final String carDriver = details['driver'].toString();
    final String carRoute = details['route'].toString();
    final carDate = details['date'];
    final carIsRented = details['isRented'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Detail Description'),
        backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
        actions: const [
          Icon(
            Icons.directions_car,
            size: kIsWeb ? 40 : 30,
          ),
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
                    'Bus Details',
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
                        'Car Number:',
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
                            child: Text(
                          details.isEmpty ? '...' : carNumber,
                        )),
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
                        'Route:',
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
                            child: Text(details.isEmpty ? '...' : carRoute)),
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
                        'Driver:',
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
                            child: Text(details.isEmpty ? '...' : carDriver)),
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
                        'Date :',
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
                            child: Text(details.isEmpty
                                ? '...'
                                : DateFormat.yMMMMd().format(carDate as DateTime))),
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
                        'Rented :',
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
                            child: Text(details.isEmpty
                                ? '...'
                                : carIsRented == true
                                    ? 'Yes'
                                    : 'No')),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
