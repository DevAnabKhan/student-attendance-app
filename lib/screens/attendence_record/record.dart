import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/boxes/boxes.dart';
import 'package:student_attendence/hive/model_class.dart';
import 'package:student_attendence/provider/model_class.dart';
import 'package:student_attendence/screens/attendence_record/present_students.dart';

import '../report/generate_report.dart';
import 'absent_students.dart';
import 'all_students.dart';
import 'all_teachers.dart';

class StudentRecord extends StatefulWidget {
  const StudentRecord({super.key});

  @override
  State<StudentRecord> createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  DateTime date = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ModelProvider modelProvider = Provider.of(context, listen: true);
    List<GridItemData> list = [
      GridItemData(
          color: Colors.lightGreen,
          text: "Total Students",
          screen: AllStudents(),
          value: modelProvider.getCountAll),
      GridItemData(
          color: Colors.orange,
          text: "Present Students",
          screen: PresentStudents(),
          value: modelProvider.getCountPre),
      GridItemData(
          color: Colors.pinkAccent,
          text: "Absent Students",
          screen: AbsentStudents(),
          value: modelProvider.getCountAbs),
      GridItemData(
          color: Colors.cyan,
          text: "Teachers",
          screen: AllTeachers(),
          value: modelProvider.getCountTea),
    ];
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 40, top: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Record",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Center(
                            child: Text(
                              "${DateFormat('dd MMMM yyyy').format(date)}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GenerateReport()),
                      );
                    },
                    icon: Icon(
                      Icons.description,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return GridItems(data: list[index]);
              },
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                maxCrossAxisExtent: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridItems extends StatelessWidget {
  final GridItemData data;

  GridItems({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => data.screen));
      },
      child: Card(
        color: data.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                "${data.text}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "${data.value}",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItemData {
  final Color color;
  final String text;
  final Widget screen;
  final int value;
  GridItemData(
      {required this.color,
      required this.text,
      required this.screen,
      required this.value});
}
