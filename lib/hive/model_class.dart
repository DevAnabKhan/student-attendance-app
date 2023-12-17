
import 'package:hive/hive.dart';
part 'model_class.g.dart';

@HiveType(typeId:1)
class Student extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  int id;
  @HiveField(2)
  DateTime? dateTime;
  @HiveField(3)
  String fatherName;
  @HiveField(4)
  String studentGrade;
  @HiveField(5)
  int rollNo;
  Student(this.name,this.id,this.dateTime,this.fatherName,this.studentGrade , this.rollNo);
}
@HiveType(typeId:2)
class Attendance extends HiveObject{
  @HiveField(0)
  int studentId;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  bool isPresent;
  @HiveField(3)
  String studentName;
  Attendance(this.studentId,this.date,this.isPresent, this.studentName);
}
@HiveType(typeId:3)
class Teacher extends HiveObject{
  @HiveField(0)
  String teaName;
  @HiveField(1)
  int teaId;
  @HiveField(2)
  String qualification;
  @HiveField(3)
  String teaFatherName;
  @HiveField(4)
  String teaDesignation;
  Teacher(this.teaName,this.teaId,this.qualification,this.teaFatherName,this.teaDesignation);
}
@HiveType(typeId:4)
class Grade extends HiveObject{
  @HiveField(0)
  String grade;
  Grade(this.grade);
}