import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/employee_tabbar.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class HrTabbar extends StatelessWidget {
  const HrTabbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(07.sp)),
          child: Row(
            spacing: 07.sp,
            children: const [
              TabbarCard(
                cardenable: true,
                label: "Attendance Details",
              ),
              TabbarCard(
                cardenable: false,
                label: "Payroll Details",
              ),
            ],
          ).withPadding(padding: EdgeInsets.all(07.sp)),
        ).withPadding(padding: EdgeInsets.all(07.sp)),
      ],
    );
  }
}
