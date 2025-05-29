import 'package:flutter/material.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class LeaveRequestFilter extends StatelessWidget {
  const LeaveRequestFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(07.sp),
              ),
              child: Center(
                child: AppText.small(
                  "Leave Request",
                  fontSize: 18,
                ).withPadding(
                  padding: EdgeInsets.all(10.sp),
                ),
              ),
            ),
          ],
        ).withPadding(padding: EdgeInsets.symmetric(vertical: 07.sp)),
        Container(
          width: calcSize(context).longestSide,
          decoration: BoxDecoration(
              // color: const Color(0xffd1e4ff),
              borderRadius: BorderRadius.circular(05.sp)),
          child: Wrap(
            spacing: 07.sp,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    "From",
                    fontSize: 17,
                  ),
                  Container(
                    height: 20.sp,
                    width: 40.sp,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(07.sp),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    "To",
                    fontSize: 17,
                  ),
                  Container(
                    height: 20.sp,
                    width: 40.sp,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(07.sp),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    "Category",
                    fontSize: 17,
                  ),
                  Container(
                    height: 20.sp,
                    width: 40.sp,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(07.sp),
                    ),
                  )
                ],
              ),
              Container(
                height: 20.sp,
                width: 35.sp,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(07.sp),
                ),
                child: Center(
                    child: AppText.small(
                  "Search",
                  fontSize: 17,
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
