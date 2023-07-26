import 'package:flutter/material.dart';

import 'package:gtms/driver/providers/drivers.dart';
import 'package:gtms/student/providers/students.dart';
import 'package:provider/provider.dart';

class EditStudentScreen extends StatefulWidget {
  static const routeName = '/editStudentScreen';

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  bool isEdit = true;
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();

  Map<String, Object> newStudentData = {
    'id': '',
    'name': '',
    'rollNo': '',
    'email': '',
    'cnic': '',
    'phone': '',
    'location': '',
  };

  @override
  void didChangeDependencies() {
    if (isEdit) {
      final product =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      if (product != null) {
        newStudentData = {
          'id': product['id'],
          'name': product['name'],
          'rollNo': product['rollNo'],
          'email': product['email'],
          'cnic': product['cnic'],
          'phone': product['phone'],
          'location': product['location'],
        };
      }
    }
    isEdit = false;
    super.didChangeDependencies();
  }

  Future<void> submit() async {
    final validate = _form.currentState.validate();
    _form.currentState.save();
    if (validate) {
      final studData = Provider.of<StudentData>(context, listen: false);

      setState(() {
        _isLoading = true;
      });
      await studData.updateStudent(
        id: newStudentData['id'],
        rollNo: int.parse(newStudentData['rollNo']),
        name: newStudentData['name'],
        cnic: newStudentData['cnic'],
        email: newStudentData['email'],
        phone: int.parse(newStudentData['phone']),
        location: newStudentData['location'],
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Student'),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
          actions: [
            IconButton(
                onPressed: (() {
                  submit();
                }),
                icon: const Icon(Icons.save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: newStudentData['name'],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Name'),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value.length <= 5) {
                        return 'Username is too short!';
                      }
                      return null;
                    },
                    onSaved: ((value) {
                      newStudentData['name'] = value;
                    }),
                  ),
                  TextFormField(
                    initialValue: newStudentData['rollNo'].toString(),
                    decoration: const InputDecoration(labelText: 'Roll No'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Roll No.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newStudentData['rollNo'] = value;
                    },
                  ),
                  TextFormField(
                    initialValue: newStudentData['email'],
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@gift.edu.pk')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newStudentData['email'] = value;
                    },
                  ),
                  TextFormField(
                    initialValue: newStudentData['cnic'],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'CNIC'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your CNIC';
                      }
                      if (value.length != 13) {
                        return 'Please enter a valid CNIC';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      newStudentData['cnic'] = newValue;
                    },
                  ),
                  TextFormField(
                    initialValue: '0${newStudentData['phone'].toString()}',
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone';
                      }
                      if (value.length != 11) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      newStudentData['phone'] = newValue;
                    },
                  ),
                  TextFormField(
                    initialValue: newStudentData['location'],
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your residential area';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      newStudentData['location'] = newValue;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: (() {
                              submit();
                            }),
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                )),
                            child: const Text('Submit')),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
