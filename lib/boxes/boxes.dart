import 'package:hive/hive.dart';
import 'package:student_attendence/hive/model_class.dart';

class Boxes{
  static Box<Student> getData()=>Hive.box<Student>("Student");
  static Box<Attendance> getAttendanceData()=>Hive.box<Attendance>("Attendance");
  static Box<Teacher> getTeacherData()=>Hive.box<Teacher>("Teacher");
  static Box<Grade> getGradeData()=>Hive.box<Grade>("Grade");
}