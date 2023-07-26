import 'package:flutter/material.dart';
import 'package:gtms/admin/screens/routes_management/add_route_screen.dart';
import 'package:provider/provider.dart';

import '../providers/routes_provider.dart';

class RoutesDetailWidget extends StatefulWidget {
  final String id;
  final String name;

  RoutesDetailWidget({this.id, this.name});

  @override
  State<RoutesDetailWidget> createState() => _RoutesDetailWidgetState();
}

class _RoutesDetailWidgetState extends State<RoutesDetailWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final deleteRoute = Provider.of<RoutesProvider>(context).deleteRoute;
    return Card(
      elevation: 5,
      child: ListTile(
        leading: const Icon(
          Icons.route,
          size: 40,
        ),
        title: Text(widget.name),
        trailing: FittedBox(
            child: Row(
          children: [
            IconButton(
                onPressed: (() {
                  Navigator.of(context)
                      .pushNamed(AddRouteScreen.routeName, arguments: {
                    'id': widget.id,
                    'name': widget.name,
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
                      await deleteRoute(widget.name, widget.id).then((value) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          'Route Deleted!',
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
