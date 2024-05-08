import 'package:flutter/material.dart';
import 'package:gtms/admin/screens/driver_management/add_driver_screen.dart';

import 'package:gtms/admin/screens/driver_management/driver_detail_description.dart';
import 'package:gtms/driver/providers/drivers.dart';
import 'package:provider/provider.dart';

class DriverDetailsWidget extends StatefulWidget {
  String id;
  String creatorId;
  String name;
  String email;
  String password;
  String licenseCategory;
  bool isEnable;
  int phone;
  String cnic;

  DriverDetailsWidget({
    required this.id,
    required this.creatorId,
    required this.name,
    required this.email,
    required this.password,
    required this.isEnable,
    required this.cnic,
    required this.phone,
    required this.licenseCategory,
  });

  @override
  State<DriverDetailsWidget> createState() => _DriverDetailsWidgetState();
}

class _DriverDetailsWidgetState extends State<DriverDetailsWidget> {
  bool _isLoading = false;
  //bool _isEnable = true;
  @override
  Widget build(BuildContext context) {
    final driverData = Provider.of<DriverData>(context, listen: false);
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(DriverDetailDescription.routeName, arguments: {
            'name': widget.name,
            'email': widget.email,
            'password': widget.password,
            'cnic': widget.cnic,
            'phone': widget.phone,
            'liscenseCategory': widget.licenseCategory,
          });
        },
        leading: const CircleAvatar(
            child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),
        )),
        title: Text(widget.name),
        subtitle: Text(widget.licenseCategory.toString()),
        trailing: FittedBox(
            child: Row(
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: (() async {
                      setState(() {
                        _isLoading = true;
                      });
                      // await driverData
                      //     .deleteDriver(widget.cnic, widget.id)
                      //     .then((_) {
                      //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      //   ScaffoldMessenger.of(context)
                      //       .showSnackBar(const SnackBar(
                      //           content: Text(
                      //     'Driver Deleted!',
                      //     textAlign: TextAlign.center,
                      //   )));
                      // });
                      if (!widget.isEnable) {
                        widget.isEnable = true;
                      } else {
                        widget.isEnable = false;
                      }
                      await driverData
                          .updateDriverStatus(widget.id, widget.isEnable)
                          .then((_) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: widget.isEnable
                                ? const Text(
                                    'Driver Enabled!',
                                    textAlign: TextAlign.center,
                                  )
                                : const Text(
                                    'Driver Disabled!',
                                    textAlign: TextAlign.center,
                                  )));
                      });
                      setState(() {
                        _isLoading = false;
                      });
                    }),
                    child: widget.isEnable
                        ? const Text(
                            'Enabled',
                            style: TextStyle(fontFamily: 'OpenSans-Bold'),
                          )
                        : const Text(
                            'Disabled',
                            style: TextStyle(
                                color: Colors.red, fontFamily: 'OpenSans-Bold'),
                          )),
            IconButton(
                onPressed: (() {
                  Navigator.of(context)
                      .pushNamed(AddDriverScreen.routeName, arguments: {
                    'id': widget.id,
                    'name': widget.name,
                    'email': widget.email,
                    'password': widget.password,
                    'cnic': widget.cnic,
                    'phone': widget.phone,
                    'liscenseCategory': widget.licenseCategory,
                    'isEnable': widget.isEnable
                  });
                }),
                icon: const Icon(Icons.edit)),
          ],
        )),
      ),
    );
  }
}
