import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/verification_controller.dart';
import 'package:careAsOne/view/auth_screens/login.dart';
import 'package:careAsOne/view/set_password.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class VerificationCode extends StatelessWidget {
  const VerificationCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
      init: VerificationController(),
      builder: (_) => Scaffold(
        body: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bgWall.png'),
                fit: BoxFit.cover),
          ),
          height: height(context),
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _.verifyKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20.0),
                      color: AppColors.bgGreen,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MainHeading('VERIFICATION', size: 36.0),
                          SizedBox(height: 10.0),
                          SubText(
                            ' Please enter your Verification code.',
                            size: 12.0,
                            align: TextAlign.center,
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                              padding: EdgeInsets.all(0),
                              child: DecoratedInputField(
                                name: 'verification',
                                text: 'Verification Code',
                                hintText: 'Verification Code',
                                controller: _.textEditingController,
                                keyboard: TextInputType.number,
                                validations: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(4),
                                  FormBuilderValidators.maxLength(4),
                                ]),
                              )),
                          CustomButton(
                            onTap: () {
                              if (_.verifyKey.currentState!.validate()) {
                                Get.to(() => SetNewPasswordPage(), arguments: [
                                  _.textEditingController.text,
                                  _.email[0]
                                ]);
                              }
                            },
                            title: 'NEXT',
                            btnColor: AppColors.green,
                            textColor: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 60.0),
                    InkWell(
                      onTap: () {
                        Get.to(() => LoginPage());
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        width: 120.0,
                        // height: 120.0,
                        child: Image.asset('assets/images/signInBtn.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
