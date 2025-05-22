import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app/app_text.dart';
import 'package:sizer/sizer.dart';

Size calcSize(context) {
  return MediaQuery.of(context).size;
}

class UpdateProfileTextFormField extends StatelessWidget {
  const UpdateProfileTextFormField({
    super.key,
    required this.title,
    required this.initialValue,
    required this.enable,
    this.onChanged,
  });

  final String title;
  final String initialValue;
  final bool enable;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    log("ignorePointer :$enable");
    return TextFormField(
      enabled: enable,
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: AppText.small(
          title,
          fontSize: 11.sp,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,

        // fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 07.sp,
          vertical: 08.sp,
        ),
      ),
      style: TextStyle(fontSize: 11.sp, color: Colors.black),
    );
  }
}
