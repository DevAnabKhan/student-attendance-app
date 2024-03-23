import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';

class EditStudent extends StatefulWidget {
  final Student student;
  String name;
  String fName;
  String grade;
  int rollNo;
  EditStudent(
      {super.key,
      required this.student,
      required this.name,
      required this.fName,
      required this.grade,
      required this.rollNo});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  late String selectedGrade;
  List<String> gradeList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = TextEditingController(text: widget.name.toString());
    controller2 = TextEditingController(text: widget.fName.toString());
    controller3 = TextEditingController(text: widget.rollNo.toString());
    selectedGrade = widget.grade;
    fetchGrades();
  }

  void fetchGrades() async {
    Box<Grade> gradeBox = Boxes.getGradeData();
    gradeList = gradeBox.values.map((element) => element.grade).toList();
    for (int i = 0; i < gradeList.length; i++) {
      print('${gradeList.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Student student = widget.student;
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
                            'Edit Student',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9D1DBC)),
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
                                        return "Please enter F.name";
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
                                        return "Please enter Roll No.";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: selectedGrade,
                                    items: gradeList.map((String grade) {
                                      return DropdownMenuItem<String>(
                                        value: grade,
                                        child: Text(grade),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      selectedGrade = newValue!;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Select Grade',
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select a grade"; // Error message for validation
                                      }
                                      return null; // Return null if validation passes
                                    },
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
                                            Box<Student> studentBox =
                                                Boxes.getData();

                                            // Check if roll number or grade has changed
                                            bool isRollNoChanged =
                                                widget.rollNo !=
                                                    int.parse(controller3.text);
                                            bool isGradeChanged =
                                                widget.grade !=
                                                    selectedGrade.toString();

                                            // Check for existing student only if roll number or grade has changed
                                            if (isRollNoChanged ||
                                                isGradeChanged) {
                                              if (studentBox.values.any(
                                                (element) =>
                                                    element.rollNo ==
                                                        int.parse(
                                                            controller3.text) &&
                                                    element.studentGrade ==
                                                        selectedGrade
                                                            .toString(),
                                              )) {
                                                // Student with the same roll number and grade already exists
                                                Navigator.of(context).pop();
                                                controller1.clear();
                                                controller2.clear();
                                                controller3.clear();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Student with Roll No ${controller3.text} already exists in Grade ${selectedGrade.toString()}.",
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              } else {
                                                // Save student information
                                                Student student =
                                                    widget.student;
                                                student.name =
                                                    controller1.text.toString();
                                                student.fatherName =
                                                    controller2.text.toString();
                                                student.studentGrade =
                                                    selectedGrade;
                                                student.rollNo =
                                                    int.parse(controller3.text);
                                                student.save();
                                                Navigator.of(context).pop();
                                                controller1.clear();
                                                controller2.clear();
                                                controller3.clear();
                                              }
                                            } else {
                                              // Save student information without checking existence
                                              Student student = widget.student;
                                              student.name =
                                                  controller1.text.toString();
                                              student.fatherName =
                                                  controller2.text.toString();
                                              student.studentGrade =
                                                  selectedGrade;
                                              student.rollNo =
                                                  int.parse(controller3.text);
                                              student.save();
                                              Navigator.of(context).pop();
                                              controller1.clear();
                                              controller2.clear();
                                              controller3.clear();
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Save",
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
