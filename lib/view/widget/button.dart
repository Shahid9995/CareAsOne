import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final Color? textColor;
  final Color? btnColor;
  final VoidCallback? onTap;

  CustomButton({
    this.title,
    this.onTap,
    this.textColor = AppColors.green,
    this.btnColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 40.0,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0.0),
          backgroundColor: MaterialStateProperty.all<Color>(btnColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(side: BorderSide(color: AppColors.green))),
        ),
        child: SubText(title.toString(), size: 12.0, color: textColor!),
      ),
    );
  }
}

class CustomTransparentButton extends StatelessWidget {
  final String? title;
  final Color? textColor;
  final Color? btnColor;
  final VoidCallback? onTap;
  final IconData? icon;

  CustomTransparentButton({
    this.title,
    this.onTap,
    this.icon,
    this.textColor = AppColors.green,
    this.btnColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0.0),
          backgroundColor: MaterialStateProperty.all<Color>(btnColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(side: BorderSide(color: AppColors.green))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 15,
            ),
            SizedBox(
              width: 5,
            ),
            SubText(title.toString(), size: 12.0, color: textColor!),
          ],
        ),
      ),
    );
  }
}

class DrawerTileButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final String image;
  final bool seleted;
  String? jobsApplied;

  DrawerTileButton(
      {required this.title,required  this.onPressed,required  this.image, this.seleted = false, this.jobsApplied});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
          color: seleted ? Colors.white.withOpacity(1) : Colors.transparent,
          child: Row(
            children: [
              Image.asset(
                "assets/employeer/drawer/$image",
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 10,
              ),
              SubText(
                title,
                // height: 1.0,
                // size: 16,
                size: 18,
                color: seleted ? AppColors.green : AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              jobsApplied==null?SizedBox():Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 2.5),
                child: Center(
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.red,
                    child: SubText(
                        "$jobsApplied",
                        size: 10.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white),
                  ),

                  // child: Icon(Icons.check_circle_outline,
                  //     size: 16.0, color: AppColors.black.withOpacity(0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnReadMsgIconButton extends StatelessWidget {
  final int msgNumber;
  final VoidCallback onTap;

  UnReadMsgIconButton({required this.msgNumber,required  this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.all(Radius.circular(100.0)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.mail_outline, size: 26.0, color: AppColors.black),
            onPressed: onTap,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
            child: msgNumber!=0?CircleAvatar(
              radius: 8.0,
              backgroundColor: AppColors.green,
              child: SubText(msgNumber > 99 ? '99+' : '$msgNumber',
                  size: msgNumber > 99 ? 8.0 : 10.0,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold),
            ):SizedBox(),
          )
        ],
      ),
    );
  }
}
