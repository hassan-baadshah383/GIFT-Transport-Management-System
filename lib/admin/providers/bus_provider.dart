import 'package:flutter/material.dart';
import 'package:gtms/admin/models/bus.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'dart:async';

class BusProvider with ChangeNotifier {
  List<Bus> _busDetail = [];
  List<Bus> _ownBusDetails = [];
  List<Bus> _rentedBusDetails = [];
  List<Bus> _filteredBusDetails = [];

  List<Bus> get busdetail {
    return [..._busDetail];
  }

  List<Bus> get ownBusDetails {
    return [..._ownBusDetails];
  }

  List<Bus> get rentedBusDetails {
    return [..._rentedBusDetails];
  }

  List<Bus> get filteredBusDetails {
    return [..._filteredBusDetails];
  }

  Future<void> deleteBus(String number, String id) async {
    final url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/buses/$id.json';
    await https.delete(Uri.parse(url));
    final index = _busDetail.indexWhere((element) => element.number == number);
    _busDetail.removeAt(index);
    notifyListeners();
  }

  Future<void> addBus(String number, String driver, String route, DateTime date,
      bool isRented) async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/buses.json';
    final responce = await https.post(Uri.parse(url),
        body: json.encode({
          'Bus number': number,
          'driver': driver,
          'route': route,
          'date': DateTime.now().toString(),
          'isRented': isRented.toString()
        }));
    final bus = Bus(
        id: json.decode(responce.body)['name'],
        number: number,
        driver: driver,
        route: route,
        date: date,
        isRented: isRented);
    _busDetail.insert(0, bus);
    notifyListeners();
  }

  Future<void> fetchBusData() async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/buses.json';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body);
    if (extractedData != null && extractedData is Map<String, dynamic>){
      List<Bus> buses = [];
    extractedData.forEach((id, data) {
      buses.add(Bus(
          id: id,
          number: data['Bus number'],
          driver: data['driver'],
          route: data['route'],
          date: DateTime.parse(data['date']),
          isRented: data['isRented'] == 'true'
              ? true
              : data['isRented'] == 'false'
                  ? false
                  : false));
    });
    _busDetail = buses;
    notifyListeners();
    }
  }

  Future<void> updateBus(
      {required String id,
      required String number,
      required String driver,
      required String route,
      required bool isRented}) async {
    final busIndex = _busDetail.indexWhere((element) => element.id == id);
    final url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/buses/$id.json';
    try {
      await https.patch(Uri.parse(url),
          body: json.encode({
            'Bus number': number,
            'driver': driver,
            'route': route,
            'isRented': isRented.toString()
          }));
      final Bus bus = Bus(
          id: id,
          number: number,
          driver: driver,
          route: route,
          date: DateTime.now(),
          isRented: isRented);
      _busDetail[busIndex] = bus;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void ownBuses() {
    List<Bus> buses =
        _busDetail.where((element) => element.isRented == false).toList();
    _ownBusDetails = buses;
  }

  void rentedBuses() {
    List<Bus> buses = _busDetail.where((car) => car.isRented == true).toList();
    _rentedBusDetails = buses;
  }

  void filterSearch(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      final filteredBuses = _busDetail
          .where((element) =>
              element.number
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.route
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.driver
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      _filteredBusDetails = filteredBuses;
      notifyListeners();
    } else {
      _filteredBusDetails = _busDetail;
      notifyListeners();
    }
  }
}
