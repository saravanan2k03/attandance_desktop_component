import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:sizer/sizer.dart';

class RemaningLeaveDetails extends StatelessWidget {
  const RemaningLeaveDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffd1e4ff),
            borderRadius: BorderRadius.circular(05.sp)),
        child: const Column(
          children: [
            CustomTable(datacolumns: ['LEAVE CATEGORY', 'COUNT']),
          ],
        ),
      ),
    );
  }
}
