import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/verify_email.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyEmailController>(
      init: VerifyEmailController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.white,
          title: Container( height: 40,width: 40,
              child: Image.asset('assets/images/playstore.png', fit: BoxFit.fitWidth)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SubText(
                "Verify Your Email First.",
                size: 25,
              ),
              TextButton(
                  onPressed: () {
                     _.resendVerification(context);
                  },
                  child: Text(
                    "Resend Verify Email",
                    style: TextStyle(color: Colors.blue),
                  )),
              SizedBox(height: 20,),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    _.authService.logOut();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: AppColors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
