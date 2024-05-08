import 'package:flutter/material.dart';
import 'package:gtms/admin/screens/vehicle_management/add_bus_screen.dart';
import 'package:gtms/admin/screens/vehicle_management/bus_detail_description.dart';
import 'package:provider/provider.dart';

import 'package:gtms/admin/providers/bus_provider.dart';

class BusDetailWidget extends StatefulWidget {
  String id;
  String number;
  String driver;
  String route;
  DateTime date;
  bool isRented;

  BusDetailWidget({
    required this.id,
    required this.number,
    required this.driver,
    required this.route,
    required this.date,
    required this.isRented,
  });

  @override
  State<BusDetailWidget> createState() => _BusDetailWidgetState();
}

class _BusDetailWidgetState extends State<BusDetailWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final busData = Provider.of<BusProvider>(context);
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(BusDetailDescription.routeName, arguments: {
            'number': widget.number,
            'driver': widget.driver,
            'route': widget.route,
            'date': widget.date,
            'isRented': widget.isRented
          });
        },
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
                      .pushNamed(AddBusScreen.routeName, arguments: {
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
                      await busData
                          .deleteBus(widget.number, widget.id)
                          .then((value) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          'Bus Deleted!',
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
