import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';
import '../../provider/model_class.dart';

class PresentStudents extends StatefulWidget {
  const PresentStudents({super.key});

  @override
  State<PresentStudents> createState() => _PresentStudentsState();
}

class _PresentStudentsState extends State<PresentStudents> {
  bool isCheck = false;
  DateTime current = DateTime.now();
  //DateTime oneSecond = DateTime.now().subtract(Duration(seconds: 1));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reSet();
  }

  void reSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastDate = DateTime.parse(prefs.getString('last_pre_date') ?? '');

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
                        color: Colors.orange,
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Present Students",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.orange,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      modelProvider.decrementPre();
                    },
                    icon: Icon(Icons.minimize),
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
                        if (preStudents[index].isPresent) {
                          DateTime studentDate = preStudents[index].date;
                          if (studentDate.year == today.year &&
                              studentDate.month == today.month &&
                              studentDate.day == today.day) {
                            isCheck = false;
                            String foramtedDate = DateFormat('dd-MM-yyyy')
                                .format(preStudents[index].date);
                            print("${box.length}");
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  tileColor: Colors.orange.shade50,
                                  title: Text(
                                    "${preStudents[index].studentName}",
                                    style: TextStyle(fontSize: 20),
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                  ),
                                  subtitle: Text(
                                      "ID : ${preStudents[index].studentId}"),
                                  trailing: Text("${foramtedDate}"),
                                  // trailing: Column(
                                  //   children: [
                                  //    preStudents.contains(modelProvider.id)?Text('deleted'):Text(''),
                                  //     preStudents.any((element) => element.studentId==modelProvider.id)?Text('deleted'):Text(''),
                                  //
                                  //     preStudents[index].studentId == modelProvider.id ? Text('deleted'):Text(''),
                                  //     Text("${foramtedDate}"),
                                  //   // Text('${modelProvider.id}'),
                                  //   ],
                                  // )
                                ),
                              ),
                            );
                          } else {
                            isCheck = true;
                            return SizedBox();
                          }
                        } else {
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
