import 'package:flutter/material.dart';
import 'package:gtms/driver/providers/drivers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DriverBusDetailsScreen extends StatefulWidget {
  static const routeName = '/driverBusDetails';

  @override
  State<DriverBusDetailsScreen> createState() => _DriverBusDetailsScreenState();
}

class _DriverBusDetailsScreenState extends State<DriverBusDetailsScreen> {
  bool _isLoading = false;

  // @override
  // void initState() {
  //   fetchBusData();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    fetchBusData();
    super.didChangeDependencies();
  }

  void fetchBusData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final driversData =
          await Provider.of<DriverData>(context, listen: false).driversData;
      await Provider.of<DriverData>(context, listen: false)
          .fetchBusDetails(driversData.first.name);
    } catch (error) {
      print({error, 'fetchdata'});
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final busDetails =
        Provider.of<DriverData>(context, listen: false).driverBus;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Details'),
        backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
        actions: const [
          Icon(
            Icons.directions_bus,
            size: kIsWeb ? 40 : 30,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
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
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 130,
                        padding: const EdgeInsets.all(15),
                        margin:
                            const EdgeInsets.only(top: 20, left: 70, right: 70),
                        alignment: Alignment.center,
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
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(0, 0, 128, 1),
                                  Color.fromRGBO(230, 126, 0, 1)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        padding: const EdgeInsets.all(25),
                        height: kIsWeb ? 350 : 320,
                        width: kIsWeb ? 600 : 300,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Bus Number:',
                                  style: TextStyle(
                                      fontSize: kIsWeb ? 22 : 18,
                                      color: Colors.white),
                                ),
                                Container(
                                  width: kIsWeb ? 250 : 120,
                                  height: kIsWeb ? 35 : 30,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Text(busDetails.isEmpty
                                          ? '...'
                                          : busDetails.first.number)),
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
                                      fontSize: kIsWeb ? 22 : 18,
                                      color: Colors.white),
                                ),
                                Container(
                                  width: kIsWeb ? 250 : 120,
                                  height: kIsWeb ? 35 : 30,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Text(busDetails.isEmpty
                                          ? '...'
                                          : busDetails.first.route)),
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
                                      fontSize: kIsWeb ? 22 : 18,
                                      color: Colors.white),
                                ),
                                Container(
                                  width: kIsWeb ? 250 : 120,
                                  height: kIsWeb ? 35 : 30,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Text(busDetails.isEmpty
                                          ? '...'
                                          : busDetails.first.driver)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
    );
  }
}
