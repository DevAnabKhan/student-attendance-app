import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/provider/model_class.dart';

import '../boxes/boxes.dart';
import '../hive/model_class.dart';

class SpecificPresent extends StatelessWidget {
  DateTime? specificDate;
  SpecificPresent({super.key, this.specificDate});
  //bool isPresent = true;
  @override
  Widget build(BuildContext context) {
    ModelProvider modelProvider = Provider.of(context,listen: false);
    return ValueListenableBuilder<Box<Attendance>>(
        valueListenable: Boxes.getAttendanceData().listenable(),
        builder: (context, Box<Attendance> box,Widget? child){
          var preStudents = box.values.toList().cast();
          modelProvider.set(false);
          return  ListView.builder(
              itemCount: box.length,
              itemBuilder: (context , index){
                // bool  value = preStudents[index].date != today;
                // print('valueeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${value}');
                if(preStudents[index].isPresent) {
                  // for(int i = 0 ; i<box.length;i++){
                  //   print('${preStudents[index].studentName}');
                  // }
                  DateTime studentDate = preStudents[index].date;
                  if(
                      studentDate.year == specificDate!.year &&
                      studentDate.month == specificDate!.month &&
                      studentDate.day == specificDate!.day
                  ){
                    modelProvider.set(true);
                    String foramtedDate = DateFormat('dd-MM-yyyy').format(preStudents[index].date);
                    print("${box.length}");
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: ListTile(
                          tileColor: Colors.orange.shade50,
                          title: Text("${preStudents[index].studentName}",
                            style: TextStyle(fontSize: 20),softWrap: true,overflow: TextOverflow.clip,),
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
                        child: Text("No Record found"),
                      );
                    }else{
                      modelProvider.set(true);
                      return SizedBox();
                    }
                  }

                }
                else{
                  return SizedBox();
                }
              }
          );
        }
    );
  }
}
