import 'package:flutter/cupertino.dart';
import 'package:gtms/admin/models/car.dart';
import 'package:http/http.dart' as https;

import 'dart:convert';
import 'dart:async';

class CarProvider with ChangeNotifier {
  List<Car> _carDetail = [];
  List<Car> _ownCarDetails = [];
  List<Car> _rentedCarDetails = [];
  List<Car> _filteredCarDetails = [];

  List<Car> get cardetail {
    return [..._carDetail];
  }

  List<Car> get ownCarDetails {
    return [..._ownCarDetails];
  }

  List<Car> get rentedCarDetails {
    return [..._rentedCarDetails];
  }

  List<Car> get filteredCarDetails {
    return [..._filteredCarDetails];
  }

  Future<void> deleteCar(String number, String id) async {
    final url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/cars/$id.json';
    await https.delete(Uri.parse(url));
    final index = _carDetail.indexWhere((element) => element.number == number);
    _carDetail.removeAt(index);
    notifyListeners();
  }

  Future<void> addCar(String number, String driver, String route, DateTime date,
      bool isRented) async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/cars.json';
    final responce = await https.post(Uri.parse(url),
        body: json.encode({
          'Car number': number,
          'driver': driver,
          'route': route,
          'date': DateTime.now().toString(),
          'isRented': isRented.toString()
        }));
    final car = Car(
        id: json.decode(responce.body)['name'],
        number: number,
        driver: driver,
        route: route,
        date: date,
        isRented: isRented);
    _carDetail.insert(0, car);
    notifyListeners();
  }

  Future<void> fetchCarData() async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/cars.json';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body);
    if (extractedData != null && extractedData is Map<String, dynamic>){
      List<Car> cars = [];
    extractedData.forEach((id, data) {
      cars.add(Car(
          id: id,
          number: data['Car number'],
          driver: data['driver'],
          route: data['route'],
          date: DateTime.parse(data['date']),
          isRented: data['isRented'] == 'true'
              ? true
              : data['isRented'] == 'false'
                  ? false
                  : false));
    });
    _carDetail = cars;
    notifyListeners();
    }
  }

  Future<void> updateCar(
      {required String id,
      required String number,
      required String driver,
      required String route,
      required bool isRented}) async {
    final carIndex = _carDetail.indexWhere((element) => element.id == id);
    final url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/cars/$id.json';
    await https.patch(Uri.parse(url),
        body: json.encode({
          'Car number': number,
          'driver': driver,
          'route': route,
          'isRented': isRented.toString()
        }));
    final Car car = Car(
        id: id,
        number: number,
        driver: driver,
        route: route,
        date: DateTime.now(),
        isRented: isRented);
    _carDetail[carIndex] = car;
    notifyListeners();
  }

  void ownCars() {
    List<Car> cars =
        _carDetail.where((element) => element.isRented == false).toList();
    _ownCarDetails = cars;
  }

  void rentedCars() {
    List<Car> cars = _carDetail.where((car) => car.isRented == true).toList();
    _rentedCarDetails = cars;
  }

  void filterSearch(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      final filteredCars = _carDetail
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
      _filteredCarDetails = filteredCars;
      notifyListeners();
    } else {
      _filteredCarDetails = _carDetail;
      notifyListeners();
    }
  }
}
