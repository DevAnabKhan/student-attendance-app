import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_attendence/lib/screens/students/student.dart';
import 'package:student_attendence/lib/screens/teachers/teacher.dart';
import 'attendence.dart';
import 'attendence_record/record.dart';
import 'dashboard_screen.dart';
import 'grades/student_grade.dart';

var currentPage = DrawerSection.dashboard;

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              MyHeaderDrawer(),
              MyDrawerList(context, 1, "DashBoard", Icons.home_sharp,
                  currentPage == DrawerSection.dashboard ? true : false),
              MyDrawerList(context, 2, "Attendance Record", Icons.file_copy,
                  currentPage == DrawerSection.studentrecord ? true : false),
              //MyDrawerList(context,3,"Mark Attendance",Icons.pending_actions_rounded ,currentPage == DrawerSection.markattendace ? true : false),
              MyDrawerList(context, 3, "Teacher", Icons.person,
                  currentPage == DrawerSection.teacher ? true : false),
              MyDrawerList(context, 4, "Student", Icons.perm_identity_rounded,
                  currentPage == DrawerSection.student ? true : false),
              MyDrawerList(context, 5, "Grades", Icons.class_outlined,
                  currentPage == DrawerSection.grade ? true : false),
              MyDrawerList(context, 6, "Today", Icons.pending_actions_rounded,
                  currentPage == DrawerSection.attendence ? true : false),
            ],
          ),
        ),
      ),
    );
  }
}

Widget MyHeaderDrawer() {
  return Container(
    color: Color(0xFFD549CF),
    width: double.infinity,
    height: 200,
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Image(
            image: AssetImage("assets/logo1.png"),
          ),
        ),
      ),
    ),
  );
}

Widget MyDrawerList(
    BuildContext context, int id, String title, IconData icon, bool selected) {
  return Material(
    child: InkWell(
      child: StatefulBuilder(
        builder: (context, myStatefun) {
          return ListTile(
            leading: Icon(icon, color: Colors.black),
            title: Text(
              "${title}",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              myStatefun(
                () {
                  if (id == 1) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DashBoard()));
                  } else if (id == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentRecord()));
                  } else if (id == 3) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherFunction()));
                  } else if (id == 4) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentFunction()));
                  } else if (id == 5) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentGrade()));
                  } else if (id == 6) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Attendence()));
                  }
                },
              );
            },
          );
        },
      ),
    ),
  );
}

enum DrawerSection {
  dashboard,
  studentrecord,
  attendence,
  teacher,
  student,
  grade,
}
