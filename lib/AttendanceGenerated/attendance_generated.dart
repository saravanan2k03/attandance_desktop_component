import 'dart:io';
import 'dart:typed_data';
import 'package:my_app/models/attendance_list.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendancePdfGenerator {
  static Future<void> generateAttendanceReport(AttendanceListModel attendanceData, String organizationName) async {
    final pdf = pw.Document();

    // Add pages to PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape, // Landscape for better table fit
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            // Header
            _buildHeader(attendanceData, organizationName),
            pw.SizedBox(height: 15),
            
            // Summary Section
            _buildSummarySection(attendanceData),
            pw.SizedBox(height: 15),
            
            // Department-wise Summary
            _buildDepartmentSummary(attendanceData),
            pw.SizedBox(height: 15),
            
            // Attendance Table
            _buildAttendanceTable(attendanceData.records),
          ];
        },
      ),
    );

    // Save and open PDF
    await _savePdf(pdf, 'attendance_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static pw.Widget _buildHeader(AttendanceListModel attendanceData, String organizationName) {
    // Get date range from records
    String dateRange = '';
    if (attendanceData.records.isNotEmpty) {
      List<String> dates = attendanceData.records.map((r) => r.date).toSet().toList();
      dates.sort();
      if (dates.length == 1) {
        dateRange = dates.first;
      } else {
        dateRange = '${dates.first} to ${dates.last}';
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ATTENDANCE REPORT',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.Text(organizationName,
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Period: $dateRange',
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}',
                    style: pw.TextStyle(fontSize: 10)),
                pw.Text('Total Records: ${attendanceData.records.length}',
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue800),
      ],
    );
  }

  static pw.Widget _buildSummarySection(AttendanceListModel attendanceData) {
    int totalRecords = attendanceData.records.length;
    int presentCount = attendanceData.records.where((r) => r.presentOne == '1' || r.presentTwo == '1').length;
    int absentCount = totalRecords - presentCount;
    int overtimeCount = attendanceData.records.where((r) => r.isOvertime).length;
    
    // Calculate total work hours
    double totalWorkHours = 0;
    double totalOvertimeHours = 0;
    
    for (var record in attendanceData.records) {
      try {
        totalWorkHours += double.tryParse(record.workHours) ?? 0;
        totalOvertimeHours += double.tryParse(record.overtimeHours) ?? 0;
      } catch (e) {
        // Handle parsing errors gracefully
      }
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('ATTENDANCE SUMMARY',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Total Records', totalRecords.toString(), PdfColors.blue),
              _buildSummaryItem('Present', presentCount.toString(), PdfColors.green),
              _buildSummaryItem('Absent', absentCount.toString(), PdfColors.red),
              _buildSummaryItem('Overtime', overtimeCount.toString(), PdfColors.orange),
              _buildSummaryItem('Work Hours', '${totalWorkHours.toStringAsFixed(1)}h', PdfColors.purple),
              _buildSummaryItem('OT Hours', '${totalOvertimeHours.toStringAsFixed(1)}h', PdfColors.brown),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDepartmentSummary(AttendanceListModel attendanceData) {
    // Group by department
    Map<String, List<AttendanceRecord>> departmentGroups = {};
    for (var record in attendanceData.records) {
      if (!departmentGroups.containsKey(record.department)) {
        departmentGroups[record.department] = [];
      }
      departmentGroups[record.department]!.add(record);
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('DEPARTMENT-WISE SUMMARY',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Department', isHeader: true),
                  _buildTableCell('Total', isHeader: true),
                  _buildTableCell('Present', isHeader: true),
                  _buildTableCell('Absent', isHeader: true),
                  _buildTableCell('Overtime', isHeader: true),
                ],
              ),
              ...departmentGroups.entries.map((entry) {
                int total = entry.value.length;
                int present = entry.value.where((r) => r.presentOne == '1' || r.presentTwo == '1').length;
                int absent = total - present;
                int overtime = entry.value.where((r) => r.isOvertime).length;
                
                return pw.TableRow(
                  children: [
                    _buildTableCell(entry.key),
                    _buildTableCell(total.toString()),
                    _buildTableCell(present.toString(), color: PdfColors.green),
                    _buildTableCell(absent.toString(), color: PdfColors.red),
                    _buildTableCell(overtime.toString(), color: PdfColors.orange),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }

  static pw.Widget _buildAttendanceTable(List<AttendanceRecord> records) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('DETAILED ATTENDANCE RECORDS',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(35),  // ID
            1: const pw.FlexColumnWidth(1.5), // Name
            2: const pw.FlexColumnWidth(1),   // Department
            3: const pw.FlexColumnWidth(1),   // Designation
            4: const pw.FixedColumnWidth(60), // Date
            5: const pw.FixedColumnWidth(50), // Check In
            6: const pw.FixedColumnWidth(50), // Check Out
            7: const pw.FixedColumnWidth(45), // Work Hours
            8: const pw.FixedColumnWidth(35), // OT Hours
            9: const pw.FixedColumnWidth(35), // Status
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('ID', isHeader: true),
                _buildTableCell('Employee Name', isHeader: true),
                _buildTableCell('Department', isHeader: true),
                _buildTableCell('Designation', isHeader: true),
                _buildTableCell('Date', isHeader: true),
                _buildTableCell('Check In', isHeader: true),
                _buildTableCell('Check Out', isHeader: true),
                _buildTableCell('Hours', isHeader: true),
                _buildTableCell('OT', isHeader: true),
                _buildTableCell('Status', isHeader: true),
              ],
            ),
            // Data rows
            ...records.map((record) {
              bool isPresent = record.presentOne == '1' || record.presentTwo == '1';
              String status = isPresent ? '✓' : '✗';
              PdfColor statusColor = isPresent ? PdfColors.green : PdfColors.red;
              
              return pw.TableRow(
                children: [
                  _buildTableCell(record.employeeId.toString()),
                  _buildTableCell(record.employeeName),
                  _buildTableCell(record.department),
                  _buildTableCell(record.designation),
                  _buildTableCell(record.date),
                  _buildTableCell(record.checkIn),
                  _buildTableCell(record.checkOut),
                  _buildTableCell(record.workHours),
                  _buildTableCell(record.overtimeHours, 
                      color: record.isOvertime ? PdfColors.orange : null),
                  _buildTableCell(status, color: statusColor),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, PdfColor? color}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 8 : 7,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
        textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
        maxLines: 2,
        overflow: pw.TextOverflow.clip,
      ),
    );
  }

  // Individual Employee Attendance Sheet
  static Future<void> generateEmployeeAttendanceSheet(
    List<AttendanceRecord> employeeRecords, 
    String organizationName
  ) async {
    if (employeeRecords.isEmpty) return;
    
    final pdf = pw.Document();
    final employee = employeeRecords.first;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildEmployeeSheetHeader(employee, organizationName, employeeRecords.length),
            pw.SizedBox(height: 20),
            _buildEmployeeStats(employeeRecords),
            pw.SizedBox(height: 20),
            _buildEmployeeAttendanceTable(employeeRecords),
          ];
        },
      ),
    );

    await _savePdf(pdf, 'attendance_${employee.employeeName}_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static pw.Widget _buildEmployeeSheetHeader(AttendanceRecord employee, String organizationName, int recordCount) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            'INDIVIDUAL ATTENDANCE SHEET',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 20),
        
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Organization: $organizationName',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('Generated: ${DateTime.now().toString().split(' ')[0]}',
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Total Records: $recordCount',
                    style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        
        // Employee Details
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
            color: PdfColors.grey50,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('EMPLOYEE DETAILS',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Employee ID: ${employee.employeeId}',
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text('Name: ${employee.employeeName}',
                          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Department: ${employee.department}',
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text('Designation: ${employee.designation}',
                          style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildEmployeeStats(List<AttendanceRecord> records) {
    int totalDays = records.length;
    int presentDays = records.where((r) => r.presentOne == '1' || r.presentTwo == '1').length;
    int absentDays = totalDays - presentDays;
    int overtimeDays = records.where((r) => r.isOvertime).length;
    
    double totalHours = 0;
    double totalOTHours = 0;
    
    for (var record in records) {
      totalHours += double.tryParse(record.workHours) ?? 0;
      totalOTHours += double.tryParse(record.overtimeHours) ?? 0;
    }
    
    double attendancePercentage = totalDays > 0 ? (presentDays / totalDays) * 100 : 0;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('ATTENDANCE STATISTICS',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total Days', totalDays.toString()),
              _buildStatItem('Present', presentDays.toString()),
              _buildStatItem('Absent', absentDays.toString()),
              _buildStatItem('Overtime Days', overtimeDays.toString()),
              _buildStatItem('Attendance %', '${attendancePercentage.toStringAsFixed(1)}%'),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total Hours', '${totalHours.toStringAsFixed(1)}h'),
              _buildStatItem('OT Hours', '${totalOTHours.toStringAsFixed(1)}h'),
              _buildStatItem('Avg Hours/Day', '${(totalHours / totalDays).toStringAsFixed(1)}h'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildEmployeeAttendanceTable(List<AttendanceRecord> records) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('ATTENDANCE DETAILS',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Date', isHeader: true),
                _buildTableCell('Shift', isHeader: true),
                _buildTableCell('Check In', isHeader: true),
                _buildTableCell('Check Out', isHeader: true),
                _buildTableCell('Work Hours', isHeader: true),
                _buildTableCell('OT Hours', isHeader: true),
                _buildTableCell('Status', isHeader: true),
              ],
            ),
            ...records.map((record) {
              bool isPresent = record.presentOne == '1' || record.presentTwo == '1';
              String status = isPresent ? 'Present' : 'Absent';
              PdfColor statusColor = isPresent ? PdfColors.green : PdfColors.red;
              
              return pw.TableRow(
                children: [
                  _buildTableCell(record.date),
                  _buildTableCell(record.workshift),
                  _buildTableCell(record.checkIn),
                  _buildTableCell(record.checkOut),
                  _buildTableCell(record.workHours),
                  _buildTableCell(record.overtimeHours, 
                      color: record.isOvertime ? PdfColors.orange : null),
                  _buildTableCell(status, color: statusColor),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  static Future<void> _savePdf(pw.Document pdf, String fileName) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }

      // Get directory path
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final path = '${directory.path}/$fileName';
        final file = File(path);
        
        // Save PDF
        await file.writeAsBytes(await pdf.save());
        
        print('PDF saved to: $path');
        
        // Open the PDF
        await OpenFile.open(path);
      }
    } catch (e) {
      print('Error saving PDF: $e');
      throw Exception('Failed to save PDF: $e');
    }
  }

  // Generate monthly attendance summary
  static Future<void> generateMonthlyAttendanceSummary(
    AttendanceListModel attendanceData, 
    String organizationName,
    String month,
    String year
  ) async {
    final pdf = pw.Document();

    // Group by employee
    Map<int, List<AttendanceRecord>> employeeGroups = {};
    for (var record in attendanceData.records) {
      if (!employeeGroups.containsKey(record.employeeId)) {
        employeeGroups[record.employeeId] = [];
      }
      employeeGroups[record.employeeId]!.add(record);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildMonthlySummaryHeader(organizationName, month, year, employeeGroups.length),
            pw.SizedBox(height: 20),
            _buildMonthlySummaryTable(employeeGroups),
          ];
        },
      ),
    );

    await _savePdf(pdf, 'monthly_attendance_${month}_${year}_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static pw.Widget _buildMonthlySummaryHeader(String organizationName, String month, String year, int employeeCount) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            'MONTHLY ATTENDANCE SUMMARY',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Organization: $organizationName',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('Period: $month $year',
                    style: pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Total Employees: $employeeCount',
                    style: pw.TextStyle(fontSize: 12)),
                pw.Text('Generated: ${DateTime.now().toString().split(' ')[0]}',
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  static pw.Widget _buildMonthlySummaryTable(Map<int, List<AttendanceRecord>> employeeGroups) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Employee ID', isHeader: true),
            _buildTableCell('Name', isHeader: true),
            _buildTableCell('Department', isHeader: true),
            _buildTableCell('Total Days', isHeader: true),
            _buildTableCell('Present', isHeader: true),
            _buildTableCell('Absent', isHeader: true),
            _buildTableCell('Attendance %', isHeader: true),
            _buildTableCell('Total Hours', isHeader: true),
            _buildTableCell('OT Hours', isHeader: true),
          ],
        ),
        ...employeeGroups.entries.map((entry) {
          List<AttendanceRecord> records = entry.value;
          AttendanceRecord employee = records.first;
          
          int totalDays = records.length;
          int presentDays = records.where((r) => r.presentOne == '1' || r.presentTwo == '1').length;
          int absentDays = totalDays - presentDays;
          double attendancePercentage = totalDays > 0 ? (presentDays / totalDays) * 100 : 0;
          
          double totalHours = 0;
          double totalOTHours = 0;
          
          for (var record in records) {
            totalHours += double.tryParse(record.workHours) ?? 0;
            totalOTHours += double.tryParse(record.overtimeHours) ?? 0;
          }
          
          return pw.TableRow(
            children: [
              _buildTableCell(employee.employeeId.toString()),
              _buildTableCell(employee.employeeName),
              _buildTableCell(employee.department),
              _buildTableCell(totalDays.toString()),
              _buildTableCell(presentDays.toString(), color: PdfColors.green),
              _buildTableCell(absentDays.toString(), color: PdfColors.red),
              _buildTableCell('${attendancePercentage.toStringAsFixed(1)}%'),
              _buildTableCell('${totalHours.toStringAsFixed(1)}h'),
              _buildTableCell('${totalOTHours.toStringAsFixed(1)}h'),
            ],
          );
        }).toList(),
      ],
    );
  }
}