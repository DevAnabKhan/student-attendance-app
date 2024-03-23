import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';
import '../../provider/model_class.dart';

class AbsentStudents extends StatefulWidget {
  const AbsentStudents({super.key});

  @override
  State<AbsentStudents> createState() => _AbsentStudentsState();
}

class _AbsentStudentsState extends State<AbsentStudents> {
  int count = 0;
  bool isCheck = false;
  DateTime current = DateTime.now();
  DateTime oneSecond = DateTime.now().subtract(Duration(seconds: 1));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(current != oneSecond){
    //   ModelProvider modelProvider = Provider.of(context, listen: false);
    //   modelProvider.delete(true);
    // }
    reSet();
  }
  void reSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastDate = DateTime.parse(prefs.getString('last_abs_date') ?? '');

    if (lastDate.year != current.year ||
        lastDate.month != current.month ||
        lastDate.day != current.day) {
      ModelProvider modelProvider = Provider.of(context, listen: false);
      modelProvider.delete(true);
    }
  }
  @override
  Widget build(BuildContext context) {
    ModelProvider modelProvider = Provider.of(context, listen: false);
    // if(current != oneSecond){
    //   modelProvider.delete(true);
    // }
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 40),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Absent Students",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Builder(
              builder: (context) {
                return ValueListenableBuilder<Box<Attendance>>(
                  valueListenable: Boxes.getAttendanceData().listenable(),
                  builder: (context, Box<Attendance> box, Widget? child) {
                    var preStudents = box.values.toList().cast();
                    DateTime today = DateTime.now();
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        if (!preStudents[index].isPresent) {
                          DateTime studentDate = preStudents[index].date;
                          if (studentDate.year == today.year &&
                              studentDate.month == today.month &&
                              studentDate.day == today.day) {
                            isCheck = false;
                            String foramtedDate = DateFormat('dd-MM-yyyy')
                                .format(preStudents[index].date);
                            print("${preStudents.length}");
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  tileColor: Colors.pink.shade50,
                                  title: Text(
                                      "${preStudents[index].studentName}",
                                      style: TextStyle(fontSize: 20),
                                      softWrap: true,
                                      overflow: TextOverflow.clip),
                                  subtitle: Text(
                                    "ID : ${preStudents[index].studentId}",
                                  ),
                                  trailing: Text(
                                    "${foramtedDate}",
                                  ),
                                ),
                              ),
                            );
                          } else {
                            isCheck = true;
                            return SizedBox();
                          }
                        } else {
                          isCheck = true;
                          return SizedBox();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
