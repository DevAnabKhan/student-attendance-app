import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/lib/screens/teachers/teacher_details.dart';
import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';
import '../../provider/model_class.dart';
import 'edit_teacher.dart';

class TeacherFunction extends StatefulWidget {
  const TeacherFunction({super.key});

  @override
  State<TeacherFunction> createState() => _RecordState();
}

class _RecordState extends State<TeacherFunction> {
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
            "Teachers",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF9D1DBC),
      ),
      body: Container(
        child: Builder(
          builder: (context) {
            return ValueListenableBuilder<Box<Teacher>>(
              valueListenable: Boxes.getTeacherData().listenable(),
              builder: (context, Box<Teacher> box, Widget? child) {
                var teacherData = box.values.toList().cast();
                for (int i = 0; i <= teacherData.length - 1; i++) {
                  print("${teacherData[i].teaName}");
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        showMyDialog(teacherData[index], context);
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherDetails(
                              teacher: teacherData[index],
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
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Name : ${teacherData[index].teaName}",
                                              style: TextStyle(fontSize: 20),
                                              overflow: TextOverflow.clip,
                                              softWrap: true,
                                            ),
                                            Divider(),
                                            Text(
                                              "Qualification : ${teacherData[index].qualification}",
                                              style: TextStyle(fontSize: 15),
                                              overflow: TextOverflow.clip,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ID : ${teacherData[index].teaId}',
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
                                      builder: (context) => EditTeacher(
                                        teacher: teacherData[index],
                                        name: teacherData[index]
                                            .teaName
                                            .toString(),
                                        qualification:
                                            teacherData[index].qualification,
                                        fName: teacherData[index].teaFatherName,
                                        designation:
                                            teacherData[index].teaDesignation,
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

  Future<void> showMyDialog(Teacher teacher, BuildContext context) {
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteTeacher(teacher);
                setState(
                  () {
                    modelProvider.decrementTeacher();
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

void deleteTeacher(Teacher teacher) async {
  await teacher.delete();
}
