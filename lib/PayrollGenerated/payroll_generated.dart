import 'dart:io';
import 'package:my_app/models/payroll_list_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class PayrollPdfGenerator {
  static Future<void> generatePayrollPdf(PayrollListModel payrollData) async {
    final pdf = pw.Document();

    // Add pages to PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            _buildHeader(payrollData),
            pw.SizedBox(height: 20),
            
            // Summary Section
            _buildSummarySection(payrollData),
            pw.SizedBox(height: 20),
            
            // Payroll Table
            _buildPayrollTable(payrollData.payrollRecords),
          ];
        },
      ),
    );

    // Save and open PDF
    await _savePdf(pdf, 'payroll_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static pw.Widget _buildHeader(PayrollListModel payrollData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PAYROLL REPORT',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.Divider(thickness: 2),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Organization: ${payrollData.organization}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('Status: ${payrollData.status}',
                    style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}',
                    style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Total Records: ${payrollData.payrollRecords.length}',
                    style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSummarySection(PayrollListModel payrollData) {
    double totalBasicSalary = payrollData.payrollRecords
        .fold(0, (sum, record) => sum + record.basicSalary);
    double totalNetSalary = payrollData.payrollRecords
        .fold(0, (sum, record) => sum + record.netSalary);
    double totalOvertimeSalary = payrollData.payrollRecords
        .fold(0, (sum, record) => sum + record.overtimeSalary);
    int generatedCount = payrollData.payrollRecords
        .where((record) => record.payrollGenerated).length;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('SUMMARY',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Total Basic Salary', 'Rs ${totalBasicSalary.toStringAsFixed(2)}'),
              _buildSummaryItem('Total Net Salary', 'Rs ${totalNetSalary.toStringAsFixed(2)}'),
              _buildSummaryItem('Total Overtime', 'Rs ${totalOvertimeSalary.toStringAsFixed(2)}'),
              _buildSummaryItem('Generated', '$generatedCount/${payrollData.payrollRecords.length}'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildPayrollTable(List<PayrollRecord> records) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('PAYROLL DETAILS',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(40),  // ID
            1: const pw.FlexColumnWidth(2),   // Name
            2: const pw.FlexColumnWidth(1.5), // Department
            3: const pw.FixedColumnWidth(60), // Month
            4: const pw.FixedColumnWidth(70), // Basic Salary
            5: const pw.FixedColumnWidth(50), // Present Days
            6: const pw.FixedColumnWidth(70), // Net Salary
            7: const pw.FixedColumnWidth(50), // Status
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('ID', isHeader: true),
                _buildTableCell('Employee Name', isHeader: true),
                _buildTableCell('Department', isHeader: true),
                _buildTableCell('Month', isHeader: true),
                _buildTableCell('Basic Salary', isHeader: true),
                _buildTableCell('Present Days', isHeader: true),
                _buildTableCell('Net Salary', isHeader: true),
                _buildTableCell('Status', isHeader: true),
              ],
            ),
            // Data rows
            ...records.map((record) => pw.TableRow(
              children: [
                _buildTableCell(record.employeeId.toString()),
                _buildTableCell(record.employeeName),
                _buildTableCell(record.department),
                _buildTableCell(record.month),
                _buildTableCell('Rs ${record.basicSalary.toStringAsFixed(0)}'),
                _buildTableCell('${record.presentDays.toStringAsFixed(1)}/${record.totalDays}'),
                _buildTableCell('Rs ${record.netSalary.toStringAsFixed(2)}'),
                _buildTableCell(record.payrollGenerated ? '✓' : '✗',
                    color: record.payrollGenerated ? PdfColors.green : PdfColors.red),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, PdfColor? color}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
        textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
      ),
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

  // Alternative method to generate individual employee payslip
  static Future<void> generateEmployeePayslip(PayrollRecord employee, String organization) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return _buildPayslipContent(employee, organization);
        },
      ),
    );

    await _savePdf(pdf, 'payslip_${employee.employeeName}_${employee.month}.pdf');
  }

  static pw.Widget _buildPayslipContent(PayrollRecord employee, String organization) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(32),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Payslip Header
          pw.Center(
            child: pw.Text(
              'PAYSLIP',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          
          // Company and Employee Info
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Organization: $organization',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Month: ${employee.month}', style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Employee ID: ${employee.employeeId}',
                      style: const pw.TextStyle(fontSize: 12)),
                  pw.Text('Generated: ${DateTime.now().toString().split(' ')[0]}',
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),
          
          // Employee Details
          _buildPayslipSection('EMPLOYEE DETAILS', [
            ['Employee Name', employee.employeeName],
            ['Department', employee.department],
            ['Employee ID', employee.employeeId.toString()],
          ]),
          
          pw.SizedBox(height: 20),
          
          // Attendance Details
          _buildPayslipSection('ATTENDANCE DETAILS', [
            ['Total Days', employee.totalDays.toString()],
            ['Present Days', employee.presentDays.toStringAsFixed(1)],
            ['Absent Days', employee.absentDays.toStringAsFixed(1)],
          ]),
          
          pw.SizedBox(height: 20),
          
          // Salary Details
          _buildPayslipSection('SALARY DETAILS', [
            ['Basic Salary', 'Rs ${employee.basicSalary.toStringAsFixed(2)}'],
            ['Overtime Salary', 'Rs ${employee.overtimeSalary.toStringAsFixed(2)}'],
            ['Net Salary', 'Rs ${employee.netSalary.toStringAsFixed(2)}'],
          ]),
          
          pw.Spacer(),
          
          // Footer
          pw.Center(
            child: pw.Text(
              'This is a computer-generated payslip and does not require a signature.',
              style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPayslipSection(String title, List<List<String>> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            children: data.map((row) => pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(row[0], style: const pw.TextStyle(fontSize: 12)),
                  pw.Text(row[1], style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}