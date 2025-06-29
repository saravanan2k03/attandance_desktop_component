import 'package:flutter/material.dart';
import 'package:my_app/PayrollGenerated/payroll_generated.dart';
import 'package:my_app/models/payroll_list_model.dart';

class PayrollPdfScreen extends StatefulWidget {
  final PayrollListModel payrollData;

  const PayrollPdfScreen({Key? key, required this.payrollData}) : super(key: key);

  @override
  _PayrollPdfScreenState createState() => _PayrollPdfScreenState();
}

class _PayrollPdfScreenState extends State<PayrollPdfScreen> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll PDF Generator'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payroll Summary',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem('Organization', widget.payrollData.organization),
                        _buildSummaryItem('Status', widget.payrollData.status),
                        _buildSummaryItem('Records', widget.payrollData.payrollRecords.length.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGenerating ? null : _generateFullReport,
                    icon: _isGenerating 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate Full Report'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGenerating ? null : () => _showEmployeeSelection(),
                    icon: const Icon(Icons.person),
                    label: const Text('Individual Payslip'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Employee List
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Employee Records',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.payrollData.payrollRecords.length,
                        itemBuilder: (context, index) {
                          final record = widget.payrollData.payrollRecords[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(record.employeeId.toString()),
                            ),
                            title: Text(record.employeeName),
                            subtitle: Text('${record.department} | ${record.month}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${record.netSalary.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  record.payrollGenerated ? Icons.check_circle : Icons.cancel,
                                  color: record.payrollGenerated ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                              ],
                            ),
                            onTap: () => _generateIndividualPayslip(record),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _generateFullReport() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      await PayrollPdfGenerator.generatePayrollPdf(widget.payrollData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF generated and saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _generateIndividualPayslip(PayrollRecord record) async {
    try {
      await PayrollPdfGenerator.generateEmployeePayslip(
        record,
        widget.payrollData.organization,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payslip for ${record.employeeName} generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating payslip: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEmployeeSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Employee'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.payrollData.payrollRecords.length,
              itemBuilder: (context, index) {
                final record = widget.payrollData.payrollRecords[index];
                return ListTile(
                  title: Text(record.employeeName),
                  subtitle: Text('ID: ${record.employeeId} | ${record.department}'),
                  onTap: () {
                    Navigator.pop(context);
                    _generateIndividualPayslip(record);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

// Example usage in your main app
class PayrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll PDF Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<PayrollListModel>(
        future: _loadPayrollData(), // Your method to load data
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PayrollPdfScreen(payrollData: snapshot.data!);
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Future<PayrollListModel> _loadPayrollData() async {
    // Replace this with your actual data loading logic
    // This could be from an API, database, or local storage
    
    // Example dummy data
  final Map<String, dynamic> dummyJson = {
  'status': 'Active',
  'organization': 'Tech Solutions Inc.',
  'payroll_records': [
    {
      'employee_id': 1001,
      'employee_name': 'John Doe',
      'department': 'Engineering',
      'month': 'January 2024',
      'basic_salary': 50000.0,
      'total_days': 31,
      'present_days': 28.0,
      'absent_days': 3.0,
      'overtime_salary': 5000.0,
      'net_salary': 52000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1002,
      'employee_name': 'Jane Smith',
      'department': 'Finance',
      'month': 'February 2024',
      'basic_salary': 55000.0,
      'total_days': 28,
      'present_days': 26.0,
      'absent_days': 2.0,
      'overtime_salary': 4000.0,
      'net_salary': 57000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1003,
      'employee_name': 'Alice Johnson',
      'department': 'HR',
      'month': 'March 2024',
      'basic_salary': 48000.0,
      'total_days': 31,
      'present_days': 29.0,
      'absent_days': 2.0,
      'overtime_salary': 3000.0,
      'net_salary': 50000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1004,
      'employee_name': 'Bob Brown',
      'department': 'Sales',
      'month': 'April 2024',
      'basic_salary': 52000.0,
      'total_days': 30,
      'present_days': 27.0,
      'absent_days': 3.0,
      'overtime_salary': 2500.0,
      'net_salary': 53000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1005,
      'employee_name': 'Carol White',
      'department': 'Engineering',
      'month': 'May 2024',
      'basic_salary': 60000.0,
      'total_days': 31,
      'present_days': 30.0,
      'absent_days': 1.0,
      'overtime_salary': 3500.0,
      'net_salary': 63000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1006,
      'employee_name': 'David Wilson',
      'department': 'Marketing',
      'month': 'June 2024',
      'basic_salary': 47000.0,
      'total_days': 30,
      'present_days': 28.0,
      'absent_days': 2.0,
      'overtime_salary': 2000.0,
      'net_salary': 49000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1007,
      'employee_name': 'Emma Moore',
      'department': 'Finance',
      'month': 'January 2024',
      'basic_salary': 51000.0,
      'total_days': 31,
      'present_days': 29.5,
      'absent_days': 1.5,
      'overtime_salary': 3000.0,
      'net_salary': 54000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1008,
      'employee_name': 'Frank Taylor',
      'department': 'HR',
      'month': 'February 2024',
      'basic_salary': 49000.0,
      'total_days': 28,
      'present_days': 26.0,
      'absent_days': 2.0,
      'overtime_salary': 2200.0,
      'net_salary': 51000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1009,
      'employee_name': 'Grace Lee',
      'department': 'Sales',
      'month': 'March 2024',
      'basic_salary': 53000.0,
      'total_days': 31,
      'present_days': 29.0,
      'absent_days': 2.0,
      'overtime_salary': 4000.0,
      'net_salary': 56000.0,
      'payroll_generated': true,
    },
    {
      'employee_id': 1010,
      'employee_name': 'Henry Harris',
      'department': 'Marketing',
      'month': 'April 2024',
      'basic_salary': 56000.0,
      'total_days': 30,
      'present_days': 28.5,
      'absent_days': 1.5,
      'overtime_salary': 3200.0,
      'net_salary': 59000.0,
      'payroll_generated': true,
    },
  ],
};

    
    return PayrollListModel.fromJson(dummyJson);
  }
}