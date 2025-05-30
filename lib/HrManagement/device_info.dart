import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:my_app/EmployeeManagement/custom_table.dart';
import 'package:my_app/app_text.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class DeviceInfoCard extends StatefulWidget {
  const DeviceInfoCard({
    super.key,
  });

  @override
  State<DeviceInfoCard> createState() => _DeviceInfoCardState();
}

class _DeviceInfoCardState extends State<DeviceInfoCard> {
  final DateTime _currentDate = DateTime.now();
  final DateTime _currentDate2 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {},
      weekendTextStyle: const TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: "May",
      weekFormat: false,
      markedDatesMap: null,
      height: 47.sp,
      selectedDateTime: _currentDate2,
      showIconBehindDayText: true,
      // daysHaveCircularBorder: false,

      /// null for not rendering any border, true for circular border, false for rectangular border
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: const TextStyle(
        color: Colors.yellow,
      ),
      todayTextStyle: const TextStyle(
        color: Colors.blue,
      ),
      markedDateIconBuilder: (event) {
        return event.icon ?? const Icon(Icons.help_outline);
      },
      minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
      maxSelectedDate: _currentDate.add(const Duration(days: 360)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal:
          true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(07.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 07.sp,
        children: [
          calendarCarousel,
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffd1e4ff),
                        borderRadius: BorderRadius.circular(05.sp)),
                    child: const Column(
                      children: [
                        CustomTable(datacolumns: ['Id', 'Status', "Time"]),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20.sp,
                  width: calcSize(context).longestSide,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(07.sp),
                  ),
                  child: Center(
                    child: AppText.small(
                      "Add Device",
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ).withPadding(
          padding: EdgeInsets.symmetric(horizontal: 07.sp, vertical: 07.sp)),
    );
  }
}
