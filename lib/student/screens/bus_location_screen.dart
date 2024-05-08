import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gtms/student/providers/students.dart';
import 'package:provider/provider.dart';
import '/student/widgets/drawer.dart';

class BusLocationScreen extends StatefulWidget {
  static const routeName = '/busLocation';

  @override
  State<BusLocationScreen> createState() => _BusLocationScreenState();
}

class _BusLocationScreenState extends State<BusLocationScreen> {
  late GoogleMapController _mapController;
  late Map<MarkerId, Marker> _markers;
  String busNumber = '';
  String driver = '';

  @override
  void initState() {
    super.initState();
    _markers = <MarkerId, Marker>{};
    initMap();
  }

  Future<void> initMap() async {
    await fetchBusData();
    await _loadMarkers();
  }

  Future<void> fetchBusData() async {
    final stData = await Provider.of<StudentData>(context, listen: false);
    await stData.fetchBusDetails();
    busNumber = await stData.studentBus.first.number;
    driver = stData.studentBus.first.driver;
  }

  _loadMarkers() async {
    final snapshot = await FirebaseDatabase.instance.ref('locations').get();
    final map = snapshot.value as Map<dynamic, dynamic>;

    map.forEach((key, value) {
      if (value['Bus number'] == busNumber) {
        _addMarker(double.parse(value['latitude']),
            double.parse(value['longitude']), value['Bus number']);
      }
    });
  }

  void _addMarker(double lat, double lng, String busNumber) {
    final MarkerId markerId = MarkerId('marker_id_${_markers.length}');
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: 'Bus Number $busNumber',
        snippet: 'Driver: $driver',
      ),
    );
    if (mounted) {
      setState(() {
        _markers[markerId] = marker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
          actions: const [
            Icon(
              Icons.location_pin,
              size: 30,
            )
          ],
          title: const Text('Bus Location')),
      drawer: AppDrawer(),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(32.1617, 74.1883),
          zoom: 10,
        ),
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}
