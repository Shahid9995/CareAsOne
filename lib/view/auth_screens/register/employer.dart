import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/signup.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class EmployerPage extends StatelessWidget {
  GlobalKey<FormBuilderState> fKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (signUpController)=>
      Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: FormBuilder(
          key: fKey,
          child: signUpController.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.green)),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      DecoratedInputField(
                        name: 'fname',
                        text: 'First Name*',
                        hintText: 'First Name',
                        // icon: Icons.email,

                        controller: signUpController.firstName,
                        keyboard: TextInputType.text,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        onChange: (val) {},
                      ),
                      DecoratedInputField(
                        name: 'lname',
                        text: 'Last Name*',
                        hintText: 'Last Name',
                        controller: signUpController.lastName,
                        // icon: Icons.email,
                        keyboard: TextInputType.text,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        onChange: (val) {},
                      ),
                      DecoratedInputField(
                        name: 'email',
                        text: 'Email*',
                        hintText: 'Email',
                        controller: signUpController.email,
                        // icon: Icons.email,
                        keyboard: TextInputType.emailAddress,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                        onChange: (val) {},
                      ),
                      DecoratedInputField(
                        name: 'Phone',
                        text: 'Phone*',
                        hintText: 'Phone',
                        // icon: Icons.email,
                        controller: signUpController.phone,
                        keyboard: TextInputType.phone,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          // FormBuilderValidators.minLength(context, 11),
                          // FormBuilderValidators.maxLength(context, 15),
                        ]),
                        onChange: (val) {},
                      ),
                      DecoratedInputField(
                        name: 'Password',
                        text: 'Password*',
                        controller: signUpController.password,
                        hintText: '8 - 16 symbols',
                        // icon: Icons.email,
                        obscureText: !signUpController.passwordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            signUpController.passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.green,
                          ),
                          onPressed: () {
                            signUpController.passwordVisible =
                                !signUpController.passwordVisible;
                            signUpController.update();
                          },
                        ),
                        showSuffixIcon: true,
                        keyboard: TextInputType.text,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8),
                          FormBuilderValidators.maxLength(16),
                        ]),
                        onChange: (val) {},
                      ),
                      DecoratedInputField(
                        name: 'confirm',
                        text: 'Confirm Password*',
                        hintText: 'Confirm Password',
                        controller: signUpController.repeatPassword,
                        // icon: Icons.email,
                        obscureText: !signUpController.confirmPassVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            signUpController.confirmPassVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.green,
                          ),
                          onPressed: () {
                            signUpController.confirmPassVisible =
                                !signUpController.confirmPassVisible;
                            signUpController.update();
                          },
                        ),
                        showSuffixIcon: true,
                        keyboard: TextInputType.text,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8),
                          FormBuilderValidators.maxLength(16),
                        ]),
                        onChange: (val) {},
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Checkbox(value: signUpController.isCheck, onChanged: (value){
                          signUpController.isCheck=value!;
                          signUpController.update();
                        }),
                        Expanded(child: SubText("I represent HR, Recruiting, or am an Executive at my company and I agree to CareAsone\'s terms of service and privacy policy on behalf of my company"))
                      ],),
                      SizedBox(height: 30.0),
                      CustomButton(
                        onTap: () {
                          if (fKey.currentState!.validate()) {
                            if (signUpController.password.text ==
                                signUpController.repeatPassword.text) {
                              if (signUpController.isCheck == true) {
                                signUpController.register(context, params: {
                                  "first_name": signUpController.firstName.text,
                                  "last_name": signUpController.lastName.text,
                                  "email": signUpController.email.text,
                                  "password": signUpController.password.text,
                                  "password_confirmation":
                                      signUpController.repeatPassword.text,
                                  "phone_number": signUpController.phone.text,
                                  "user_type": "employer",
                                });
                              } else {
                                showToast(msg: 'Accept Terms & Services');
                              }
                            } else {
                              showToast(msg: 'Password should be matched');
                            }
                          }
                        },
                        title: 'REQUEST COMPANY PROFILE & POST JOBS',
                        btnColor: AppColors.green,
                        textColor: AppColors.white,
                      ),
                    ],
                  ),
                ),
        ),
      ),

    );
  }
}
