import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/lib/screens/students/student_details.dart';
import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';
import '../../provider/model_class.dart';
import '../attendence.dart';
import 'add_students.dart';
import 'edit_student.dart';

class StudentFunction extends StatefulWidget {
  const StudentFunction({super.key});

  @override
  State<StudentFunction> createState() => _StudentFunctionState();
}

class _StudentFunctionState extends State<StudentFunction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  late ModelProvider modelProvider;
  @override
  Widget build(BuildContext context) {
    modelProvider = Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
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
        title: Center(
          child: Text(
            "Students Records",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF9D1DBC),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStudent(),
                ),
              );
            },
            icon: Icon(
              Icons.add_box_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        child: Builder(
          builder: (context) {
            return ValueListenableBuilder<Box<Student>>(
              valueListenable: Boxes.getData().listenable(),
              builder: (context, Box<Student> box, Widget? child) {
                List<Student> studentData = box.values.toList().cast();
                // for (int i = 0; i <= studentData.length - 1; i++) {
                //   print("${studentData[i].name}");
                // }

                studentData.sort((b, a) => b.rollNo.compareTo(a.rollNo));

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        showMyDialog(
                          studentData[index],
                          context,
                          studentData[index].id,
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetails(
                              student: studentData[index],
                            ),
                          ),
                        );
                      },
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
                                            Text(
                                              "${studentData[index].name}",
                                              style: TextStyle(fontSize: 20),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Roll No : ${studentData[index].rollNo}",
                                            ),
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
                                      builder: (context) => EditStudent(
                                        student: studentData[index],
                                        name: studentData[index].name,
                                        fName: studentData[index].fatherName,
                                        grade: studentData[index].studentGrade,
                                        rollNo: studentData[index].rollNo,
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
    );
  }

  Future<void> showMyDialog(Student student, BuildContext context, int id) {
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
                deleteStudent(student);
                setState(
                  () {
                    modelProvider.decrementAll();
                  },
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void deleteStudent(Student student) async {
  await student.delete();
}
