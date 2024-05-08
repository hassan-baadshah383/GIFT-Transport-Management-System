import 'package:flutter/material.dart';
import 'package:gtms/driver/providers/drivers.dart';
import 'package:provider/provider.dart';

class AddDriverScreen extends StatefulWidget {
  static const routeName = '/addDriverScreen';

  @override
  State<AddDriverScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddDriverScreen> {
  bool isEdit = true;
  bool inEditMode = false;
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> newDriverData = {
    'id': '',
    'name': '',
    'email': '',
    'password': '',
    'liscense': '',
    'phone': '',
    'cnic': '',
    'isEnable': '',
    'date': DateTime.now().toString(),
  };

  final List<String> liscenseList = ['LTV', 'HTV'];
  String initialLiscense = '';

  @override
  void didChangeDependencies() {
    if (isEdit) {
      final product =
          ModalRoute.of(context)?.settings.arguments;
          print('$product Hello');
      if(product != null && product is Map<String, Object>){
        inEditMode = true;
      newDriverData = {
        'id': product['id'],
        'name': product['name'],
        'email': product['email'],
        'password': product['password'],
        'liscense': product['liscenseCategory'],
        'phone': product['phone'],
        'cnic': product['cnic'],
        'isEnable': product['isEnable'].toString()
      };
      }
        }
    isEdit = false;
    super.didChangeDependencies();
  }

  Future<void> submit() async {
    final validate = _form.currentState?.validate();
    _form.currentState?.save();
    if (validate != null && validate) {
      final driverData = Provider.of<DriverData>(context, listen: false);
      if (inEditMode) {
        setState(() {
          _isLoading = true;
        });
        await driverData.updateDriver(
          newDriverData['id'],
          newDriverData['name'],
          newDriverData['email'],
          newDriverData['password'],
          newDriverData['liscense'],
          int.parse(newDriverData['phone']),
          newDriverData['cnic'],
          newDriverData['isEnable'] == 'true' ? true : false,
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = true;
        });
        late String userId;
        await driverData.SignUpDriver(
                newDriverData['email'], newDriverData['password'])
            .then((value) => userId = value);
        await driverData.addDriver(
          newDriverData['name'],
          newDriverData['email'],
          newDriverData['password'],
          newDriverData['cnic'],
          int.parse(newDriverData['phone']),
          newDriverData['liscense'],
          userId,
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Driver'),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
          actions: [
            IconButton(onPressed: (() {}), icon: const Icon(Icons.save))
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
                    initialValue: newDriverData['name'],
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Name',
                    ),
                    onSaved: (newValue) {
                      newDriverData['name'] = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newDriverData['email'],
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    onSaved: (newValue) {
                      newDriverData['email'] = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a email';
                      } else if (!value.contains('@gift.edu.pk')) {
                        return 'Please use a valid domain';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newDriverData['password'],
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: 'Password',
                    ),
                    onSaved: (newValue) {
                      newDriverData['password'] = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newDriverData['password'],
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please password again';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: inEditMode ? newDriverData['liscense'] : null,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.car_rental_rounded),
                      label: Text('Liscense Category'),
                    ),
                    items: liscenseList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onSaved: (newValue) {
                      newDriverData['liscense'] = newValue;
                    },
                    onChanged: (String? value) {
                      setState(() {
                        initialLiscense = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a license';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: inEditMode
                        ? '0${newDriverData['phone'].toString()}'
                        : newDriverData['phone'].toString(),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: 'Phone',
                    ),
                    onSaved: (newValue) {
                      newDriverData['phone'] = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a phone';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newDriverData['cnic'],
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: 'CNIC',
                    ),
                    onSaved: (newValue) {
                      newDriverData['cnic'] = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a CNIC';
                      }
                      return null;
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
                                shadowColor: Colors.purple,
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                )),
                            child: const Text('Submit', style: TextStyle(color: Colors.white),)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
