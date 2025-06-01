import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/filling_form.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class EmployeePersonalDetails extends StatelessWidget {
  const EmployeePersonalDetails({
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
            "Employee Personal Details",
            fontSize: 17,
          ),
          10.height,
          Wrap(
            spacing: 10.sp,
            runSpacing: 10.sp,
            children: const [
              CustomBorderTextForm(
                title: "First Name",
              ),
              CustomBorderTextForm(
                title: "Last Name",
              ),
              CustomBorderTextForm(
                title: "Mobile No",
              ),
              CustomBorderTextForm(
                title: "Date of Birth",
              ),
              CustomBorderDropDownForm(
                hintText: "Gender",
              ),
              CustomBorderTextForm(
                title: "Email id",
              ),
              CustomBorderTextForm(
                title: "Nationality",
              ),
              CustomBorderTextForm(
                title: "Iqama number",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
