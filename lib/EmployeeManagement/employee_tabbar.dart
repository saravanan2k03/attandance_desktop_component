import 'package:flutter/material.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class EmployeeTabbar extends StatelessWidget {
  const EmployeeTabbar({
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
                label: "Employee Dashboard",
              ),
              TabbarCard(
                cardenable: false,
                label: "Employee Details",
              ),
              TabbarCard(
                cardenable: false,
                label: "Leave Request",
              ),
            ],
          ).withPadding(padding: EdgeInsets.all(07.sp)),
        ).withPadding(padding: EdgeInsets.all(07.sp)),
      ],
    );
  }
}

class TabbarCard extends StatelessWidget {
  final bool cardenable;
  final String label;
  const TabbarCard({
    super.key,
    required this.cardenable,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardenable ? const Color(0xffd1e4ff) : null,
        borderRadius: BorderRadius.circular(05.sp),
      ),
      child: AppText.small(
        label,
        fontSize: 17,
      ).withPadding(padding: EdgeInsets.all(07.sp)),
    );
  }
}
