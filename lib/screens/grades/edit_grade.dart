import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/provider/model_class.dart';

import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';

class EditStudentGrade extends StatefulWidget {
  final Grade grade;
  String studentGrade;
  EditStudentGrade(
      {super.key, required this.grade, required this.studentGrade});

  @override
  State<EditStudentGrade> createState() => _EditStudentGradeState();
}

class _EditStudentGradeState extends State<EditStudentGrade> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ModelProvider modelProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 = TextEditingController(text: widget.studentGrade);
    Grade grade = widget.grade;
    modelProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: Color(0xFFF1E4F7),
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
                "Edit Grade",
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
                                          color: Color(0xFF9D1DBC)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        grade.grade = controller1.text;
                                        grade.save();
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      }
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF9D1DBC)),
                                    ),
                                  ),
                                ],
                              )
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
