import 'package:flutter/material.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class LeaveRequestFilter extends StatelessWidget {
  const LeaveRequestFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(05.sp),
                ),
                child: Center(
                  child: AppText.small(
                    "Leave Request",
                    fontSize: 18,
                  ).withPadding(
                    padding: EdgeInsets.all(07.sp),
                  ),
                ),
              ),
            ],
          ).withPadding(padding: EdgeInsets.symmetric(vertical: 07.sp)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffd1e4ff),
                  borderRadius: BorderRadius.circular(05.sp)),
              child: Wrap(
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
