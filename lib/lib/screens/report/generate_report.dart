
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import '../../boxes/boxes.dart';
import '../../hive/model_class.dart';

late String textContent;
class GenerateReport extends StatefulWidget {
  const GenerateReport({super.key});

  @override
  State<GenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  Box<Attendance> attendanceBox = Boxes.getAttendanceData();
  Box<Teacher> teacherBox = Boxes.getTeacherData();
  Box<Student> studentBox = Boxes.getData();
  List<DataRow> reportRows = [];
  late var teacherData;
  @override
  void initState() {
    super.initState();
    if (teacherBox.isNotEmpty) {
      teacherData = teacherBox.values.first;
    } else {
      teacherData = null;
    }
    generateAttendanceReport();
  }
  //Generate report
  void generateAttendanceReport() {
    // if (teacherBox.isEmpty || attendanceBox.isEmpty || studentBox.isEmpty) {
    //   // Handle the case when boxes are empty
    //   Text("Record is Empty");
    //   return;
    // }
    var studentData = studentBox.values.toList();
    reportRows.clear();
    for (var grade
        in studentData.map((student) => student.studentGrade).toSet()) {
      // Add header information for each grade
      var data = attendanceBox.values.where(
        (attendance) {
          var student = studentData.firstWhere(
            (s) => s.id == attendance.studentId,
            orElse: () => Student('', 0, null, '', '', 0),
          );
          return student.studentGrade == grade;
        },
      ).toList();
      if (data.isNotEmpty) {
        reportRows.add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Roll Number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                Text(
                  'Father\'s Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                Text(
                  'Grade',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                Text(
                  'DateTime',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }

      // Add attendance details for the specific grade
      var attendanceData = attendanceBox.values.where(
        (attendance) {
          var student = studentData.firstWhere(
            (s) => s.id == attendance.studentId,
            orElse: () => Student('', 0, null, '', '', 0),
          );
          return student.studentGrade == grade;
        },
      ).toList();

      for (var attendance in attendanceData) {
        var student = studentData.firstWhere(
          (s) => s.id == attendance.studentId,
          orElse: () => Student('', 0, null, '', '', 0),
        );
        var row = DataRow(
          cells: [
            DataCell(
              Text('${student.rollNo}'),
            ),
            DataCell(
              Text('${student.name}'),
            ),
            DataCell(
              Text('${student.fatherName}'),
            ),
            DataCell(
              Text('${student.studentGrade}'),
            ),
            DataCell(
              Text('${attendance.isPresent ? 'Present' : 'Absent'}'),
            ),
            DataCell(
              Text('${attendance.date}'),
            ),
          ],
        );
        reportRows.add(row);
      }
    }
    setState(
      () {},
    );
  }

  //Generate Excel file
  // Future<void> generateExcel() async {
  //   final excel = Excel.createExcel();
  //   final sheet = excel['Sheet1'];
  //
  //   //sheet.appendRow(reportRows[0].cells.map((cell) => cell.child is DataCell ? CellValue(cell.child!.toString()) : CellValue('')).toList());
  //   // // Add data rows
  //   // for (var row in reportRows) {
  //   // sheet.appendRow(rep[0].cells.map((cell) {
  //   //   if (cell.child is DataCell) {
  //   //     return cell.child!.toString();
  //   //   }
  //   //   return '';
  //   // }).toList());
  //   // }
  //   // Add header row
  //   // List<Cell?> headerRow = [
  //   //   Cell('Roll Number'),
  //   //   Cell('Name'),
  //   //   Cell('Father Name'),
  //   //   Cell('Status'),
  //   //   Cell('Date'),
  //   // ];
  //   //
  //   // // Use the appendRow method with the list of nullable Cell instances for the header
  //   // sheet.appendRow(headerRow.cast<CellValue?>());
  //   //  for(var rowData in reportRows){
  //   //    sheet.appendRow(rowData.toString() as List<CellValue?>);
  //   //  }
  //   // Add data rows
  //   for (var rowData in reportRows) {
  //     sheet.appendRow(rowData as List<CellValue?>);
  //   }
  //
  //   // Add data rows
  //   for (var rowData in reportRows) {
  //     // Convert each cell in the row to a CellValue instance
  //     var rowValues = rowData.cells.map((cell) => CellValue(cell.child.toString())).toList();
  //
  //     // Use the appendRow method with the list of nullable CellValue instances for the data rows
  //     sheet.appendRow(rowValues.cast<CellValue?>());
  //   }
  //
  //   // Get the external storage directory
  //   final output = await getExternalStorageDirectory();
  //   if (output != null) {
  //     final excelPath = "${output.path}/attendance_data.xlsx";
  //     final bytes = await excel.encode();
  //     if (bytes != null) {
  //       io.File(excelPath).writeAsBytesSync(bytes);
  //       debugPrint("Excel file saved at: $excelPath");
  //     }
  //   } else {
  //     // Handle the case when the output directory is null
  //     print('Error: Unable to get external storage directory');
  //   }
  // }


  //Generate Pdf function
    Future<Uint8List> generatePDF() async {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) =>
              pw.ConstrainedBox(
                constraints: pw.BoxConstraints.expand(),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text(
                          'Attendence Record',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 20,
                              color: PdfColors.amber900),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    // Display Teacher Details
                    pw.Text(
                      'Teacher\'s Name: ${teacherData?.teaName ?? 'N/A'}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Teacher\'s ID: ${teacherData?.teaId ?? 'N/A'}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Teacher\'s Designation: ${teacherData?.teaDesignation ??
                          'N/A'}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        // Add a header row
                        pw.TableRow(
                          children: [
                            pw.Text(
                              'Roll Number',
                              style: pw.TextStyle(fontWeight: pw.FontWeight
                                  .bold),
                            ),
                            pw.Text(
                              'Name',
                              style: pw.TextStyle(fontWeight: pw.FontWeight
                                  .bold),
                            ),
                            pw.Text(
                              'Father\'s Name',
                              style: pw.TextStyle(fontWeight: pw.FontWeight
                                  .bold),
                            ),
                            pw.Text(
                              'Grade',
                              style: pw.TextStyle(fontWeight: pw.FontWeight
                                  .bold),
                            ),
                            pw.Text(
                              'Status',
                              style: pw.TextStyle(fontWeight: pw.FontWeight
                                  .bold),
                            ),
                            pw.Text(
                              'DateTime',
                              style: pw.TextStyle(fontWeight: pw.FontWeight
                                  .bold),
                            ),
                          ],
                        ),
                        // Add rows with data
                        for (var row in reportRows)
                          pw.TableRow(
                            children: [
                              for (var cell in row.cells)
                                pw.Container(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text('${(cell.child.toString())}',
                                      style: pw.TextStyle(fontSize: 10)),
                                ),
                            ],
                          ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
        ),
      );
      // Save pdf in phone storage
      final output = await getExternalStorageDirectory();
      debugPrint("${output?.path}/attendence_report.pdf");
      final path = "${output?.path}/attendence_report.pdf";
      await io.File(path).writeAsBytes(await pdf.save());
      await OpenFile.open(path);
      return pdf.save();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Report'),
        actions: [
          IconButton(
            onPressed: () {
              generatePDF();
            },
            icon: Icon(
              Icons.picture_as_pdf,
              color: Colors.purple,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     //generateExcel();
          //   },
          //   icon: Icon(
          //     Icons.import_export,
          //     color: Colors.purple,
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Teacher Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Teacher\'s Name: ${teacherData?.teaName ?? 'N/A'}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Teacher\'s ID: ${teacherData?.teaId ?? 'N/A'}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Teacher\'s Designation: ${teacherData?.teaDesignation ?? 'N/A'}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                ],
                rows: reportRows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Cell {
  String? cellValueString;
  Cell( this.cellValueString);
}
// class CellValue {
//   String value;
//
//   CellValue(this.value);
// }
