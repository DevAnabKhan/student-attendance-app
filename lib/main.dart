import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_attendence/hive/model_class.dart';
import 'package:student_attendence/provider/model_class.dart';
import 'package:student_attendence/splash_screen/splash_screen.dart';

import 'boxes/boxes.dart';
bool isTeacherEmpty = false;
// Add default grades
Future<void> ensureDefaultGrades() async {
  Box<Grade> gradeBox = await Boxes.getGradeData();
  if(gradeBox.isEmpty){
    await gradeBox.add(Grade("Class 1st"));
    await gradeBox.add(Grade("Class 2nd"));
  }
}
// Add teacher screen
Future<void> ensureDefaultTeacher() async {
  Box<Teacher> teacherBox = await Boxes.getTeacherData();
  if(teacherBox.isEmpty){
    isTeacherEmpty = true;
  }else{
    isTeacherEmpty = false;
  }

}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ModelProvider modelProvider = ModelProvider();
  await modelProvider.loadFromPreference();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(AttendanceAdapter());
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(GradeAdapter());
  await Hive.openBox<Student>('Student');
  await Hive.openBox<Attendance>('Attendance');
  await Hive.openBox<Teacher>('Teacher');
  await Hive.openBox<Grade>('Grade');
  await ensureDefaultGrades();
  await ensureDefaultTeacher();
  runApp(
    ChangeNotifierProvider<ModelProvider>.value(
      value : modelProvider,
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:SplashScreen(checkteacherData: isTeacherEmpty,),
    );
  }
}

