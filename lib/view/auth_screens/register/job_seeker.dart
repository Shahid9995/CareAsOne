import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/seeker_signUp.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class JobSeekerPage extends StatelessWidget {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeekerSignUpController>(
      init: SeekerSignUpController(),
      builder: (signUpController) => Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: SingleChildScrollView(
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  DecoratedInputField(
                    name: 'fname',
                    text: 'First Name*',
                    hintText: 'First Name',
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
                    // icon: Icons.email,
                    keyboard: TextInputType.text,
                    controller: signUpController.lastName,
                    validations: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    onChange: (val) {},
                  ),
                  DecoratedInputField(
                    name: 'email',
                    text: 'Email*',
                    hintText: 'Email',
                    keyboard: TextInputType.emailAddress,
                    controller: signUpController.email,
                    validations: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    onChange: (val) {},
                  ),
                  DecoratedInputField(
                    name: 'Phone',
                    text: 'Phone*',
                    hintText: 'Phone',
                    keyboard: TextInputType.phone,
                    controller: signUpController.phone,
                    validations: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                    onChange: (val) {},
                  ),
                  DecoratedInputField(
                    name: 'Password',
                    text: 'Password*',
                    hintText: '8 - 16 symbols',
                    obscureText: !signUpController.seekerVisible,
                    showSuffixIcon: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpController.seekerVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.green,
                      ),
                      onPressed: () {
                        signUpController.seekerVisible =
                            !signUpController.seekerVisible;
                        signUpController.update();
                      },
                    ),
                    keyboard: TextInputType.text,
                    controller: signUpController.password,
                    validations: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                      FormBuilderValidators.maxLength(16)
                    ]),
                    onChange: (val) {},
                  ),
                  DecoratedInputField(
                    name: 'confirm',
                    text: 'Confirm Password*',
                    hintText: 'Confirm Password',
                    obscureText: !signUpController.confirmSeekerVisible,
                    showSuffixIcon: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpController.confirmSeekerVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.green,
                      ),
                      onPressed: () {
                        signUpController.confirmSeekerVisible =
                            !signUpController.confirmSeekerVisible;
                        signUpController.update();
                      },
                    ),
                    keyboard: TextInputType.text,
                    controller: signUpController.repeatPassword,
                    validations: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                      FormBuilderValidators.maxLength(16)
                    ]),
                    onChange: (val) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: signUpController.isCheck,
                          onChanged: (value) {
                            signUpController.isCheck = value!;
                            signUpController.update();
                          }),
                      Expanded(
                          child: SubText(
                              "I agree to CareAsOne\'s terms of service and privacy policy."))
                    ],
                  ),
                  SizedBox(height: 30.0),
                  CustomButton(
                    onTap: () {
                      if (formKey.currentState!.saveAndValidate()) {
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
                              "user_type": "job-seeker",
                            });
                          } else {
                            showToast(msg: 'Accept Terms & Services');
                          }
                        } else {
                          showToast(msg: 'Password should be matched');
                        }
                      }
                    },
                    title: 'SIGN UP',
                    btnColor: AppColors.green,
                    textColor: AppColors.white,
                  ),

                ],
              ),
            ),
          )),
    );
  }
}
