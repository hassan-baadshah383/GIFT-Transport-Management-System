import 'package:flutter/material.dart';
import 'package:gtms/admin/models/route.dart';
import 'package:gtms/admin/providers/routes_provider.dart';
import 'package:gtms/admin/screens/routes_management/add_route_screen.dart';
import 'package:gtms/admin/widgets/routes_detail_widget.dart';
import 'package:provider/provider.dart';

class RoutesDetailsScreen extends StatefulWidget {
  static const routeName = '/routesDetailsScreen';

  @override
  State<RoutesDetailsScreen> createState() => _RoutesDetailsScreenState();
}

class _RoutesDetailsScreenState extends State<RoutesDetailsScreen> {
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
    await Provider.of<RoutesProvider>(context, listen: false).fetchRoutesData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Provider.of<RoutesProvider>(context);
    final routesData = r.routesList;
    List<RouteClass> filteredRoutes = r.filteredRoutesList;

    Widget appBarTitle = const Text('Routes Details');

    if (_showSearchBar) {
      appBarTitle = TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          hintText: 'Search...',
        ),
        onChanged: (String value) {
          r.filterSearch(value);
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
                    r.filterSearch('');
                    filteredRoutes = [];
                  },
                  icon: const Icon(Icons.close),
                ),
              IconButton(
                  onPressed: (() {
                    Navigator.of(context).pushNamed(AddRouteScreen.routeName);
                  }),
                  icon: const Icon(Icons.add))
            ]),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : routesData.isEmpty
                ? const Center(
                    child: Text('No any route yet. Try adding some!'))
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            filteredRoutes.isNotEmpty
                                ? RoutesDetailWidget(
                                    id: filteredRoutes[index].id,
                                    name: filteredRoutes[index].name,
                                  )
                                : RoutesDetailWidget(
                                    id: routesData[index].id,
                                    name: routesData[index].name,
                                  )
                          ],
                        );
                      }),
                      itemCount: filteredRoutes.isNotEmpty
                          ? filteredRoutes.length
                          : routesData.length,
                    ),
                  ));
  }
}
