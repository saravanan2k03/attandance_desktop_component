import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/EmployeeLeaveRequest.dart';
import 'package:my_app/EmployeeManagement/employee_info_card.dart';
import 'package:my_app/EmployeeManagement/employee_tabbar.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class EmployeeDetails extends StatelessWidget {
  const EmployeeDetails({super.key});

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
                              "Employee Details",
                              fontSize: 18,
                            ),
                          ],
                        ),
                        AppText.medium(
                          "Employee Details",
                          fontSize: 18,
                        ),
                        07.sp.width,
                      ],
                    ),
                  ),
                  15.height,
                  Expanded(
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: EmployeeInfoCard(),
                        ),
                        07.width,
                        Expanded(
                          flex: 10,
                          child: Container(
                              height: calcSize(context).longestSide,
                              width: calcSize(context).longestSide,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(07.sp),
                              ),
                              child: const Column(
                                children: [
                                  EmployeeTabbar(),
                                  EmployeeLeaveRequest(),
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
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
