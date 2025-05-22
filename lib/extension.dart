import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension PaddingExtension on Widget {
  Widget withPadding({EdgeInsets padding = const EdgeInsets.all(8.0)}) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}

extension BorderRadiusExtension on BoxDecoration {
  BoxDecoration withBorderRadius({
    BorderRadius borderRadius = BorderRadius.zero,
    Color color = Colors.white,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
    );
  }
}

extension NumExtension on num {
  // For height
  SizedBox get height => SizedBox(height: toDouble().sp);

  // For width
  SizedBox get width => SizedBox(width: toDouble().sp);

  // For both height and width
  SizedBox get square => SizedBox(height: toDouble().sp, width: toDouble().sp);
}

extension StringSanitize on String? {
  /// Sanitizes a String value.  If the string is equal to "null" or "0", it returns an empty string ("").
  /// Otherwise, it returns the original string, converted to a String using `.toString()`.
  /// This extension operates on `String?`, meaning it handles null strings gracefully.

  String sanitizeValue() {
    final value = this;
    if (value == "null" || value.toString() == "0") {
      return "";
    }
    return value.toString();
  }
}
