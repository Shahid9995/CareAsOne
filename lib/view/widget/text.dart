import 'package:careAsOne/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MainHeading extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  MainHeading(this.text, {this.size = 24.0, this.color = AppColors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: 'Freight',
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String text;

  Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SubText extends StatelessWidget {
  final String text;
  final Color? color;
  final double colorOpacity;
  final double? size;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? align;

  SubText(
    this.text, {
    this.color = AppColors.black,
    this.colorOpacity = 1.0,
    this.size,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontFamily,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
      style: TextStyle(
        color: color!.withOpacity(colorOpacity),
        fontSize: size,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
      ),
    );
  }
}
