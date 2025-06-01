import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:my_app/EmployeeManagement/filling_form.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class EmployeeProfileDetails extends StatelessWidget {
  const EmployeeProfileDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: calcSize(context).longestSide,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.medium(
            "Employee Profile Details",
            fontSize: 17,
          ),
          10.height,
          Wrap(
            spacing: 10.sp,
            runSpacing: 10.sp,
            children: const [
              CustomBorderTextForm(
                title: "User Name",
              ),
              CustomBorderTextForm(
                title: "Password",
              ),
              CustomBorderDropDownForm(
                hintText: "Department",
              ),
              CustomBorderTextForm(
                title: "Basic Salary",
              ),
              CustomBorderDropDownForm(
                hintText: "Work Shift",
              ),
            ],
          ),
          10.height,
          SizedBox(
            height: 50.sp,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.small(
                        "Gosi Applicable",
                        fontSize: 17,
                      ),
                      10.height,
                      Container(
                        height: 20.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(07.sp)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: calcSize(context).longestSide,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(07.sp),
                                ),
                                child: Center(
                                  child: AppText.small(
                                    "Applicable",
                                    fontSize: 17,
                                  ),
                                ),
                              ).withPadding(padding: EdgeInsets.all(05.sp)),
                            ),
                            // 05.width,
                            Expanded(
                              child: Container(
                                height: calcSize(context).longestSide,
                                decoration: BoxDecoration(
                                  // color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(07.sp),
                                ),
                                child: Center(
                                  child: AppText.small(
                                    "Not Applicable",
                                    fontSize: 17,
                                  ),
                                ),
                              ).withPadding(padding: EdgeInsets.all(05.sp)),
                            ),
                          ],
                        ),
                      ),
                      10.height,
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(07.sp),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.small("Address")
                                  .withPadding(padding: EdgeInsets.all(07.sp)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 20.sp,
                      width: 30.sp,
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(07.sp)),
                      child: Center(
                        child: AppText.small(
                          "ADD",
                          fontSize: 17,
                        ),
                      ),
                    ),
                    07.height,
                    const CustomTable(datacolumns: ['ID', 'Leave', 'Count']),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
