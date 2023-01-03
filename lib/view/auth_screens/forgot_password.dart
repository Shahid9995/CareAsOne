import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/forget_password.dart';
import 'package:careAsOne/view/auth_screens/register/register.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(init: ForgetPasswordController(),
      builder: (_)=>Scaffold(
        body: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bgWall.png'), fit: BoxFit.cover),
          ),
          height: height(context),
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _.forgetKey,
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
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MainHeading('Reset Password', size: 36.0),
                          SizedBox(height: 10.0),
                          SubText(
                            'Forgot your password? Please enter your email address. You will '
                            'receive a link to create a new password via email.',
                            size: 12.0,
                            align: TextAlign.center,
                          ),
                          SizedBox(height: 10.0),
                          DecoratedInputField(
                            name: 'email',
                            text: 'Email',
                            hintText: 'Enter your Email',
                            controller: _.emailController,
                            // icon: Icons.email,
                            keyboard: TextInputType.emailAddress,
                            validations: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                            onChange: (val) {},
                          ),
                          SizedBox(height: 15.0),
                          CustomButton(
                            onTap: () {
                              if(_.forgetKey.currentState!.validate()){
                                _.sendPasswordResetMail(_.emailController.text);
                              }
                            },
                            title: 'RESET PASSWORD',
                            btnColor: AppColors.green,
                            textColor: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    MainHeading('Join CareAsOne', color: AppColors.white),
                    SizedBox(height: 5.0),
                    SubText(
                      'Get connected instantly with senior care companies and get hired as fast '
                      'as possible!',
                      color: AppColors.white,
                      align: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        Get.to(() => RegisterPage());
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        width: 120.0,
                        // height: 120.0,
                        child: Image.asset('assets/images/registerBtn.png'),
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
