import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/provider/model_class.dart';

import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';

class EditTeacher extends StatefulWidget {
  final Teacher teacher;
  String name;
  String qualification;
  String fName;
  String designation;
  EditTeacher(
      {super.key,
      required this.teacher,
      required this.name,
      required this.qualification,
      required this.fName,
      required this.designation});

  @override
  State<EditTeacher> createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 =
        TextEditingController(text: widget.name.toString());
    TextEditingController controller2 =
        TextEditingController(text: widget.qualification.toString());
    TextEditingController controller3 =
        TextEditingController(text: widget.fName.toString());
    TextEditingController controller4 =
        TextEditingController(text: widget.designation.toString());
    Teacher teacher = widget.teacher;
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
                            'Edit Teacher',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9D1DBC),
                            ),
                          ),
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
                                    label: Text('Enter teacher name.'),
                                    focusColor: Color(0xFF9D1DBC),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: controller2,
                                  decoration: InputDecoration(
                                    label: Text('Enter qualifications.'),
                                    focusColor: Color(0xFF9D1DBC),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter qualifications";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: controller3,
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
                                  textCapitalization: TextCapitalization.words,
                                  controller: controller4,
                                  decoration: InputDecoration(
                                    label: Text('Enter designation.'),
                                    focusColor: Color(0xFF9D1DBC),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter designation";
                                    } else {
                                      return null;
                                    }
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
                                        controller4.clear();
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
                                          teacher.teaName =
                                              controller1.text.toString();
                                          teacher.qualification =
                                              controller2.text.toString();
                                          teacher.teaFatherName =
                                              controller3.text.toString();
                                          teacher.teaDesignation =
                                              controller4.text.toString();
                                          teacher.save();
                                          Navigator.of(context).pop();
                                          controller1.clear();
                                          controller2.clear();
                                          controller3.clear();
                                          controller4.clear();
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
