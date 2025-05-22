// ignore_for_file: file_names
import 'package:flutter/material.dart';

class AppText extends Text {
  final Color? color;
  final FontWeight? fontWeight;
  final double? height;
  final double? letterSpacing;
  final double fontSize;

  AppText.small(super.data,
      {super.key,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal,
      super.textAlign = TextAlign.left,
      int? maxLine,
      TextOverflow? textOverflow,
      this.height,
      this.letterSpacing,
      this.fontSize = 12})
      : super(
          maxLines: maxLine,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            fontWeight: fontWeight,
            overflow: textOverflow,
            letterSpacing: letterSpacing,
          ),
        );
  // style: Theme.of(context).textTheme.bodyMedium);

  AppText.medium(
    super.data, {
    super.key,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w600,
    TextAlign super.textAlign = TextAlign.left,
    int? maxLine,
    TextOverflow? textOverflow,
    this.height,
    this.letterSpacing,
    this.fontSize = 14,
    TextDecoration textDecoration = TextDecoration.none,
  }) : super(
          maxLines: maxLine,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            fontWeight: fontWeight,
            overflow: textOverflow,
            decoration: textDecoration,
            letterSpacing: letterSpacing,
          ),
        );

  AppText.large(super.data,
      {super.key,
      this.color = Colors.black,
      this.fontWeight = FontWeight.bold,
      super.textAlign = TextAlign.center,
      int? maxLine,
      TextOverflow? textOverflow,
      this.height,
      this.letterSpacing,
      this.fontSize = 24})
      : super(
          maxLines: maxLine,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            fontWeight: fontWeight,
            overflow: textOverflow,
            letterSpacing: letterSpacing,
          ),
        );
}

class AppTextSpan extends TextSpan {
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? height;
  final double fontSize;
  final double? letterSpacing;

  AppTextSpan.large(String data,
      {this.color = Colors.black,
      this.fontWeight = FontWeight.bold,
      this.textAlign,
      this.height,
      this.fontSize = 24,
      this.letterSpacing,
      super.recognizer})
      : super(
          text: data,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
          ),
        );

  AppTextSpan.medium(String data,
      {this.color = Colors.black,
      this.fontWeight = FontWeight.w600,
      this.textAlign,
      this.height,
      this.fontSize = 14,
      this.letterSpacing,
      TextDecoration textDecoration = TextDecoration.none,
      super.recognizer})
      : super(
          text: data,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
            decoration: textDecoration,
            fontWeight: fontWeight,
          ),
        );

  AppTextSpan.small(String data,
      {this.color = Colors.black,
      this.fontWeight,
      this.textAlign,
      this.height,
      this.fontSize = 12,
      this.letterSpacing = 1,
      super.recognizer})
      : super(
          text: data,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
          ),
        );
}
