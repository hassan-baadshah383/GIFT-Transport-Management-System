import 'package:flutter/material.dart';
import 'package:gtms/admin/providers/routes_provider.dart';
import 'package:provider/provider.dart';

class AddRouteScreen extends StatefulWidget {
  static const routeName = '/addRouteScreen';

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  bool isEdit = true;
  bool inEditMode = false;
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  Map<String, Object> newRouteData = {
    'id': '',
    'name': '',
  };

  @override
  void didChangeDependencies() {
    if (isEdit) {
      final product =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      if (product != null) {
        inEditMode = true;
        newRouteData = {
          'id': product['id'],
          'name': product['name'],
        };
      }
    }
    isEdit = false;
    super.didChangeDependencies();
  }

  Future<void> submit() async {
    final validate = _form.currentState.validate();
    _form.currentState.save();
    if (validate) {
      final routesData = Provider.of<RoutesProvider>(context, listen: false);
      if (inEditMode) {
        setState(() {
          _isLoading = true;
        });
        await routesData.updateRoute(newRouteData['id'], newRouteData['name']);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = true;
        });
        await routesData.addRoute(newRouteData['name']);
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
          title: const Text('Add Route'),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
          actions: [
            IconButton(
                onPressed: (() {
                  submit();
                }),
                icon: const Icon(Icons.save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: newRouteData['name'],
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.route),
                      labelText: 'Name',
                    ),
                    onSaved: (newValue) {
                      newRouteData['name'] = newValue;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a route';
                      }
                      return null;
                    },
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
                            onPressed: (() {
                              submit();
                            }),
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                )),
                            child: const Text('Submit')),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
