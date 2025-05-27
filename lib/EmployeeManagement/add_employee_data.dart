import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/filling_form.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class AddEmployeeData extends StatefulWidget {
  const AddEmployeeData({super.key});

  @override
  State<AddEmployeeData> createState() => _AddEmployeeDataState();
}

class _AddEmployeeDataState extends State<AddEmployeeData> {
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
                    width: calcSize(context).longestSide,
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
                              "Add Employee",
                              fontSize: 18,
                            ),
                          ],
                        ),
                        AppText.medium(
                          "Add Employee",
                          fontSize: 18,
                        ),
                        07.sp.width,
                      ],
                    ),
                  ),
                  15.height,
                  Expanded(
                    child: Container(
                      height: calcSize(context).longestSide,
                      width: calcSize(context).longestSide,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 07.sp,
                            children: [
                              Chip(
                                label: AppText.small(
                                  "Personal Information",
                                  fontSize: 17,
                                ),
                              ),
                              Chip(
                                label: AppText.small(
                                  "Address",
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          10.height,
                          const ProfileUpload(),
                          15.height,
                          const Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  FillingForm(),
                                  FillingForm(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).withPadding(padding: EdgeInsets.all(10.sp)),
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

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 70,
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Center(
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
