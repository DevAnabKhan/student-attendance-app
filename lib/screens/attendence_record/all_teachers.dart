import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:student_attendence/hive/model_class.dart';

import '../../boxes/boxes.dart';

class AllTeachers extends StatelessWidget {
  const AllTeachers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 40),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.cyan,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Teachers",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.cyan,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ValueListenableBuilder<Box<Teacher>>(
              valueListenable: Boxes.getTeacherData().listenable(),
              builder: (context, Box<Teacher> box, Widget? child) {
                var teacherData = box.values.toList().cast();
                for (int i = 0; i <= teacherData.length - 1; i++) {
                  print("${teacherData[i].teaName}");
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: ListTile(
                          tileColor: Colors.cyan.shade50,
                          title: Text("${teacherData[index].teaName}",
                              style: TextStyle(fontSize: 20),
                              softWrap: true,
                              overflow: TextOverflow.clip),
                          subtitle: Text(
                              'Qualification : ${teacherData[index].qualification}',
                              softWrap: true,
                              overflow: TextOverflow.clip),
                          trailing: Text(
                            "ID : ${teacherData[index].teaId}",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
