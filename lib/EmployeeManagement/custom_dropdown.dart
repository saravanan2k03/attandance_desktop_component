import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyDropdown extends StatefulWidget {
  final String? hintText;
  const MyDropdown({super.key, this.hintText});

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
        enabledBorder: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        errorBorder: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(),
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
      enableSearch: false,
      hintText: widget.hintText ?? "",
    );
  }
}
