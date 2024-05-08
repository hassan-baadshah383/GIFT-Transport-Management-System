import 'package:flutter/material.dart';
import 'package:gtms/admin/models/car.dart';
import 'package:gtms/admin/providers/car_provider.dart';
import 'package:gtms/admin/screens/vehicle_management/add_car_screen.dart';
import 'package:provider/provider.dart';

//import 'package:gtms/admin/providers/dummy_car_data.dart';
import 'package:gtms/admin/widgets/car_details_widget.dart';

class CarDetailScreen extends StatefulWidget {
  static const routeName = '/carDetailScreen';

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  bool _isLoading = false;
  bool _showSearchBar = false;
  @override
  void initState() {
    fetchCarData();
    super.initState();
  }

  void fetchCarData() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<CarProvider>(context, listen: false).fetchCarData().then(
      (value) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  var filter = ['All', 'Own', 'Rented'];
  String initialValue = 'All';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final carData = Provider.of<CarProvider>(context);
    final List<Car> carDetails = carData.cardetail;
    final ownCarDetails = carData.ownCarDetails;
    final rentedCarDetails = carData.rentedCarDetails;
    List<Car> filteredCars = carData.filteredCarDetails;

    Widget appBarTitle = const Text('Car Details');

    if (_showSearchBar) {
      appBarTitle = TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          hintText: 'Search...',
        ),
        onChanged: (String value) {
          carData.filterSearch(value);
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
            title: appBarTitle,
            backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
            actions: [
              if (!_showSearchBar)
                IconButton(
                    onPressed: (() {
                      setState(() {
                        _showSearchBar = true;
                      });
                    }),
                    icon: const Icon(Icons.search)),
              if (_showSearchBar)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showSearchBar = false;
                    });
                    carData.filterSearch('');
                    filteredCars = [];
                    print({filteredCars.length, 'after close'});
                  },
                  icon: const Icon(Icons.close),
                ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddCarScreen.routeName);
                  },
                  icon: const Icon(Icons.add)),
            ]),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : carDetails.isEmpty
                ? const Center(child: Text('No any car yet. Try adding some!'))
                : Column(
                    children: [
                      Container(
                        width: deviceSize.width * 0.2,
                        child: DropdownButton(
                            isExpanded: true,
                            value: initialValue,
                            items: filter.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                ),
                              );
                            }).toList(),
                            onChanged: ((String? value) {
                              //ownCarDetails;
                              setState(() {
                                initialValue = value!;
                              });
                              if (initialValue == 'All') {
                                carDetails;
                              }
                              if (initialValue == 'Own') {
                                Provider.of<CarProvider>(context, listen: false)
                                    .ownCars();
                              }
                              if (initialValue == 'Rented') {
                                Provider.of<CarProvider>(context, listen: false)
                                    .rentedCars();
                              }
                            })),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView.builder(
                              itemBuilder: ((context, index) {
                                return Column(
                                  children: [
                                    filteredCars.isNotEmpty
                                        ? CarDetailWidget(
                                            id: filteredCars[index].id,
                                            number: filteredCars[index].number,
                                            driver: filteredCars[index].driver,
                                            route: filteredCars[index].route,
                                            date: filteredCars[index].date,
                                            isRented:
                                                filteredCars[index].isRented,
                                          )
                                        : initialValue == 'All'
                                            ? CarDetailWidget(
                                                id: carDetails[index].id,
                                                number:
                                                    carDetails[index].number,
                                                driver:
                                                    carDetails[index].driver,
                                                route: carDetails[index].route,
                                                date: carDetails[index].date,
                                                isRented:
                                                    carDetails[index].isRented,
                                              )
                                            : initialValue == 'Own'
                                                ? CarDetailWidget(
                                                    id: ownCarDetails[index].id,
                                                    number: ownCarDetails[index]
                                                        .number,
                                                    driver: ownCarDetails[index]
                                                        .driver,
                                                    route: ownCarDetails[index]
                                                        .route,
                                                    date: ownCarDetails[index]
                                                        .date,
                                                    isRented:
                                                        ownCarDetails[index]
                                                            .isRented,
                                                  )
                                                : CarDetailWidget(
                                                    id: rentedCarDetails[index]
                                                        .id,
                                                    number:
                                                        rentedCarDetails[index]
                                                            .number,
                                                    driver:
                                                        rentedCarDetails[index]
                                                            .driver,
                                                    route:
                                                        rentedCarDetails[index]
                                                            .route,
                                                    date:
                                                        rentedCarDetails[index]
                                                            .date,
                                                    isRented:
                                                        rentedCarDetails[index]
                                                            .isRented,
                                                  )
                                  ],
                                );
                              }),
                              itemCount: filteredCars.isNotEmpty
                                  ? filteredCars.length
                                  : initialValue == 'All'
                                      ? carDetails.length
                                      : initialValue == 'Own'
                                          ? ownCarDetails.length
                                          : rentedCarDetails.length),
                        ),
                      ),
                    ],
                  ));
  }
}
