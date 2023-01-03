import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("======================");
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (_) => Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: Container()
            ),
      ),
    );
  }
}
