import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';

class AllStudents extends StatelessWidget {
  const AllStudents({super.key});

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
                        color: Colors.lightGreen,
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        "All Students",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.lightGreen,
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
            child: ValueListenableBuilder<Box<Student>>(
              valueListenable: Boxes.getData().listenable(),
              builder: (context, Box<Student> box, Widget? child) {
                var allStudents = box.values.toList().cast();
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: ListTile(
                          tileColor: Colors.lightGreen.shade50,
                          title: Text("${allStudents[index].name}",
                              style: TextStyle(fontSize: 20),
                              softWrap: true,
                              overflow: TextOverflow.clip),
                          subtitle: Text(
                              'Reg : ${DateFormat('dd-MM-yyyy').format(allStudents[index].dateTime)}'),
                          trailing: Text(
                            "Roll No : ${allStudents[index].rollNo}",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
