import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/view/auth_screens/set_new_pass_controller.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
class SetNewPasswordPage extends StatelessWidget {
  const SetNewPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetNewPasswordController>(init:SetNewPasswordController(),
        builder: (_)=>Scaffold(
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
    key: _.setPassKey,
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
      Row(children: [
        IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){Get.back();},),

      ],),
      MainHeading('New Password', size: 24.0),
    SizedBox(height: 10.0),
    SubText(
    'Please Enter New Password',
    size: 12.0,
    align: TextAlign.center,
    ),
    SizedBox(height: 10.0),

 DecoratedInputField(
    name: 'newPass',
    text: 'New Password',
    hintText: 'New Password',
    controller: _.newPassController,
obscureText: !_.visibilityNewPass,
   showSuffixIcon: true,
   suffixIcon: IconButton(
     icon: Icon(
       _.visibilityNewPass
           ? Icons.visibility
           : Icons.visibility_off,
       color: AppColors.green,
     ),
     onPressed: () {
       // Update the state i.e. toogle the state of passwordVisible variable

       _.visibilityNewPass =
       !_.visibilityNewPass;
       _.update();
     },
   ),
    validations: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(8),

    ]),
    ),
      DecoratedInputField(
        name: 'confirmPass',
        text: 'Confirm Password',
        hintText: 'Confirm Password',
        controller: _.confirmPassController,
keyboard: TextInputType.text,
        obscureText: !_.visibilityConfirmPass,

        showSuffixIcon: true,
        suffixIcon: IconButton(
          icon: Icon(
            _.visibilityConfirmPass
                ? Icons.visibility
                : Icons.visibility_off,
            color: AppColors.green,
          ),
          onPressed: () {


            _.visibilityConfirmPass =
            !_.visibilityConfirmPass;
            _.update();
          },
        ),
        validations: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(8),

        ]),
      ),
      CustomButton(
        onTap: () {
          if(_.setPassKey.currentState!.validate()){
            if(_.newPassController.text==_.confirmPassController.text){
              _.updatePassword();
            }else{
              showToast(msg: "Password does not match");
            }
          }
        },
        title: 'NEXT',
        btnColor: AppColors.green,
        textColor: AppColors.white,
      ),
        ])
    )
    ])
    ),
    ),
        )
    )
        )
    );
  }
}
