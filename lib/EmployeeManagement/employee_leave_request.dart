import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:my_app/EmployeeManagement/leave_request_filter.dart';
import 'package:my_app/EmployeeManagement/remaning_leave_details.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class EmployeeLeaveRequest extends StatelessWidget {
  const EmployeeLeaveRequest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        // spacing: 07.sp,
        children: [
          const LeaveRequestFilter(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 8,
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
                ),
                const VerticalDivider(),
                const RemaningLeaveDetails(),
              ],
            ),
          )
        ],
      ).withPadding(padding: EdgeInsets.all(07.sp)),
    );
  }
}
