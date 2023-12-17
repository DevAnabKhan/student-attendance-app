import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:student_attendence/screens/dashboard_screen.dart';

import '../boxes/boxes.dart';
import '../hive/model_class.dart';
import '../screens/attendence.dart';
import '../screens/teachers/add_teacher.dart';

class SplashScreen extends StatefulWidget {
  bool checkteacherData;
  SplashScreen({super.key , required this.checkteacherData});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Box<Teacher> teacherBox = Boxes.getTeacherData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      if(widget.checkteacherData){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AddTeacher()));
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DashBoard()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: Image(image: AssetImage("assets/logo.png"),height : 500,width: 500,)),
          decoration: BoxDecoration(
            gradient:  LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF9D1DBC),Color(0xFFD549CF),Color(0xFFD5A849)],
            ),
          ),
        ),
      ),
    );
  }
}
