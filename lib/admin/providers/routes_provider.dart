import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'dart:async';
import 'dart:convert';

import 'package:gtms/admin/models/route.dart';

class RoutesProvider with ChangeNotifier {
  List<RouteClass> _routesList = [];
  List<RouteClass> _filteredRoutesDetails = [];

  List<RouteClass> get routesList {
    return [..._routesList];
  }

  List<RouteClass> get filteredRoutesList {
    return [..._filteredRoutesDetails];
  }

  Future<void> addRoute(String nam) async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/routes.json';
    final responce = await https.post(Uri.parse(url),
        body: json.encode({
          'name': nam,
        }));
    final route = RouteClass(id: json.decode(responce.body)['name'], name: nam);
    _routesList.insert(0, route);
    notifyListeners();
  }

  Future<void> fetchRoutesData() async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/routes.json';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body);
    if (extractedData != null && extractedData is Map<String, dynamic>) {
      List<RouteClass> r = [];
    extractedData.forEach((i, data) {
      r.add(RouteClass(id: i, name: data['name']));
      _routesList = r;
      notifyListeners();
    });
    }
  }

  Future<void> deleteRoute(String nam, String id) async {
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/routes/$id.json';
    await https.delete(Uri.parse(url));
    final index = _routesList.indexWhere((element) => element.name == nam);
    _routesList.removeAt(index);
    notifyListeners();
  }

  Future<void> updateRoute(String id, String name) async {
    final routeIndex = _routesList.indexWhere((element) => element.id == id);
    final url =
        'https://gtms-fd7f3-default-rtdb.firebaseio.com/routes/$id.json';
    await https.patch(Uri.parse(url),
        body: json.encode({
          'name': name,
        }));

    final r = RouteClass(id: id, name: name);
    _routesList[routeIndex] = r;
    notifyListeners();
  }

  void filterSearch(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      final filteredCars = _routesList
          .where((element) =>
              element.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      _filteredRoutesDetails = filteredCars;
      notifyListeners();
    } else {
      _filteredRoutesDetails = _routesList;
      notifyListeners();
    }
  }
}
