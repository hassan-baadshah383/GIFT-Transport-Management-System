import 'package:flutter/material.dart';
import 'package:gtms/admin/screens/vehicle_management/add_car_screen.dart';
import 'package:gtms/admin/screens/vehicle_management/car_detail_description.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/admin/providers/car_provider.dart';

class CarDetailWidget extends StatefulWidget {
  String id;
  String number;
  String driver;
  String route;
  DateTime date;
  bool isRented;

  CarDetailWidget({
    @required this.id,
    @required this.number,
    @required this.driver,
    @required this.route,
    @required this.date,
    @required this.isRented,
  });

  @override
  State<CarDetailWidget> createState() => _CarDetailWidgetState();
}

class _CarDetailWidgetState extends State<CarDetailWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final carData = Provider.of<CarProvider>(context);
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(CarDetailDescription.routeName, arguments: {
          'number': widget.number,
          'driver': widget.driver,
          'route': widget.route,
          'date': widget.date,
          'isRented': widget.isRented,
        }),
        leading: CircleAvatar(
            child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(widget.number),
          ),
        )),
        title: Text(widget.route),
        subtitle: Text(widget.driver),
        trailing: FittedBox(
            child: Row(
          children: [
            IconButton(
                onPressed: (() {
                  Navigator.of(context)
                      .pushNamed(AddCarScreen.routeName, arguments: {
                    'id': widget.id,
                    'number': widget.number,
                    'driver': widget.driver,
                    'route': widget.route,
                    'isRented': widget.isRented,
                  });
                }),
                icon: const Icon(Icons.edit)),
            _isLoading
                ? const CircularProgressIndicator()
                : IconButton(
                    onPressed: (() async {
                      setState(() {
                        _isLoading = true;
                      });
                      await carData
                          .deleteCar(widget.number, widget.id)
                          .then((value) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          'Car Deleted!',
                          textAlign: TextAlign.center,
                        )));
                      });
                      setState(() {
                        _isLoading = false;
                      });
                    }),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
          ],
        )),
      ),
    );
  }
}
