import 'package:flutter/material.dart';
import 'package:my_app/app_text.dart';
import 'package:sizer/sizer.dart';

Size calcSize(context) {
  return MediaQuery.of(context).size;
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
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
    return TextFormField(
      enabled: enable,
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: AppText.small(
          title,
          fontSize: 17,
        ),
        enabledBorder: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        errorBorder: const OutlineInputBorder(),
        disabledBorder: const OutlineInputBorder(),

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
