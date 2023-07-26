import 'package:flutter/material.dart';
import 'package:gtms/admin/models/bus.dart';
import 'package:gtms/admin/providers/bus_provider.dart';
import 'package:provider/provider.dart';

import '/admin/screens/vehicle_management/add_bus_screen.dart';
import '/admin/widgets/bus_detail_widget.dart';

class AdminBusDetailScreen extends StatefulWidget {
  static const routeName = '/adminBusDetailScreen';

  @override
  State<AdminBusDetailScreen> createState() => _AdminBusDetailScreenState();
}

class _AdminBusDetailScreenState extends State<AdminBusDetailScreen> {
  bool _isLoading = false;
  bool _showSearchBar = false;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<BusProvider>(context, listen: false).fetchBusData();
    setState(() {
      _isLoading = false;
    });
  }

  var filter = ['All', 'Own', 'Rented'];
  String initialValue = 'All';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final busData = Provider.of<BusProvider>(context);
    final busDetails = busData.busdetail;
    final ownBusDetails = busData.ownBusDetails;
    final rentedBusDetails = busData.rentedBusDetails;
    List<Bus> filteredBuses = busData.filteredBusDetails;

    Widget appBarTitle = const Text('Bus Details');

    if (_showSearchBar) {
      appBarTitle = TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          hintText: 'Search...',
        ),
        onChanged: (String value) {
          busData.filterSearch(value);
          filteredBuses.forEach((element) {
            print(element.driver);
          });
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
                    busData.filterSearch('');
                    filteredBuses = [];
                    print({filteredBuses.length, 'after close'});
                  },
                  icon: const Icon(Icons.close),
                ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddBusScreen.routeName);
                  },
                  icon: const Icon(Icons.add))
            ]),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : busDetails.isEmpty
                ? const Center(child: Text('No any bus yet. Try adding some!'))
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
                            onChanged: ((String value) {
                              //ownCarDetails;
                              setState(() {
                                initialValue = value;
                              });
                              if (initialValue == 'All') {
                                busDetails;
                              }
                              if (initialValue == 'Own') {
                                Provider.of<BusProvider>(context, listen: false)
                                    .ownBuses();
                              }
                              if (initialValue == 'Rented') {
                                Provider.of<BusProvider>(context, listen: false)
                                    .rentedBuses();
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
                                    filteredBuses.isNotEmpty
                                        ? BusDetailWidget(
                                            id: filteredBuses[index].id,
                                            number: filteredBuses[index].number,
                                            driver: filteredBuses[index].driver,
                                            route: filteredBuses[index].route,
                                            date: filteredBuses[index].date,
                                            isRented:
                                                filteredBuses[index].isRented,
                                          )
                                        : initialValue == 'All'
                                            ? BusDetailWidget(
                                                id: busDetails[index].id,
                                                number:
                                                    busDetails[index].number,
                                                driver:
                                                    busDetails[index].driver,
                                                route: busDetails[index].route,
                                                date: busDetails[index].date,
                                                isRented:
                                                    busDetails[index].isRented,
                                              )
                                            : initialValue == 'Own'
                                                ? BusDetailWidget(
                                                    id: ownBusDetails[index].id,
                                                    number: ownBusDetails[index]
                                                        .number,
                                                    driver: ownBusDetails[index]
                                                        .driver,
                                                    route: ownBusDetails[index]
                                                        .route,
                                                    date: ownBusDetails[index]
                                                        .date,
                                                    isRented:
                                                        ownBusDetails[index]
                                                            .isRented,
                                                  )
                                                : BusDetailWidget(
                                                    id: rentedBusDetails[index]
                                                        .id,
                                                    number:
                                                        rentedBusDetails[index]
                                                            .number,
                                                    driver:
                                                        rentedBusDetails[index]
                                                            .driver,
                                                    route:
                                                        rentedBusDetails[index]
                                                            .route,
                                                    date:
                                                        rentedBusDetails[index]
                                                            .date,
                                                    isRented:
                                                        rentedBusDetails[index]
                                                            .isRented,
                                                  )
                                  ],
                                );
                              }),
                              itemCount: filteredBuses.isNotEmpty
                                  ? filteredBuses.length
                                  : initialValue == 'All'
                                      ? busDetails.length
                                      : initialValue == 'Own'
                                          ? ownBusDetails.length
                                          : rentedBusDetails.length),
                        ),
                      ),
                    ],
                  ));
  }
}
