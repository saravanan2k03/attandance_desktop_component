import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_dropdown.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class PayrollFilter extends StatelessWidget {
  const PayrollFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 07.sp,
      runSpacing: 07.sp,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.medium(
              "Search Employee",
              fontSize: 17,
            ),
            07.height,
            Container(
              height: 20.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(07.sp)),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.medium(
              "From",
              fontSize: 17,
            ),
            07.height,
            Container(
              height: 20.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(07.sp)),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.medium(
              "To",
              fontSize: 17,
            ),
            07.height,
            Container(
              height: 20.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(07.sp)),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.medium(
              "Working Shift",
              fontSize: 17,
            ),
            07.height,
            Container(
              height: 20.sp,
              // width: 40.sp,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(07.sp),
              ),
              child: const MyDropdown(),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.medium(
              "Category",
              fontSize: 17,
            ),
            07.height,
            Container(
              height: 20.sp,
              // width: 40.sp,
              decoration: BoxDecoration(
                // color: Colors.red,
                border: Border.all(),
                borderRadius: BorderRadius.circular(07.sp),
              ),
              child: const MyDropdown(),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 20.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(07.sp)),
              child: Center(
                child: AppText.small(
                  "Clear",
                  fontSize: 17,
                ),
              ),
            ),
            07.width,
            Container(
              height: 20.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(07.sp)),
              child: Center(
                child: AppText.small(
                  "Submit",
                  fontSize: 17,
                ),
              ),
            ),
          ],
        )
      ],
    ).withPadding(padding: EdgeInsets.all(07.sp));
  }
}
