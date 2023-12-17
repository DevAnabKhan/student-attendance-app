import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/provider/model_class.dart';

import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';
import '../attendence.dart';

bool isPresent = false;

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  late ModelProvider modelProvider;
  String? selectedGrade;
  List<String> gradeList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGrades();
  }

  void fetchGrades() async {
    Box<Grade> gradeBox = Boxes.getGradeData();
    gradeList = gradeBox.values.map((element) => element.grade).toList();
    for (int i = 0; i < gradeList.length; i++) {
      print('${gradeList}');
    }
  }

  @override
  Widget build(BuildContext context) {
    modelProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: Color(0xFFF1E4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Here to Get',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Welcomed !',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white60,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 20, bottom: 25),
                      child: Column(
                        children: [
                          Text(
                            'Add New Student',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9D1DBC),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: controller1,
                                    decoration: InputDecoration(
                                      label: Text('Enter student name.'),
                                      focusColor: Color(0xFF9D1DBC),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Name";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: controller2,
                                    decoration: InputDecoration(
                                      label: Text('Enter father name.'),
                                      focusColor: Color(0xFF9D1DBC),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter F.name";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.number,
                                    controller: controller3,
                                    decoration: InputDecoration(
                                      label: Text('Enter Roll no.'),
                                      focusColor: Color(0xFF9D1DBC),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Roll No";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DropdownButtonFormField(
                                    value: selectedGrade,
                                    items: gradeList.map((String sGrade) {
                                      return DropdownMenuItem<String>(
                                          value: sGrade,
                                          child: Text("$sGrade"));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGrade = newValue ?? null;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value == 0) {
                                        return "Please select a grade";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Select Grade',
                                      focusColor: Color(0xFF9D1DBC),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            controller1.clear();
                                            controller2.clear();
                                            controller3.clear();
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF9D1DBC)),
                                          )),
                                      TextButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            addStudent(
                                                controller1.text,
                                                controller2.text,
                                                selectedGrade!,
                                                int.parse(controller3.text));
                                            if (isPresent) {
                                              setState(
                                                () {
                                                  isPresent = false;
                                                },
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Student with Roll No ${controller3.text} already exist in Grade ${selectedGrade!.toString()}."),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                              isPresent = false;
                                            }
                                            Navigator.of(context).pop();
                                            controller1.clear();
                                            controller2.clear();
                                            controller3.clear();
                                            setState(
                                              () {
                                                modelProvider.incrementAll();
                                              },
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF9D1DBC),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void addStudent(String name, String fName, String grade, int rollNo) {
  Box<Student> studentBox = Boxes.getData();
  DateTime dt = DateTime.now();
  int studentId = DateTime.now().millisecondsSinceEpoch % 100000;
  if (studentBox.values.any(
      (element) => element.rollNo == rollNo && element.studentGrade == grade)) {
    isPresent = false;
  } else {
    isPresent = true;
    Student newStudent = Student(name, studentId, dt, fName, grade, rollNo);
    studentBox.add(newStudent);
    newStudent.save();
  }
}
