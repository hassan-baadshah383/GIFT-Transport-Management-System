import 'package:flutter/material.dart';
import 'package:gtms/admin/providers/fee_provider.dart';
import 'package:provider/provider.dart';

class FeeDetailScreen extends StatefulWidget {
  static const routeName = '/feeDetailScreen';
  @override
  _FeeDetailScreenState createState() => _FeeDetailScreenState();
}

class _FeeDetailScreenState extends State<FeeDetailScreen> {
  bool _isLoading = false;
  String initialValue = 'All';
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<FeeProvider>(context, listen: false).fetchData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final feeClass = Provider.of<FeeProvider>(context, listen: false);
    final studList = feeClass.studentFees;
    final paidStudList = feeClass.paidStudentsList;
    final unPaidStudentList = feeClass.unPaidStudentsList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Detail'),
        backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : studList.isEmpty
              ? const Center(
                  child: Text('No any student enrolled yet.'),
                )
              : Column(
                  children: [
                    Container(
                      width: deviceSize.width * 0.2,
                      child: DropdownButton(
                          isExpanded: true,
                          value: initialValue,
                          items: <String>['All', 'Paid', 'Unpaid']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: ((value) {
                            setState(() {
                              initialValue = value.toString();
                            });
                            if (initialValue == 'All') {
                              studList;
                            } else if (initialValue == 'Paid') {
                              Provider.of<FeeProvider>(context, listen: false)
                                  .paidStudents();
                            } else if (initialValue == 'Unpaid') {
                              Provider.of<FeeProvider>(context, listen: false)
                                  .unPaidStudents();
                            }
                          })),
                    ),
                    initialValue == 'All'
                        ? Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(top: 8),
                              child: ListView.builder(
                                itemCount: studList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(studList[index].name),
                                      subtitle: Text(
                                          'Fee Status: ${studList[index].isFeePaid ? 'Paid' : 'Unpaid'}'),
                                      trailing: DropdownButton<String>(
                                        value: studList[index].isFeePaid
                                            ? 'Paid'
                                            : 'Unpaid',
                                        items: <String>['Paid', 'Unpaid']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) async {
                                          bool isFeePaid =
                                              newValue == 'Paid' ? true : false;
                                          setState(() {
                                            studList[index].isFeePaid =
                                                isFeePaid;
                                          });
                                          await feeClass.updateData(
                                              studList[index].sId, isFeePaid);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : initialValue == 'Paid'
                            ? Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(top: 8),
                                  child: ListView.builder(
                                    itemCount: paidStudList.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Text(paidStudList[index].name),
                                          subtitle: Text(
                                              'Fee Status: ${paidStudList[index].isFeePaid ? 'Paid' : 'Unpaid'}'),
                                          trailing: DropdownButton<String>(
                                            value: paidStudList[index].isFeePaid
                                                ? 'Paid'
                                                : 'Unpaid',
                                            items: <String>['Paid', 'Unpaid']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) async {
                                              bool isFeePaid =
                                                  newValue == 'Paid'
                                                      ? true
                                                      : false;
                                              setState(() {
                                                paidStudList[index].isFeePaid =
                                                    isFeePaid;
                                              });
                                              await feeClass.updateData(
                                                  paidStudList[index].sId,
                                                  isFeePaid);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(top: 8),
                                  child: ListView.builder(
                                    itemCount: unPaidStudentList.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Text(
                                              unPaidStudentList[index].name),
                                          subtitle: Text(
                                              'Fee Status: ${unPaidStudentList[index].isFeePaid ? 'Paid' : 'Unpaid'}'),
                                          trailing: DropdownButton<String>(
                                            value: unPaidStudentList[index]
                                                    .isFeePaid
                                                ? 'Paid'
                                                : 'Unpaid',
                                            items: <String>['Paid', 'Unpaid']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) async {
                                              bool isFeePaid =
                                                  newValue == 'Paid'
                                                      ? true
                                                      : false;
                                              setState(() {
                                                unPaidStudentList[index]
                                                    .isFeePaid = isFeePaid;
                                              });
                                              await feeClass.updateData(
                                                  unPaidStudentList[index].sId,
                                                  isFeePaid);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                  ],
                ),
    );
  }
}
