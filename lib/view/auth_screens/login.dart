import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/login.dart';
import 'package:careAsOne/view/auth_screens/forgot_password.dart';
import 'package:careAsOne/view/auth_screens/register/employer_registration_setup.dart';
import 'package:careAsOne/view/auth_screens/register/register.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FocusScopeNode _node = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (_) => Scaffold(
              body: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bgWall.png'),
                      fit: BoxFit.cover),
                ),
                height: height(context),
                child: _.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.green)),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 20.0),
                                color: AppColors.white,
                                child: FormBuilder(
                                  key: _fbKey,
                                  child: FocusScope(
                                    node: _node,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        MainHeading('Sign In', size: 36.0),
                                        SizedBox(height: 10.0),
                                        DecoratedInputField(
                                          name: 'email',
                                          text: 'Email',
                                          controller: _.email,
                                          hintText: 'Enter your Email',

                                          keyboard: TextInputType.emailAddress,
                                          validations:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.email(
                                                ),
                                            FormBuilderValidators.required(
                                                ),
                                          ]),
                                          onChange: (val) {
                                            val = _.email.text;
                                          },
                                        ),
                                        DecoratedInputField(
                                          name: 'password',
                                          text: 'Password',
                                          controller: _.password,
                                          hintText: 'Enter password',

                                          obscureText: !_.passwordVisible,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _.passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: AppColors.green,
                                            ),
                                            onPressed: () {
                                              _.passwordVisible =
                                                  !_.passwordVisible;
                                              _.update();
                                            },
                                          ),
                                          showSuffixIcon: true,
                                          keyboard: TextInputType.text,
                                          validations:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                          ]),
                                          onChange: (val) {
                                            val = _.password.text;
                                          },
                                        ),
                                        SizedBox(height: 20.0),
                                        CustomButton(
                                          onTap: () async {
                                            if (_fbKey.currentState!.saveAndValidate()) {
                                              var playerId = await FirebaseMessaging.instance.getToken();
                                              print("==playerId==$playerId");
                                              _.login(context, body: {
                                                "email": _.email.text,
                                                "password": _.password.text,
                                                "device_token": playerId,
                                              });
                                            }
                                          },
                                          title: 'SIGN IN',
                                          btnColor: AppColors.green,
                                          textColor: AppColors.white,
                                        ),
                                        SizedBox(height: 20.0),
                                        InkWell(
                                            onTap: () {
                                              Get.to(
                                                  () => ForgotPasswordPage());
                                            },
                                            child: SubText('FORGOT PASSWORD?',
                                                size: 12.0, colorOpacity: 0.5)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              MainHeading('Join CareAsOne',
                                  color: AppColors.white),
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
                               Get.defaultDialog(titleStyle:TextStyle(color: AppColors.green),title: 'Register As',radius:5,content: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                 InkWell(
                                   onTap: (){
                                     Get.to(() => RegisterPage());

                                   },
                                   child: Column(children: [Container(width:100,height: 100,
                                       child: Image(image: AssetImage("assets/employeer/employment.png",))),SizedBox(height: 5,),SubText("Job Seeker")],),
                                 ),
                                   Container(width: 1,height: 100,color: Colors.grey,),
                                     InkWell(
                                       onTap: (){
                                         Get.to(()=>EmployerRegistrationScreen());
                                       },
                                       child: Column(children: [Container(width:100,height: 100,
                                           child: Image(image: AssetImage("assets/employeer/recruitment.png",))),SizedBox(height: 5,),SubText("Employer")],),
                                     ),
                                 ],),
                               ));
                                //  Get.to(() => RegisterPage());
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Container(
                                  width: 120.0,
                                  child: Image.asset(
                                      'assets/images/registerBtn.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ));
  }
}
