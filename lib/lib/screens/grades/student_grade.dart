import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';
import '../attendence.dart';
import '../dashboard_screen.dart';
import 'add_grade.dart';
import 'edit_grade.dart';

class StudentGrade extends StatefulWidget {
  const StudentGrade({super.key});

  @override
  State<StudentGrade> createState() => _StudentGradeState();
}

class _StudentGradeState extends State<StudentGrade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF9D1DBC),
            size: 20,
          ),
        ),
        title: Center(
          child: Text(
            "Grades ",
            style: TextStyle(
              color: Color(0xFF9D1DBC),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStudentGrade()),
              );
            },
            icon: Icon(
              Icons.add_box_outlined,
              color: Color(0xFF9D1DBC),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          child: Builder(
            builder: (context) {
              return ValueListenableBuilder<Box<Grade>>(
                valueListenable: Boxes.getGradeData().listenable(),
                builder: (context, Box<Grade> box, Widget? child) {
                  var gradeData = box.values.toList().cast();
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          showMyDialog(gradeData[index], context);
                        },
                        onTap: () {},
                        child: Card(
                          margin: EdgeInsets.all(9),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${gradeData[index].grade}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: -5,
                                right: -10,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStudentGrade(
                                          grade: gradeData[index],
                                          studentGrade: gradeData[index].grade,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.mode_edit_outline_outlined,
                                    size: 20,
                                    color: Color(0xFF9D1DBC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> showMyDialog(Grade grade, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Do you want to Delete?',
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteGrade(grade);
                setState(() {});
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void deleteGrade(Grade grade) async {
  await grade.delete();
}
