import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    Key? key,
    required this.width,
    required this.height,
    this.image,
    this.text,
    this.btnText,
    this.count,
    this.cntxt,
    this.onTap,
  }) : super(key: key);

  final double width;
  final double height;
  final String? image;
  final String? text;
  final String? btnText;
  final String? count;
  final BuildContext? cntxt;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 20),
        padding: EdgeInsets.only(top: 10, bottom: 20),
        height: !(cntxt)!.isLandscape ? width / 1.2 : height / 1.2,
        width: !(cntxt)!.isPortrait ? width / 1.2 : height / 1.2,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/employeer/$image",
              height: 120,
              width: 120,
              scale: 1.0,
            ),
            SizedBox(
              height: 5,
            ),
            SubText(
              "$text",
              color: Colors.black,
              colorOpacity: 0.7,
              size: 18,
              fontWeight: FontWeight.w300,
            ),
            count != null
                ? SubText(
                    "$count",
                    color: Colors.black,
                    size: 20,
                    fontWeight: FontWeight.w500,
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                onTap: onTap,
                title: "$btnText".toUpperCase(),
                btnColor: AppColors.white,
                textColor: AppColors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
