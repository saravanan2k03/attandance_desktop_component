import 'package:flutter/material.dart';
import 'package:my_app/EmployeeManagement/custom_dropdown.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class FillingForm extends StatelessWidget {
  const FillingForm({
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
            "Fill the Employee Name",
            fontSize: 18,
          ),
          Wrap(
            spacing: 10.sp,
            children: const [
              CustomBorderTextForm(),
              CustomBorderDropDownForm(),
            ],
          ).withPadding(padding: EdgeInsets.only(top: 07.sp, bottom: 07.sp)),
        ],
      ),
    );
  }
}

class CustomBorderTextForm extends StatelessWidget {
  const CustomBorderTextForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.sp,
      height: 20.sp,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(07.sp)),
      child: const CustomTextFormField(
        title: "First Name",
        initialValue: "",
        enable: true,
      ),
    );
  }
}

class CustomBorderDropDownForm extends StatelessWidget {
  const CustomBorderDropDownForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.sp,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(07.sp)),
      child: const MyDropdown(),
    );
  }
}
