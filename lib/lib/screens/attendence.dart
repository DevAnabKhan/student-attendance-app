import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../tab_bar_screens/absent.dart';
import '../tab_bar_screens/present.dart';
import 'menu.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDate = DateTime.now();
  bool isSame = false;
  bool isSliderVisible = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: width,
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
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
                  Expanded(
                    child: Center(
                      child: Text(
                        "Attendance",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF9D1DBC),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15,
                        offset: Offset(
                          0.0,
                          15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 90),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('${DateFormat("MMM dd,yyyy").format(selectedDate)}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF9D1DBC),
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.clip),
                        ),
                        IconButton(
                          onPressed: () {
                            selectedDay(context);
                          },
                          icon: Icon(Icons.calendar_month_sharp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DefaultTabController(
                  length: 2,
                  child: AnimatedContainer(
                    child: Container(
                      height: MediaQuery.of(context).size.height-300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Color(0xFF9D1DBC),
                            labelStyle: TextStyle(fontSize: 17),
                            unselectedLabelStyle: TextStyle(fontSize: 15),
                            tabs: [
                              Tab(
                                text: 'Present Students',
                              ),
                              Tab(
                                text: 'Absent Students',
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                selectedDate == null
                                    ? Center(
                                  //child: Text('No record Found'),
                                   child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Center(child: Text("No Record found")),
                                    )
                                )
                                    : SpecificPresent(
                                    specificDate: selectedDate),
                                selectedDate == null
                                    ? Center(
                                  //child: Text(''),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Center(child: Text("No Record found")),
                                    )
                                )
                                    : SpecificAbsent(
                                    specificDate: selectedDate),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    duration: Duration(milliseconds: 900),
                  ),
                ),
                 
              ],
            ),
          ),

        ],
      ),
      drawer: Menu(),
    );
  }

  Future<void> selectedDay(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? focusedDay,
      firstDate: DateTime.utc(2021, 01, 01),
      lastDate: DateTime.utc(2030, 01, 01),
    );
    if (picked != null && picked != selectedDate) {
      setState(
        () {
          this.selectedDate = picked;
          print('focused Day${selectedDate}');
          if (selectedDate == DateTime.now()) {
            setState(() {
              isSame = true;
            });
          } else {
            setState(
              () {
                isSame = true;
              },
            );
          }
          print('focused Day${focusedDay}');
        },
      );
    }
  }
}
