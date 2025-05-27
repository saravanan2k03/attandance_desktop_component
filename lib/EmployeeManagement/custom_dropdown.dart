import 'package:flutter/material.dart';
import 'package:my_app/extension.dart';
import 'package:sizer/sizer.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  MyDropdownState createState() => MyDropdownState();
}

class MyDropdownState extends State<MyDropdown> {
  String? _selectedItem; // Keep track of the selected item. Nullable.

  // List of items to populate the dropdown.
  final List<String> _dropdownItems = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: 50.sp,
      initialSelection: _selectedItem,
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      dropdownMenuEntries:
          _dropdownItems.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
      onSelected: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
        });
      },
      hintText: "",
    ).withPadding(padding: EdgeInsets.only(left: 05.sp));
  }
}
