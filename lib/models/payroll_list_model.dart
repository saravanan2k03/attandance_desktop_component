class PayrollListModel {
  String status;
  String organization;
  List<PayrollRecord> payrollRecords;

  PayrollListModel({
    required this.status,
    required this.organization,
    required this.payrollRecords,
  });

  factory PayrollListModel.fromJson(Map<String, dynamic> json) {
    return PayrollListModel(
      status: json['status'] ?? '',
      organization: json['organization'] ?? '',
      payrollRecords:
          (json['payroll_records'] as List<dynamic>?)
              ?.map((e) => PayrollRecord.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PayrollRecord {
  int employeeId;
  String employeeName;
  String department;
  String month;
  double basicSalary;
  int totalDays;
  double presentDays;
  double absentDays;
  double overtimeSalary;
  double netSalary;
  bool payrollGenerated;

  PayrollRecord({
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.month,
    required this.basicSalary,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.overtimeSalary,
    required this.netSalary,
    required this.payrollGenerated,
  });

  factory PayrollRecord.fromJson(Map<String, dynamic> json) {
    return PayrollRecord(
      employeeId: json['employee_id'] ?? 0,
      employeeName: json['employee_name'] ?? '',
      department: json['department'] ?? '',
      month: json['month'] ?? '',
      basicSalary: (json['basic_salary'] ?? 0).toDouble(),
      totalDays: json['total_days'] ?? 0,
      presentDays: (json['present_days'] ?? 0).toDouble(),
      absentDays: (json['absent_days'] ?? 0).toDouble(),
      overtimeSalary: (json['overtime_salary'] ?? 0).toDouble(),
      netSalary: (json['net_salary'] ?? 0).toDouble(),
      payrollGenerated: json['payroll_generated'] ?? false,
    );
  }
}
