import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:my_app/HrManagement/payroll_filter.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class PayrollDetailsCard extends StatelessWidget {
  const PayrollDetailsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PayrollFilter(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffd1e4ff),
                  borderRadius: BorderRadius.circular(05.sp)),
              child: const Column(
                children: [
                  CustomTable(datacolumns: ['Id', 'Status', "Time"]),
                ],
              ),
            ),
          ),
        ],
      ).withPadding(padding: EdgeInsets.all(07.sp)),
    );
  }
}
