import 'dart:convert';

class AttendanceListModel {
  final List<AttendanceRecord> records;

  AttendanceListModel({required this.records});

  factory AttendanceListModel.fromJson(String jsonStr) {
    final jsonData = jsonDecode(jsonStr);
    final List<dynamic> recordsJson = jsonData["records"] ?? [];
    return AttendanceListModel(
      records: recordsJson.map((e) => AttendanceRecord.fromMap(e)).toList(),
    );
  }
}

class AttendanceRecord {
  final int attendanceId;
  final int employeeId;
  final String employeeName;
  final String department;
  final String designation;
  final String workshift;
  final String date;
  final String checkIn;
  final String checkOut;
  final String presentOne;
  final String presentTwo;
  final String workHours;
  final String overtimeHours;
  final bool isOvertime;

  AttendanceRecord({
    required this.attendanceId,
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.designation,
    required this.workshift,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.presentOne,
    required this.presentTwo,
    required this.workHours,
    required this.overtimeHours,
    required this.isOvertime,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      attendanceId: map["attendance_id"] ?? 0,
      employeeId: map["employee_id"] ?? 0,
      employeeName: map["employee_name"] ?? '',
      department: map["department"] ?? '',
      designation: map["designation"] ?? '',
      workshift: map["workshift"] ?? '',
      date: map["date"] ?? '',
      checkIn: map["check_in"] ?? '',
      checkOut: map["check_out"] ?? '',
      presentOne: _safeToString(map["present_one"]),
      presentTwo: _safeToString(map["present_two"]),
      workHours: _safeToString(map["work_hours"]),
      overtimeHours: _safeToString(map["overtime_hours"]),
      isOvertime: map["is_overtime"] ?? false,
    );
  }

  static String _safeToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
