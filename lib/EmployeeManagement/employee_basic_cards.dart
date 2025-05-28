import 'package:flutter/material.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

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
