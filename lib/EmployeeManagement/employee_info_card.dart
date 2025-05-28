import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/employee_basic_cards.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class EmployeeInfoCard extends StatelessWidget {
  const EmployeeInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(07.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 07.sp,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15.sp,
              ).withPadding(padding: EdgeInsets.only(top: 07.sp)),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.small(
                      "Saravanan",
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: 18,
                    ),
                    AppText.small(
                      "Software Developer",
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: 18,
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    "Info",
                    fontSize: 18,
                  ),
                  const EmployeeBasicCards(
                    label: "Department",
                    data: "Software",
                    customIcon: Icon(Icons.work_outline_rounded),
                  ).withPadding(padding: EdgeInsets.only(top: 07.sp)),
                  const EmployeeBasicCards(
                    label: "Department",
                    data: "Software",
                    customIcon: Icon(Icons.work_outline_rounded),
                  ).withPadding(padding: EdgeInsets.only(top: 07.sp)),
                  const EmployeeBasicCards(
                    label: "Department",
                    data: "Software",
                    customIcon: Icon(Icons.work_outline_rounded),
                  ).withPadding(padding: EdgeInsets.only(top: 07.sp)),
                ],
              ),
              10.height,
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    "Info",
                    fontSize: 18,
                  ),
                  const EmployeeBasicCards(
                    label: "Department",
                    data: "Software",
                    customIcon: Icon(Icons.work_outline_rounded),
                  ).withPadding(padding: EdgeInsets.only(top: 07.sp)),
                  const EmployeeBasicCards(
                    label: "Department",
                    data: "Software",
                    customIcon: Icon(Icons.work_outline_rounded),
                  ).withPadding(padding: EdgeInsets.only(top: 07.sp)),
                  const EmployeeBasicCards(
                    label: "Department",
                    data: "Software",
                    customIcon: Icon(Icons.work_outline_rounded),
                  ).withPadding(padding: EdgeInsets.only(top: 07.sp)),
                ],
              ),
            ],
          ).withPadding(padding: EdgeInsets.only(bottom: 10.sp)),
        ],
      ).withPadding(padding: EdgeInsets.symmetric(horizontal: 07.sp)),
    );
  }
}
