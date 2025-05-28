import 'package:flutter/material.dart';
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
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(07.sp),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 07.sp,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 15.sp,
                                    ).withPadding(
                                        padding: EdgeInsets.only(top: 07.sp)),
                                    10.width,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                10.height,
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
                                      customIcon:
                                          Icon(Icons.work_outline_rounded),
                                    ).withPadding(
                                        padding: EdgeInsets.only(top: 07.sp)),
                                    const EmployeeBasicCards(
                                      label: "Department",
                                      data: "Software",
                                      customIcon:
                                          Icon(Icons.work_outline_rounded),
                                    ).withPadding(
                                        padding: EdgeInsets.only(top: 07.sp)),
                                    const EmployeeBasicCards(
                                      label: "Department",
                                      data: "Software",
                                      customIcon:
                                          Icon(Icons.work_outline_rounded),
                                    ).withPadding(
                                        padding: EdgeInsets.only(top: 07.sp)),
                                  ],
                                )
                              ],
                            ).withPadding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 07.sp)),
                          ),
                        ),
                        07.width,
                        Expanded(
                          flex: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(07.sp),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                )
                              ],
                            ),
                          ),
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

class EmployeeBasicCards extends StatelessWidget {
  final String label;
  final String data;
  final Icon customIcon;
  const EmployeeBasicCards({
    super.key,
    required this.label,
    required this.data,
    required this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xfff5f5f5),
            borderRadius: BorderRadius.circular(05.sp),
          ),
          child: customIcon.withPadding(padding: EdgeInsets.all(07.sp)),
        ),
        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium(
                data,
                textOverflow: TextOverflow.ellipsis,
                fontSize: 17,
              ),
              AppText.small(
                label,
                textOverflow: TextOverflow.ellipsis,
                fontSize: 17,
              ),
            ],
          ),
        )
      ],
    );
  }
}
