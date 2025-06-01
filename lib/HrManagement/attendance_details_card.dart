import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:my_app/HrManagement/attendance_filter.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class AttendanceDetailsCard extends StatelessWidget {
  const AttendanceDetailsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AttendanceFilter(),
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
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 17.sp,
                width: 30.sp,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(07.sp)),
                child: Center(
                  child: AppText.small(
                    "Prev",
                    fontSize: 11.sp,
                  ),
                ),
              ),
              10.width,
              Container(
                height: 17.sp,
                width: 30.sp,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(07.sp)),
                child: Center(
                  child: AppText.small(
                    "Next",
                    fontSize: 11.sp,
                  ),
                ),
              )
            ],
          )
        ],
      ).withPadding(padding: EdgeInsets.all(07.sp)),
    );
  }
}
