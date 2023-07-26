import 'package:flutter/material.dart';
import 'package:gtms/admin/models/bus.dart';
import 'package:gtms/auth.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

import 'package:gtms/driver/models/driver.dart';

class DriverData with ChangeNotifier {
  List<Driver> _driversData = [
    //Driver('id', 'name', 'email', 'password', 'cnic', 2987, 'ejfn')
  ];
  List<Driver> _ltvDriverDetails = [];
  List<Driver> _htvDriverDetails = [];
  List<Driver> _filteredDriverDetails = [];
  List<Bus> _driverBus = [];

  List<Driver> get driversData {
    return [..._driversData];
  }

  List<Bus> get driverBus {
    return [..._driverBus];
  }

  List<Driver> get ltvDriverDetails {
    return [..._ltvDriverDetails];
  }

  List<Driver> get htvDriverDetails {
    return [..._htvDriverDetails];
  }

  List<Driver> get filteredDriverDetails {
    return [..._filteredDriverDetails];
  }

  Future<String> SignUpDriver(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDNqtgTjLOQLiaw_zsZp0rIonsB2GQKJf0';
    await https.post(Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    String userId;
    await Auth().loginUser(email, password, false, false, true).then((value) {
      userId = value;
    });
    return userId;
  }

  Future<void> deleteDriver(String cnic, String id) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/drivers/$id.json';
    await https.delete(Uri.parse(url));
    final index = _driversData.indexWhere((element) => element.cnic == cnic);
    _driversData.removeAt(index);
    notifyListeners();
  }

  Future<void> addDriver(
    String name,
    String email,
    String password,
    String cnic,
    int phone,
    String licenseCategory,
    String userId,
  ) async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/drivers.json';
    final responce = await https.post(Uri.parse(url),
        body: json.encode({
          'name': name,
          'email': email,
          'cnic': cnic,
          'phone': phone,
          'licenseCategory': licenseCategory,
          'password': password,
          'creatorId': userId,
          'isEnable': true,
        }));
    final driver = Driver(
        id: json.decode(responce.body)['name'],
        creatorId: userId,
        name: name,
        email: email,
        password: password,
        cnic: cnic,
        phone: phone,
        licenseCategory: licenseCategory,
        isEnable: true);
    _driversData.insert(0, driver);
    notifyListeners();
  }

  Future<void> fetchDriverData(String userId,
      [bool isDriverDashboard = false]) async {
    final isDriver =
        isDriverDashboard ? '?orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/drivers.json$isDriver';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    List<Driver> drivers = [];
    extractedData.forEach((key, data) {
      drivers.add(Driver(
          id: key,
          creatorId: data['creatorId'],
          name: data['name'],
          email: data['email'],
          password: data['password'],
          cnic: data['cnic'],
          phone: data['phone'],
          licenseCategory: data['licenseCategory'],
          isEnable: data['isEnable']));
    });
    _driversData = drivers;
    notifyListeners();
  }

  Future<void> fetchBusDetails(String name) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/buses.json?orderBy="driver"&equalTo="$name"';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    List<Bus> bus = [];
    extractedData.forEach((key, data) {
      bus.add(Bus(
          id: key,
          number: data['Bus number'],
          driver: data['driver'],
          route: data['route'],
          date: DateTime.parse(data['date']),
          isRented: data['isRented'] == 'true' ? true : false));
    });
    _driverBus = bus;
    notifyListeners();
  }

  Future<void> updateDriver(
      String id,
      String name,
      String email,
      String password,
      String license,
      int phone,
      String cnic,
      bool isEnable) async {
    final driverIndex = _driversData.indexWhere((element) => element.id == id);
    print({phone, 'updatePhone'});
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/drivers/$id.json';
    await https.patch(Uri.parse(url),
        body: json.encode({
          'cnic': cnic,
          'email': email,
          'licenseCategory': license,
          'phone': phone,
          'name': name,
          'password': password,
        }));
    final Driver driver = Driver(
      id: id,
      name: name,
      email: email,
      password: password,
      cnic: cnic,
      phone: phone,
      licenseCategory: license,
      isEnable: isEnable,
    );
    _driversData[driverIndex] = driver;
    notifyListeners();
  }

  void htvDrivers() {
    List driver = _driversData
        .where((driver) => driver.licenseCategory == 'HTV')
        .toList();
    _htvDriverDetails = driver;
  }

  void ltvDrivers() {
    List driver = _driversData
        .where((driver) => driver.licenseCategory == 'LTV')
        .toList();
    _ltvDriverDetails = driver;
  }

  bool get isEnable {
    return _driversData.isEmpty ? true : _driversData.first.isEnable;
  }

  void filterSearch(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      final filteredCars = _driversData
          .where((element) =>
              element.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.licenseCategory
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.phone.toString().contains(enteredKeyword.toLowerCase()))
          .toList();
      _filteredDriverDetails = filteredCars;
      notifyListeners();
    } else {
      _filteredDriverDetails = _driversData;
      notifyListeners();
    }
  }

  Future<void> updateDriverStatus(String id, bool isEnable) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/drivers/$id.json';
    final response = await https.patch(Uri.parse(url),
        body: json.encode({
          'isEnable': isEnable,
        }));
    print({json.decode(response.body), 'Update Driver Status Response..'});
  }
}
