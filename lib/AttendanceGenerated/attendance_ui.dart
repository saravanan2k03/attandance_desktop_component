import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/AttendanceGenerated/attendance_generated.dart';
import 'package:my_app/models/attendance_list.dart';

// Main Attendance PDF Screen
class AttendancePdfScreen extends StatefulWidget {
  final AttendanceListModel attendanceData;
  final String organizationName;

  const AttendancePdfScreen({
    Key? key,
    required this.attendanceData,
    required this.organizationName,
  }) : super(key: key);

  @override
  _AttendancePdfScreenState createState() => _AttendancePdfScreenState();
}

class _AttendancePdfScreenState extends State<AttendancePdfScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedDepartment = 'All';
  String selectedMonth = '';
  String selectedYear = '';
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    selectedMonth = DateFormat('MMMM').format(DateTime.now());
    selectedYear = DateTime.now().year.toString();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Attendance Reports'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.people), text: 'Employees'),
            Tab(icon: Icon(Icons.calendar_month), text: 'Monthly'),
            Tab(icon: Icon(Icons.picture_as_pdf), text: 'Generate'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildEmployeesTab(),
          _buildMonthlyTab(),
          _buildGenerateTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 20),
          _buildDepartmentChart(),
          const SizedBox(height: 20),
          _buildRecentRecords(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    int totalRecords = widget.attendanceData.records.length;
    int presentCount = widget.attendanceData.records
        .where((r) => r.presentOne == '1' || r.presentTwo == '1')
        .length;
    int absentCount = totalRecords - presentCount;
    int overtimeCount = widget.attendanceData.records
        .where((r) => r.isOvertime)
        .length;

    double totalHours = 0;
    for (var record in widget.attendanceData.records) {
      totalHours += double.tryParse(record.workHours) ?? 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Summary',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildSummaryCard(
              'Total Records',
              totalRecords.toString(),
              Icons.assignment,
              Colors.blue,
            ),
            _buildSummaryCard(
              'Present',
              presentCount.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildSummaryCard(
              'Absent',
              absentCount.toString(),
              Icons.cancel,
              Colors.red,
            ),
            _buildSummaryCard(
              'Overtime',
              overtimeCount.toString(),
              Icons.access_time,
              Colors.orange,
            ),
            _buildSummaryCard(
              'Total Hours',
              '${totalHours.toStringAsFixed(0)}h',
              Icons.schedule,
              Colors.purple,
            ),
            _buildSummaryCard(
              'Attendance Rate',
              '${((presentCount / totalRecords) * 100).toStringAsFixed(1)}%',
              Icons.trending_up,
              Colors.teal,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentChart() {
    Map<String, int> departmentCounts = {};
    for (var record in widget.attendanceData.records) {
      departmentCounts[record.department] = 
          (departmentCounts[record.department] ?? 0) + 1;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department-wise Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...departmentCounts.entries.map((entry) {
              double percentage = (entry.value / widget.attendanceData.records.length) * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text('${entry.value} (${percentage.toStringAsFixed(1)}%)'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.primaries[departmentCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecords() {
    List<AttendanceRecord> recentRecords = widget.attendanceData.records.take(5).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Records',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...recentRecords.map((record) => _buildRecordTile(record)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTile(AttendanceRecord record) {
    bool isPresent = record.presentOne == '1' || record.presentTwo == '1';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      border: Border(
  left: BorderSide(
    width: 4,
    color: isPresent ? Colors.green : Colors.red,
  ),
),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isPresent ? Colors.green : Colors.red,
            child: Icon(
              isPresent ? Icons.check : Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.employeeName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${record.department} • ${record.date}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                record.workHours + 'h',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (record.isOvertime)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'OT',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesTab() {
    Map<int, List<AttendanceRecord>> employeeGroups = {};
    for (var record in widget.attendanceData.records) {
      if (!employeeGroups.containsKey(record.employeeId)) {
        employeeGroups[record.employeeId] = [];
      }
      employeeGroups[record.employeeId]!.add(record);
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Department',
                    border: OutlineInputBorder(),
                  ),
                  items: ['All', ...widget.attendanceData.records
                      .map((r) => r.department)
                      .toSet()
                      .toList()]
                      .map((dept) => DropdownMenuItem(
                            value: dept,
                            child: Text(dept),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: employeeGroups.length,
            itemBuilder: (context, index) {
              var entry = employeeGroups.entries.elementAt(index);
              var employee = entry.value.first;
              
              if (selectedDepartment != 'All' && 
                  employee.department != selectedDepartment) {
                return const SizedBox.shrink();
              }

              return _buildEmployeeCard(employee, entry.value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(AttendanceRecord employee, List<AttendanceRecord> records) {
    int presentDays = records.where((r) => r.presentOne == '1' || r.presentTwo == '1').length;
    double attendanceRate = (presentDays / records.length) * 100;
    double totalHours = records.fold(0, (sum, r) => sum + (double.tryParse(r.workHours) ?? 0));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            employee.employeeName.substring(0, 2).toUpperCase(),
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          employee.employeeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${employee.department} • ${employee.designation}'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip('${records.length} days', Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip('${attendanceRate.toStringAsFixed(1)}%', Colors.green),
                const SizedBox(width: 8),
                _buildInfoChip('${totalHours.toStringAsFixed(0)}h', Colors.orange),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: () => _generateEmployeePdf(records),
        ),
        onTap: () => _showEmployeeDetails(employee, records),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMonthlyTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedMonth,
                  decoration: const InputDecoration(
                    labelText: 'Month',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'
                  ].map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      )).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(5, (index) => DateTime.now().year - index)
                      .map((year) => DropdownMenuItem(
                            value: year.toString(),
                            child: Text(year.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _generateMonthlySummary(),
            icon: const Icon(Icons.calendar_month),
            label: const Text('Generate Monthly Summary'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildMonthlyPreview(),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyPreview() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Preview - $selectedMonth $selectedYear',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildPreviewItem('Total Employees', '${widget.attendanceData.records.map((r) => r.employeeId).toSet().length}'),
                  _buildPreviewItem('Total Records', '${widget.attendanceData.records.length}'),
                  _buildPreviewItem('Working Days', '22'), // Assuming 22 working days
                  _buildPreviewItem('Average Attendance', '${((widget.attendanceData.records.where((r) => r.presentOne == '1' || r.presentTwo == '1').length / widget.attendanceData.records.length) * 100).toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGenerateTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generate PDF Reports',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildReportOption(
            'Complete Attendance Report',
            'Generate a comprehensive report with all attendance data',
            Icons.assignment,
            Colors.blue,
            () => _generateCompleteReport(),
          ),
          const SizedBox(height: 16),
          _buildReportOption(
            'Department-wise Report',
            'Generate reports grouped by departments',
            Icons.business,
            Colors.green,
            () => _generateDepartmentReport(),
          ),
          const SizedBox(height: 16),
          _buildReportOption(
            'Monthly Summary',
            'Generate monthly attendance summary',
            Icons.calendar_month,
            Colors.orange,
            () => _generateMonthlySummary(),
          ),
          const SizedBox(height: 32),
          if (isGenerating)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating PDF...'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReportOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Future<void> _generateCompleteReport() async {
    setState(() {
      isGenerating = true;
    });

    try {
      await AttendancePdfGenerator.generateAttendanceReport(
        widget.attendanceData,
        widget.organizationName,
      );
      
      _showSuccessDialog('Complete attendance report generated successfully!');
    } catch (e) {
      _showErrorDialog('Failed to generate report: $e');
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  Future<void> _generateDepartmentReport() async {
    // Implementation for department-wise report
    _showInfoDialog('Department-wise report generation coming soon!');
  }

  Future<void> _generateMonthlySummary() async {
    setState(() {
      isGenerating = true;
    });

    try {
      await AttendancePdfGenerator.generateMonthlyAttendanceSummary(
        widget.attendanceData,
        widget.organizationName,
        selectedMonth,
        selectedYear,
      );
      
      _showSuccessDialog('Monthly summary generated successfully!');
    } catch (e) {
      _showErrorDialog('Failed to generate monthly summary: $e');
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  Future<void> _generateEmployeePdf(List<AttendanceRecord> records) async {
    try {
      await AttendancePdfGenerator.generateEmployeeAttendanceSheet(
        records,
        widget.organizationName,
      );
      
      _showSuccessDialog('Employee attendance sheet generated successfully!');
    } catch (e) {
      _showErrorDialog('Failed to generate employee sheet: $e');
    }
  }

  void _showEmployeeDetails(AttendanceRecord employee, List<AttendanceRecord> records) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(employee.employeeName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employee ID: ${employee.employeeId}'),
            Text('Department: ${employee.department}'),
            Text('Designation: ${employee.designation}'),
            const SizedBox(height: 16),
            Text('Total Records: ${records.length}'),
            Text('Present Days: ${records.where((r) => r.presentOne == '1' || r.presentTwo == '1').length}'),
            Text('Overtime Days: ${records.where((r) => r.isOvertime).length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generateEmployeePdf(records);
            },
            child: const Text('Generate PDF'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Success'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error, color: Colors.red, size: 48),
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.info, color: Colors.blue, size: 48),
        title: const Text('Info'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Data Models (assumed to exist based on your PDF generator)
