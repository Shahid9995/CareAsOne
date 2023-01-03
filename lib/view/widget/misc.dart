import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconText extends StatelessWidget {
  final String text;
  final IconData icon;

  IconText({required this.text,required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(icon, size: 12.0, color: AppColors.green.withOpacity(0.7)),
        SizedBox(width: 2.5),
        Expanded(
            child:
                Container(child: SubText(text, size: 12.0, colorOpacity: 0.7))),
      ],
    );
  }
}

class AppliedJobDetail extends StatelessWidget {
  final String? title;
  final String? value;
  final Color valueColor;
  final double titleWidth;

  AppliedJobDetail(
      {this.title,
      this.value,
      this.valueColor = AppColors.black,
      this.titleWidth = 65.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: titleWidth,
              child: SubText('$title:'.toUpperCase(), size: 10.0)),
          SizedBox(width: 5.0),
          Expanded(
            child: SubText(value.toString(),
                size: 12.0, color: valueColor, colorOpacity: 0.7),
          ),
        ],
      ),
    );
  }
}
