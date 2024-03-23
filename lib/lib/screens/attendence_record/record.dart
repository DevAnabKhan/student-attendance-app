import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/lib/screens/attendence_record/present_students.dart';
import '../../provider/model_class.dart';
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
        // Text("datadatadata ${list.length}"),
        // return GridItems(data: list[index]);
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              // color: Colors.blue,
              child: GridView.builder(
              padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                // width / height: fixed for *all* items
                childAspectRatio: 1,
              ),
              // return a custom ItemCard
              itemBuilder: (context, index) => GridItems(data: list[index]),
              itemCount: list.length,
          ),
            )
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        width: 120,
        height: 120,
        decoration: BoxDecoration(
        //color: Colors.orange,
        color: data.color,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${data.text}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Center(
              child: Text(
                "${data.value}",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ],
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
