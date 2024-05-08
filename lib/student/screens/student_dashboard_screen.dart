import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/student/screens/student_profile_screen.dart';
import '../widgets/drawer.dart';
import '../widgets/dashboard_items.dart';
import '../providers/dummy_student_data.dart';
import '/student/providers/students.dart';
import '/auth.dart';

class StudentDashboardScreen extends StatefulWidget {
  static const routeName = '/productOverviewScreen';
  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    final authId = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<StudentData>(context, listen: false).fetchStudent(authId!);
    bool isFeePaid = Provider.of<StudentData>(context, listen: false).isFeePaid;
    setState(() {
      _isLoading = false;
    });
    if (!isFeePaid) {
      _alertDialogueBox();
    }
  }

  void _alertDialogueBox() {
    Future.delayed(Duration.zero, () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.warning),
                  Text('Warning'),
                ],
              ),
              content: const Text('Please pay your outstanding dues.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                    child: const Text('Ok'))
              ],
            );
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Navigator.of(context).pushNamed(
                      StudentProfile.routeName,
                    ))
          ],
          title: const Text(
            'Dashboard',
          ),
          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  SizedBox(
                    height: 600,
                    width: kIsWeb ? 1500 : 500,
                    child: Image.asset('assets/images/gift_front.jpg',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    color: Colors.black12,
                  ),
                  SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: kIsWeb
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.black54,
                                  )
                                : BoxDecoration(
                                    color: Colors.black54,
                                  ),
                            width: !kIsWeb
                                ? double.infinity
                                : deviceSize.width * 0.4,
                            margin: const EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            height: 50,
                            child: const Text(
                              'GIFT Transport System',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: kIsWeb
                                ? EdgeInsets.only(right: 500, left: 500)
                                : EdgeInsets.only(),
                            child: GridView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(15),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      mainAxisExtent: 150,
                                      childAspectRatio: 3 / 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10),
                              children: StudentActionData()
                                  .dummyStudentList
                                  .map((item) => DashboardItems(item.title,
                                      item.icon, item.route, item.color))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
