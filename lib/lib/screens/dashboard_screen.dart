import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../boxes/boxes.dart';
import '../hive/model_class.dart';
import 'mark_attendance.dart';
import 'menu.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 600,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
              ),
              child: Image(
                image: AssetImage('assets/purpleimage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                height: 80,
                child: Row(
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            size: 25,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Center(
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 190),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    height: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: ValueListenableBuilder<Box<Grade>>(
                          valueListenable: Boxes.getGradeData().listenable(),
                          builder: (context, Box<Grade> box, Widget? child) {
                            var gradeData = box.values.toList().cast();
                            return GridView.builder(
                              //shrinkWrap: true,
                              //physics: NeverScrollableScrollPhysics(),
                              itemCount: gradeData.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MarkAttendance(
                                            gradeClicked:
                                                gradeData[index].grade),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Color(0xFF9D1DBC),
                                    child: Center(
                                      child: Text(
                                        "${gradeData[index].grade}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 3,
                                crossAxisSpacing: 3,
                                maxCrossAxisExtent: 200,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        drawer: Menu(),
      ),
    );
  }
}
