import 'package:flutter/material.dart';
import 'package:gtms/admin/providers/bus_provider.dart';
import 'package:gtms/admin/providers/routes_provider.dart';
import 'package:gtms/driver/providers/drivers.dart';
import 'package:provider/provider.dart';
import 'dart:async';

enum BusType { own, rented }

class AddBusScreen extends StatefulWidget {
  static const routeName = '/addBus';

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  bool isEdit = true;
  bool inEditMode = false;
  List<String> routesList = [];
  List<String> finalDrivers = [];
  List<String> emptyList = [];
  bool isLoading = false;
  bool _isLoadingRoutes = false;
  bool _isLoadingDrivers = false;
  bool _dependenciesFetched = false;
  BusType btype = BusType.own;
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> newBusData = {
    'id': '',
    'number': '',
    'driver': '',
    'route': '',
    'date': DateTime.now().toString(),
  };

  @override
  void didChangeDependencies() {
    if (!_dependenciesFetched) {
      fetchRoutes();
      fetchDrivers();
      _dependenciesFetched = true;
    }

    if (isEdit) {
      final product = ModalRoute.of(context)?.settings.arguments;
      if (product != null && product is Map<String, Object>) {
        inEditMode = true;
        newBusData = {
          'id': product['id'],
          'number': product['number'],
          'driver': product['driver'],
          'route': product['route'],
          //'isRented': false,
        };
      }
    }
    isEdit = false;
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
    if (btype == BusType.rented) {
      return true;
    }
    return false;
  }

  Future<void> submit() async {
    final validate = _form.currentState!.validate();
    _form.currentState!.save();

    if (validate) {
      final busData = Provider.of<BusProvider>(context, listen: false);
      if (inEditMode) {
        setState(() {
          isLoading = true;
        });
        await busData.updateBus(
            id: newBusData['id'],
            driver: newBusData['driver'],
            route: newBusData['route'],
            number: newBusData['number'],
            isRented: checkType);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          isLoading = true;
        });
        await busData.addBus(newBusData['number'], newBusData['driver'],
            newBusData['route'], DateTime.parse(newBusData['date']), checkType);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Bus'),
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
                          initialValue: newBusData['number'],
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus();
                          },
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.numbers),
                            labelText: 'Bus Number',
                          ),
                          onSaved: (newValue) {
                            newBusData['number'] = newValue;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter bus number';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: inEditMode ? newBusData['route'] : null,
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
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a route';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            newBusData['route'] = newValue;
                          },
                          onChanged: (String? value) {
                            // setState(() {
                            // newBusData['route'] = value;
                            // });
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: inEditMode ? newBusData['driver'] : null,
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
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a driver';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            newBusData['driver'] = newValue;
                          },
                          onChanged: (String? value) {
                            // setState(() {
                            //   // newBusData['driver'] = value;
                            // });
                          },
                        ),
                        Column(
                          children: [
                            RadioListTile(
                                title: const Text('Own'),
                                subtitle: const Text('Type'),
                                value: BusType.own,
                                groupValue: btype,
                                onChanged: ((BusType? value) {
                                  setState(() {
                                    btype = value!;
                                  });
                                })),
                            RadioListTile(
                                title: const Text('Rented'),
                                subtitle: const Text('Type'),
                                value: BusType.rented,
                                groupValue: btype,
                                onChanged: ((BusType? value) {
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
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: (() {
                                    submit();
                                  }),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      backgroundColor: Colors.purple,
                                      shadowColor: Colors.purple,
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
