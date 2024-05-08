import 'package:flutter/material.dart';
import 'package:gtms/admin/providers/car_provider.dart';
import 'package:gtms/admin/providers/routes_provider.dart';
import 'package:gtms/driver/providers/drivers.dart';
import 'package:provider/provider.dart';
import 'dart:async';

enum CarType { own, rented }

class AddCarScreen extends StatefulWidget {
  static const routeName = '/addCarScreen';

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  bool edit = true;
  bool inEditMode = false;
  List<String> routesList = [];
  List<String> finalDrivers = [];
  List<String> emptyList = [];
  bool _isLoading = false;
  bool _isLoadingRoutes = false;
  bool _isLoadingDrivers = false;
  bool _dependenciesFetched = false;
  CarType btype = CarType.own;
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> newCarData = {
    'id': '',
    'number': '',
    'driver': '',
    'route': '',
    'date': DateTime.now().toString(),
    //'isRented': false,
  };

  @override
  void didChangeDependencies() {
    if (!_dependenciesFetched) {
      fetchRoutes();
      fetchDrivers();
      _dependenciesFetched = true;
    }
    if (edit) {
      final product = ModalRoute.of(context)?.settings.arguments;
      if (product != null && product is Map<String, Object>) {
        inEditMode = true;
        newCarData = {
          'id': product['id'],
          'number': product['number'],
          'driver': product['driver'],
          'route': product['route'],
          // 'isRented': product['isRented'],
        };
      }
    }

    edit = false;

    super.didChangeDependencies();
  }

  void fetchRoutes() async {
    setState(() {
      _isLoadingRoutes = true;
    });
    await Provider.of<RoutesProvider>(context, listen: false).fetchRoutesData();
    final List<String> r = [];
    final routes =
        Provider.of<RoutesProvider>(context, listen: false).routesList;
    routes.forEach((element) {
      r.add(element.name);
    });
    setState(() {
      routesList = r;
      _isLoadingRoutes = false;
    });
  }

  void fetchDrivers() async {
    setState(() {
      _isLoadingDrivers = true;
    });
    await Provider.of<DriverData>(context, listen: false).fetchDriverData('');
    final List<String> d = [];
    final drivers = Provider.of<DriverData>(context, listen: false).driversData;
    drivers.forEach((element) {
      d.add(element.name);
    });
    setState(() {
      finalDrivers = d;
      _isLoadingDrivers = false;
    });
  }

  bool get checkType {
    if (btype == CarType.rented) {
      return true;
    }
    return false;
  }

  Future<void> submit() async {
    final validate = _form.currentState!.validate();
    _form.currentState!.save();
    if (validate) {
      final carData = await Provider.of<CarProvider>(context, listen: false);
      if (inEditMode) {
        setState(() {
          _isLoading = true;
        });

        await carData.updateCar(
            id: newCarData['id'],
            driver: newCarData['driver'],
            route: newCarData['route'],
            number: newCarData['number'],
            isRented: checkType);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = true;
        });
        await carData.addCar(newCarData['number'], newCarData['driver'],
            newCarData['route'], DateTime.parse(newCarData['date']), checkType);
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
          title: const Text('Add Car'),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
          actions: [
            IconButton(
                onPressed: (() {
                  submit();
                }),
                icon: const Icon(Icons.save))
          ],
        ),
        body: _isLoadingRoutes || _isLoadingDrivers
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus();
                          },
                          initialValue: newCarData['number'],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.numbers),
                            labelText: 'Car Number',
                          ),
                          onSaved: (newValue) {
                            newCarData['number'] = newValue;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter car number';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: inEditMode ? newCarData['route'] : null,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.route),
                            label: routesList.isEmpty
                                ? const Text(
                                    "No any route. Please add a route.",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : const Text('Select Route'),
                          ),
                          items: routesList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onSaved: (newValue) {
                            newCarData['route'] = newValue;
                          },
                          onChanged: (value) {
                            // setState(() {});
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a route';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: inEditMode ? newCarData['driver'] : null,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.person_add),
                            label: finalDrivers.isEmpty
                                ? const Text(
                                    "No any driver. Please add a driver.",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : const Text('Add Driver'),
                          ),
                          items: finalDrivers
                              .map<DropdownMenuItem<String>>((String name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                          onSaved: (newValue) {
                            newCarData['driver'] = newValue;
                          },
                          onChanged: (value) {
                            // setState(() {});
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a driver';
                            }
                            return null;
                          },
                        ),
                        Column(
                          children: [
                            RadioListTile(
                                title: const Text('Own'),
                                subtitle: const Text('Type'),
                                value: CarType.own,
                                groupValue: btype,
                                onChanged: ((CarType? value) {
                                  setState(() {
                                    btype = value!;
                                  });
                                })),
                            RadioListTile(
                                title: const Text('Rented'),
                                subtitle: const Text('Type'),
                                value: CarType.rented,
                                groupValue: btype,
                                onChanged: ((CarType? value) {
                                  setState(() {
                                    btype = value!;
                                  });
                                }))
                          ],
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
                                  onPressed: submit,
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      shadowColor: Colors.purple,
                                      backgroundColor: Colors.purple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      )),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
