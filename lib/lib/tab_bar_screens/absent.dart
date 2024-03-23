import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../boxes/boxes.dart';
import '../hive/model_class.dart';
import '../provider/model_class.dart';

class SpecificAbsent extends StatelessWidget {
  DateTime? specificDate;
  SpecificAbsent({super.key,this.specificDate});
  //bool isPresent = true;

  @override
  Widget build(BuildContext context) {
    ModelProvider modelProvider = Provider.of(context,listen: false);
    return ValueListenableBuilder<Box<Attendance>>(
        valueListenable: Boxes.getAttendanceData().listenable(),
        builder: (context, Box<Attendance> box,Widget? child) {
          var preStudents = box.values.toList().cast();
          modelProvider.set(false);
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                if (!preStudents[index].isPresent) {
                  DateTime studentDate = preStudents[index].date;
                  if(
                      studentDate.year == specificDate!.year &&
                      studentDate.month == specificDate!.month &&
                      studentDate.day == specificDate!.day
                  ){
                   // isPresent = false;
                    modelProvider.set(true);
                    String foramtedDate = DateFormat('dd-MM-yyyy')
                        .format(preStudents[index].date);
                    print("${preStudents.length}");
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Card(
                        child: ListTile(
                          tileColor: Colors.pink.shade50,
                          title: Text(
                              "${preStudents[index].studentName}",
                              style: TextStyle(fontSize: 20),softWrap: true,overflow: TextOverflow.clip),
                          subtitle: Text("ID : ${preStudents[index].studentId}"),
                          trailing: Text("${foramtedDate}"),
                        ),
                      ),
                    );
                  }else{
                    if(!modelProvider.isP){
                      modelProvider.set(true);
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Center(child: Text("No Record found")),
                      );
                    }else{
                      modelProvider.set(true);
                      return SizedBox();
                    }
                  }

                }
                else {
                  return SizedBox(
                  );
                }
              }
          );
        }
    );
  }
}
