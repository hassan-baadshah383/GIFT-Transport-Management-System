import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gtms/auth.dart';
import 'package:gtms/driver/providers/drivers.dart';
import 'package:gtms/driver/screens/driver_profile_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import '../widgets/dashboard_items.dart';
import '../providers/dummy_driver_data.dart';
// import '../models/auth.dart';

class DriverDashboardScreen extends StatefulWidget {
  static const routeName = '/productOverviewScreen';
  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  String latitude = '';
  String longitude = '';
  String driverBus = '';
  bool _isLoading = false;
  @override
  void initState() {
    fetchData();
    requestLocationPermission();
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      _getLocation();
    });
    super.initState();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    final userId = await Provider.of<Auth>(context, listen: false).userId;
    final driversData = await Provider.of<DriverData>(context, listen: false);
    await driversData.fetchDriverData(userId, true);
    await driversData.fetchBusDetails(driversData.driversData.first.name);
    driverBus =
        driversData.driverBus.isEmpty ? '' : driversData.driverBus.first.number;
    bool isEnable =
        await Provider.of<DriverData>(context, listen: false).isEnable;
    setState(() {
      _isLoading = false;
    });
    if (!isEnable) {
      _alertDialogueBox();
    }
  }

  void _getLocation() async {
    try {
      requestLocationPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
          _sendLocation();
        });
      }
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        print(e);
      }
    }
  }

  Future<void> requestLocationPermission() async {
    try {
      var status = await Permission.location.request();

      if (status.isGranted) {
        // Permission granted, do something
      } else {
        // Permission denied, show error message
      }
    } catch (error) {
      print({error, 'Error request'});
    }
  }

  void _sendLocation() {
    final authId = Provider.of<Auth>(context, listen: false).userId;
    final databaseReference = FirebaseDatabase.instance.reference();
    print({driverBus, 'driver Bus'});
    databaseReference.child('locations').child(authId).set({
      'latitude': latitude,
      'longitude': longitude,
      'Bus number': driverBus
    });
  }

  void _alertDialogueBox() {
    Future.delayed(Duration.zero, () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.warning),
                  Text('Alert'),
                ],
              ),
              content: const Text('You are suspended temporarily.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                    child: const Text('Ok'))
              ],
            );
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Navigator.of(context).pushNamed(
                      DriverProfile.routeName,
                    ))
          ],
          title: const Text(
            'Dashboard',
          ),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  SizedBox(
                    height: 600,
                    width: kIsWeb ? 1500 : 500,
                    child: Image.asset(
                      'assets/images/gift_front.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.black45,
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        height: 50,
                        child: const Text(
                          'GIFT Transport System',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: kIsWeb
                            ? EdgeInsets.only(right: 500, left: 500)
                            : EdgeInsets.only(),
                        child: GridView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(15),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisExtent: 150,
                                  childAspectRatio: 3 / 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          children: DriverActionData()
                              .dummyStudentList
                              .map((item) => DashboardItems(item.title,
                                  item.icon, item.route, item.color))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
  }
}
