import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xffF5F5F5),
              child: Column(
                children: [
                  SizedBox(
                    // height: 35.sp,
                    width: calcSize(context).longestSide,
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText.small(
                              "Employee Management",
                              fontSize: 18,
                            ),
                            07.sp.width,
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 15,
                            ),
                            07.sp.width,
                            AppText.small(
                              "All Employee",
                              fontSize: 18,
                            ),
                          ],
                        ),
                        AppText.medium(
                          "All Employee",
                          fontSize: 18,
                        ),
                        07.sp.width,
                      ],
                    ),
                  ),
                  15.height,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.sp,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(07.sp)),
                            child: const CustomTextFormField(
                              title: "Search",
                              initialValue: "",
                              enable: true,
                            ),
                          ),
                          10.height,
                          const CustomTable(
                              datacolumns: ['Name', 'hello', 'bye']),
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
                      ).withPadding(padding: EdgeInsets.all(10.sp)),
                    ),
                  ),
                ],
              ).withPadding(
                padding: EdgeInsets.all(10.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
