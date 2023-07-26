import 'package:flutter/material.dart';
import 'package:gtms/admin/screens/driver_management/add_driver_screen.dart';
import 'package:gtms/admin/widgets/driver_details_widget.dart';
import 'package:gtms/driver/models/driver.dart';
import 'package:gtms/driver/providers/drivers.dart';
import 'package:provider/provider.dart';

class DriverDetailsScreen extends StatefulWidget {
  static const routeName = '/driverDetailsScreen';

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
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
    await Provider.of<DriverData>(context, listen: false).fetchDriverData('');
    setState(() {
      _isLoading = false;
    });
  }

  var filter = ['All', 'HTV', 'LTV'];
  String initialValue = 'All';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final driverData = Provider.of<DriverData>(context);
    final driverDetails = driverData.driversData;
    final ltvDriverDetails = driverData.ltvDriverDetails;
    final htvDriverDetails = driverData.htvDriverDetails;
    List<Driver> filteredDrivers = driverData.filteredDriverDetails;

    Widget appBarTitle = const Text('Driver Details');

    if (_showSearchBar) {
      appBarTitle = TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          hintText: 'Search...',
        ),
        onChanged: (String value) {
          driverData.filterSearch(value);
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
                    driverData.filterSearch('');
                    filteredDrivers = [];
                  },
                  icon: const Icon(Icons.close),
                ),
              IconButton(
                  onPressed: (() {
                    Navigator.of(context).pushNamed(AddDriverScreen.routeName);
                  }),
                  icon: const Icon(Icons.add))
            ]),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : driverDetails.isEmpty
                ? const Center(
                    child: Text('No any driver yet. Try adding some!'))
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
                                driverDetails;
                              }
                              if (initialValue == 'HTV') {
                                Provider.of<DriverData>(context, listen: false)
                                    .htvDrivers();
                              }
                              if (initialValue == 'LTV') {
                                Provider.of<DriverData>(context, listen: false)
                                    .ltvDrivers();
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
                                  filteredDrivers.isNotEmpty
                                      ? DriverDetailsWidget(
                                          id: filteredDrivers[index].id,
                                          creatorId:
                                              filteredDrivers[index].creatorId,
                                          name: filteredDrivers[index].name,
                                          email: filteredDrivers[index].email,
                                          password:
                                              filteredDrivers[index].password,
                                          isEnable:
                                              filteredDrivers[index].isEnable,
                                          cnic: filteredDrivers[index].cnic,
                                          phone: filteredDrivers[index].phone,
                                          licenseCategory:
                                              filteredDrivers[index]
                                                  .licenseCategory,
                                        )
                                      : initialValue == 'All'
                                          ? DriverDetailsWidget(
                                              id: driverDetails[index].id,
                                              creatorId: driverDetails[index]
                                                  .creatorId,
                                              name: driverDetails[index].name,
                                              email: driverDetails[index].email,
                                              password:
                                                  driverDetails[index].password,
                                              isEnable:
                                                  driverDetails[index].isEnable,
                                              cnic: driverDetails[index].cnic,
                                              phone: driverDetails[index].phone,
                                              licenseCategory:
                                                  driverDetails[index]
                                                      .licenseCategory,
                                            )
                                          : initialValue == 'HTV'
                                              ? DriverDetailsWidget(
                                                  id: htvDriverDetails[index]
                                                      .id,
                                                  creatorId:
                                                      htvDriverDetails[index]
                                                          .creatorId,
                                                  name: htvDriverDetails[index]
                                                      .name,
                                                  email: htvDriverDetails[index]
                                                      .email,
                                                  password:
                                                      htvDriverDetails[index]
                                                          .password,
                                                  isEnable:
                                                      htvDriverDetails[index]
                                                          .isEnable,
                                                  cnic: htvDriverDetails[index]
                                                      .cnic,
                                                  phone: htvDriverDetails[index]
                                                      .phone,
                                                  licenseCategory:
                                                      htvDriverDetails[index]
                                                          .licenseCategory,
                                                )
                                              : DriverDetailsWidget(
                                                  id: ltvDriverDetails[index]
                                                      .id,
                                                  creatorId:
                                                      ltvDriverDetails[index]
                                                          .creatorId,
                                                  name: ltvDriverDetails[index]
                                                      .name,
                                                  email: ltvDriverDetails[index]
                                                      .email,
                                                  password:
                                                      ltvDriverDetails[index]
                                                          .password,
                                                  isEnable:
                                                      ltvDriverDetails[index]
                                                          .isEnable,
                                                  cnic: ltvDriverDetails[index]
                                                      .cnic,
                                                  phone: ltvDriverDetails[index]
                                                      .phone,
                                                  licenseCategory:
                                                      ltvDriverDetails[index]
                                                          .licenseCategory,
                                                )
                                ],
                              );
                            }),
                            itemCount: filteredDrivers.isNotEmpty
                                ? filteredDrivers.length
                                : initialValue == 'All'
                                    ? driverDetails.length
                                    : initialValue == 'HTV'
                                        ? htvDriverDetails.length
                                        : ltvDriverDetails.length,
                          ),
                        ),
                      ),
                    ],
                  ));
  }
}
