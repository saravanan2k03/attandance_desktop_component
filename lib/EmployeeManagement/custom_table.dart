import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:sizer/sizer.dart';

class CustomTable extends StatelessWidget {
  final List<String> datacolumns;
  final List<DataRow>? dataRow;
  const CustomTable({super.key, required this.datacolumns, this.dataRow});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(05.sp),
        child: SizedBox(
          width: calcSize(context).longestSide,
          child: SingleChildScrollView(
            scrollDirection: calcSize(context).width < 1200
                ? Axis.horizontal
                : Axis.vertical,
            physics: calcSize(context).width < 1200
                ? null
                : const NeverScrollableScrollPhysics(),
            child: buildDataTable(),
          ),
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return DataTable(
      dataRowColor: WidgetStateColor.resolveWith((states) => Colors.lightGreen),
      clipBehavior: Clip.antiAlias,
      headingRowColor:
          WidgetStateColor.resolveWith((states) => const Color(0xffF6F8FA)),
      columns: getColumns(datacolumns),
      rows: dataRow ?? [], // Pass the fetched data to getRows
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        // numeric: true,
        label: Expanded(
          child: InkWell(
            onHover: (value) {},
            onTap: () {
              log(column);
            },
            child: Text(
              column,
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      );
    }).toList();
  }

  editParticipate(user) {
    if (kDebugMode) {
      print(user);
    }
  }
}
