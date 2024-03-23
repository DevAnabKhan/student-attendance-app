import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelProvider extends ChangeNotifier {
  int _countPresent = 0;
  int _countAbsent = 0;
  int _countAll = 0;
  int _countTeacher = 0;
  bool _isPresent = false;
  late DateTime lastPreDate ;
  late DateTime lastAbsDate ;

  void delete(bool isCheck) {
    if (isCheck) {
      _countPresent = 0;
      _countAbsent = 0;
    }
    _saveToPreferences();
    notifyListeners();
  }

  // DateTime date = DateTime.now();
  //
  // void today(DateTime redate){
  //   if(date == redate){
  //
  //   }
  // }
  // List<int> id = [];
  //
  // void deleted(int id){
  //   this.id.add(id);
  //   print('ssssssssssssss ${id}');
  //   //_saveToPreferences();
  //   notifyListeners();
  // }
  //List<int> get id => _id;
  bool get isP => _isPresent;
  void set(bool flag) {
    _isPresent = flag;
  }
  // DateTime _focused = DateTime.now();
  //
  // DateTime get focused => _focused;
  // void changedDate(DateTime date){
  //   _focused = date;
  // }

  void incrementPresent(DateTime now) {
    _countPresent++;
    lastPreDate = now;
    _saveToPreferences();
    notifyListeners();
  }

  void incrementAbsent(DateTime now) {
    _countAbsent++;
    lastAbsDate = now;
    _saveToPreferences();
    notifyListeners();
  }

  void incrementAll() {
    _countAll++;
    _saveToPreferences();
    notifyListeners();
  }

  void incrementTeacher() {
    _countTeacher++;
    _saveToPreferences();
    notifyListeners();
  }

  void decrementAll() {
    if (_countAll > 0) {
      _countAll--;
      _saveToPreferences();
    }
    notifyListeners();
  }

  void decrementPre() {
    if (_countPresent > 0) {
      _countPresent--;
      _saveToPreferences();
    }
    notifyListeners();
  }

  void decrementTeacher() {
    if (_countTeacher > 0) {
      _countTeacher--;
      _saveToPreferences();
    }
    notifyListeners();
  }

  int get getCountPre => _countPresent;
  int get getCountAbs => _countAbsent;
  int get getCountAll => _countAll;
  int get getCountTea => _countTeacher;

  ModelProvider() {
    loadFromPreference();
  }

  Future<void> loadFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _countPresent = prefs.getInt('present_students') ?? 0;
    _countAbsent = prefs.getInt('Absent_students') ?? 0;
    _countAll = prefs.getInt('All_students') ?? 0;
    _countTeacher = prefs.getInt('Teachers') ?? 0;
    String? lastPreDateStr = prefs.getString('last_pre_date');
    lastPreDate = lastPreDateStr != null ? DateTime.parse(lastPreDateStr) : DateTime.now();
    String? lastAbsDateStr = prefs.getString('last_abs_date');
    lastAbsDate = lastAbsDateStr != null ? DateTime.parse(lastAbsDateStr) : DateTime.now();
    // _id = prefs.getStringList('student_id') ?? [];
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('present_students', _countPresent);
    prefs.setInt('Absent_students', _countAbsent);
    prefs.setInt('All_students', _countAll);
    prefs.setInt('Teachers', _countTeacher);
    prefs.setInt('Teachers', _countTeacher);
    prefs.setString('last_pre_date', lastPreDate.toIso8601String());
    prefs.setString('last_abs_date', lastAbsDate.toIso8601String());
    //prefs.setStringList('student_id', _id);
    notifyListeners();
  }
}
