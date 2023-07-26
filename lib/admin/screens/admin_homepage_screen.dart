import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AdminMapScreen extends StatefulWidget {
  @override
  _AdminMapScreenState createState() => _AdminMapScreenState();
}

class _AdminMapScreenState extends State<AdminMapScreen> {
  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = <MarkerId, Marker>{};
    _loadMarkers();
  }

  _loadMarkers() async {
    if (!kIsWeb) {
      final snapshot = await FirebaseDatabase.instance.ref('locations').get();

      final map = snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        final busNumber = value['Bus number'];
        print(busNumber);
        _addMarker(double.parse(value['latitude']),
            double.parse(value['longitude']), busNumber);
      });
    }
  }

  void _addMarker(double lat, double lng, String busNumber) {
    final MarkerId markerId = MarkerId('marker_id_${_markers.length}');
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: 'Bus Number $busNumber',
        snippet: 'Lat: $lat, Lng: $lng',
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
