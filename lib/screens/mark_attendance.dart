import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/hive/model_class.dart';
import 'package:student_attendence/provider/model_class.dart';

import '../boxes/boxes.dart';

bool increasePre = false;
bool increaseAbs = false;

class MarkAttendance extends StatefulWidget {
  String gradeClicked;
  MarkAttendance({super.key, required this.gradeClicked});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late ModelProvider modelProvider;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    modelProvider = Provider.of(context, listen: true);
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 100,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Mark Attendance",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "${widget.gradeClicked}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFF9D1DBC),
        ),
        body: Container(
          child: Builder(builder: (context) {
            return ValueListenableBuilder<Box<Student>>(
                valueListenable: Boxes.getData().listenable(),
                builder: (context, Box<Student> box, Widget? child) {
                  var studentData = box.values.toList().cast();
                  for (int i = 0; i <= studentData.length - 1; i++) {
                    print("${studentData[i].name}");
                  }

                  return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        if (studentData[index].studentGrade ==
                            widget.gradeClicked) {
                          return Card(
                            margin: EdgeInsets.all(9),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${studentData[index].name}",
                                          style: TextStyle(fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                            "Roll No : ${studentData[index].rollNo}"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            markAttendence(
                                                studentData[index].id,
                                                studentData[index].name,
                                                true);
                                            if (increasePre) {
                                              setState(
                                                () {
                                                  modelProvider
                                                      .incrementPresent(DateTime.now());
                                                  increasePre = false;
                                                },
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Attendence of ${studentData[index].name} is Already marked for today"),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                              increasePre = false;
                                            }
                                          },
                                          child: Text(
                                            'Present',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            fixedSize: Size.square(50),
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Colors.red,
                                              width: 1,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            markAttendence(
                                                studentData[index].id,
                                                studentData[index].name,
                                                false);
                                            if (increaseAbs) {
                                              setState(
                                                () {
                                                  modelProvider
                                                      .incrementAbsent(DateTime.now());
                                                  increaseAbs = false;
                                                },
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Attendence for ${studentData[index].name} is Already marked for today"),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                              increaseAbs = false;
                                            }
                                          },
                                          child: Text(
                                            'Absent',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            fixedSize: Size.square(50),
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Colors.green,
                                              width: 1,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      });
                });
          }),
        ));
  }
}

void markAttendence(int id, String name, bool isPresent) {
  Box<Attendance> attendanceBox = Boxes.getAttendanceData();
  DateTime now = DateTime.now();
  if (attendanceBox.values.any((element) =>
      element.studentId == id &&
      element.date.day == now.day &&
      element.date.month == now.month &&
      element.date.year == now.year)) {
    increasePre = false;
    increaseAbs = false;
  } else {
    if (isPresent) {
      increasePre = true;
    } else {
      increaseAbs = true;
    }
    attendanceBox.add(Attendance(id, now, isPresent, name));
    print("Attendence is marked");
  }
}
