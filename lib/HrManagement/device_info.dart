import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class DeviceInfoCard extends StatelessWidget {
  const DeviceInfoCard({
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
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffd1e4ff),
                  borderRadius: BorderRadius.circular(05.sp)),
              child: const Column(
                children: [
                  CustomTable(datacolumns: ['Id', 'Status']),
                ],
              ),
            ),
          ),
          Container(
            height: 20.sp,
            width: calcSize(context).longestSide,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(07.sp),
            ),
            child: Center(
              child: AppText.small(
                "Add Device",
                fontSize: 17,
              ),
            ),
          )
        ],
      ).withPadding(
          padding: EdgeInsets.symmetric(horizontal: 07.sp, vertical: 07.sp)),
    );
  }
}
