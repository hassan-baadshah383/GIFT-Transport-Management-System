import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

import '/student/providers/students.dart';
import 'student/models/exception.dart';

class Auth extends StudentData {
  String? tokken;
  DateTime? expiryDate;
  String? userId;
  Timer? authTime;
  //bool isChecked;
  bool isAdmin = false;
  bool isStudent = false;
  bool isDriver = false;
  late BuildContext context;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (expiryDate != null &&
        expiryDate!.isAfter(DateTime.now()) &&
        tokken != null) {
      return tokken;
    }
    return null;
  }

  Future<void> signUpUser(String name, int rollNo, String email,
      String password, int phone, String cnic, String location) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDNqtgTjLOQLiaw_zsZp0rIonsB2GQKJf0';
    try {
      final responce = await https.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      if (json.decode(responce.body)['error'] != null) {
        throw HttpExceptions(json.decode(responce.body)['error']['message']);
      }
      await loginUser(email, password, false, true, false).then((value) =>
          addStudent(
              name, rollNo, email, password, phone, cnic, location, userId!));
    } catch (error) {
      throw error;
    }
  }

  Future<String?> loginUser(String email, String password, bool admin,
      bool student, bool driver) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDNqtgTjLOQLiaw_zsZp0rIonsB2GQKJf0';
    try {
      final responce = await https.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      if (json.decode(responce.body)['error'] != null) {
        throw HttpExceptions(json.decode(responce.body)['error']['message']);
      }
      var responceData = json.decode(responce.body);
      tokken = responceData['idToken'];
      userId = responceData['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responceData['expiresIn'])));
      // print({json.decode(responce.body), 'Responce'});
      // print({userId, 'User Id'});
      // print({tokken, 'Tokken'});

      //isChecked = isCheck;
      isAdmin = admin;
      isStudent = student;
      isDriver = driver;
      notifyListeners();
    } catch (error) {
      print(error);
    }
    return userId;
  }

  Future<bool> checkStudent(String email) async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/students.json';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body);
    if(extractedData != null && extractedData is Map<String, dynamic>){
      bool result = false;
    extractedData.forEach(
      (id, data) {
        if (data['email'] == email) {
          result = true;
        }
      },
    );
    return result;
    }
    return false;
  }

  Future<bool> checkDriver(String email) async {
    const url = 'https://gtms-fd7f3-default-rtdb.firebaseio.com/drivers.json';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body);
    if(extractedData != null && extractedData is Map<String, dynamic>){
      bool result = false;
    extractedData.forEach(
      (id, data) {
        if (data['email'] == email) {
          result = true;
        }
      },
    );
    return result;
    }
    return false;
  }

  Future<void> logout() async {
    tokken = null;
    expiryDate = null;
    userId = null;
    if (authTime != null) {
      authTime!.cancel();
      authTime = null;
    }
    notifyListeners();
  }

  Future<void> disableUserAccount(String uid) async {
    // Replace YOUR_FIREBASE_API_KEY with your Firebase project's API key
    const apiKey = 'AIzaSyDNqtgTjLOQLiaw_zsZp0rIonsB2GQKJf0';

    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey';

    final body = json.encode({
      'localId': uid,
      'disableUser': true,
    });

    try {
      final response = await https.post(Uri.parse(url), body: body);

      if (response.statusCode != 200) {
        throw Exception('Error disabling user account: ${response.body}');
      }
    } catch (e) {
      print("Error disabling user account: $e");
      rethrow;
    }
  }
}
