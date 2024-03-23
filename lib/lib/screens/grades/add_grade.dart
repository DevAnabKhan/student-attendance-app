import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';
import '../../provider/model_class.dart';

bool presentGrade = false;

class AddStudentGrade extends StatefulWidget {
  const AddStudentGrade({super.key});

  @override
  State<AddStudentGrade> createState() => _AddStudentGradeState();
}

class _AddStudentGradeState extends State<AddStudentGrade> {
  TextEditingController controller1 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ModelProvider modelProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    modelProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: Color(0xFFF1E4F7),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                "Add Grade",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 50,
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
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                controller: controller1,
                                decoration: InputDecoration(
                                  label: Text('Enter grade.'),
                                  hintText: 'Class 1st',
                                  focusColor: Color(0xFF9D1DBC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter grade";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF9D1DBC),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        addGrade(controller1.text);
                                        if (presentGrade) {
                                          setState(
                                            () {
                                              presentGrade = false;
                                            },
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Grade is already added."),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                          presentGrade = false;
                                        }
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      }
                                    },
                                    child: Text(
                                      "OK",
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
                      ],
                    ),
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

void addGrade(String grade) {
  Box<Grade> gradeBox = Boxes.getGradeData();
  if (gradeBox.values.any((element) => element.grade == grade)) {
    presentGrade = false;
  } else {
    presentGrade = true;
    Grade studentGrade = Grade(grade);
    gradeBox.add(studentGrade);
    studentGrade.save();
  }
}
