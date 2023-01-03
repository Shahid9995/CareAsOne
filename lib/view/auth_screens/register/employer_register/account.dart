import 'package:careAsOne/view/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controller/Employeer/employee_register_controller.dart';
import '../../../widget/text.dart';
class EmployerAccountScreen extends StatefulWidget {
  const EmployerAccountScreen({Key? key}) : super(key: key);

  @override
  State<EmployerAccountScreen> createState() => _EmployerAccountScreenState();
}

class _EmployerAccountScreenState extends State<EmployerAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final employerRegisterController=Get.find<EmployerRegisterController>();
    return Container(
      height: MediaQuery.of(context).size.height*0.85,
      child: Padding(
      padding: const EdgeInsets.all(15.0),
      child:Container(

        child: SingleChildScrollView(
          child: FormBuilder(
            key:employerRegisterController.formKey,
            child: Column(
                children: [
                  MainHeading("Account"),
                  SizedBox(height: 10,),
                   Column(children: [
                      DecoratedInputField(
                        name: 'fname',
                        text: 'First Name*',
                        hintText: 'First Name',
                        // icon: Icons.email,

                        controller: employerRegisterController.firstName,
                        keyboard: TextInputType.text,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        onChange: (val) {},
                      ),
                     employerRegisterController.firstNameError==null?SizedBox():Row(
                       children: [
                         SubText(employerRegisterController.firstNameError!,color: Colors.red,),
                       ],
                     ),
                      DecoratedInputField(
                        name: 'lname',
                        text: 'Last Name*',
                        hintText: 'Last Name',
                        controller: employerRegisterController.lastName,
                        // icon: Icons.email,
                        keyboard: TextInputType.text,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        onChange: (val) {},
                      ),
                     employerRegisterController.lastNameError==null?SizedBox():Row(
                       children: [
                         SubText(employerRegisterController.lastNameError!,color: Colors.red,),
                       ],
                     ),
                      DecoratedInputField(
                        name: 'email',
                        text: 'Email*',
                        hintText: 'Email',
                        controller: employerRegisterController.email,
                        // icon: Icons.email,
                        keyboard: TextInputType.emailAddress,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                        onChange: (val) {},
                      ),
                     employerRegisterController.emailError==null?SizedBox():Row(
                       children: [
                         SubText(employerRegisterController.emailError!,color: Colors.red,),
                       ],
                     ),
                      DecoratedInputField(
                        name: 'Phone',
                        text: 'Phone*',
                        hintText: 'Phone',
                        // icon: Icons.email,
                        controller: employerRegisterController.phone,
                        keyboard: TextInputType.phone,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          // FormBuilderValidators.minLength(context, 11),
                          // FormBuilderValidators.maxLength(context, 15),
                        ]),
                        onChange: (val) {},
                      ),
                     employerRegisterController.phoneError==null?SizedBox():Row(
                       children: [
                         SubText(employerRegisterController.phoneError!,color: Colors.red,),
                       ],
                     ),
                      DecoratedInputField(
                        name: 'Password',
                        text: 'Password*',
                        controller: employerRegisterController.password,
                        hintText: '8 - 16 symbols',
                        // icon: Icons.email,
                        obscureText: !employerRegisterController.passwordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            employerRegisterController.passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              employerRegisterController.passwordVisible =
                              !employerRegisterController.passwordVisible;
                              employerRegisterController.update();
                            });

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
                     employerRegisterController.passwordError==null?SizedBox():Row(
                       children: [
                         SubText(employerRegisterController.passwordError!,color: Colors.red,),
                       ],
                     ),
                      DecoratedInputField(
                        name: 'confirm',
                        text: 'Confirm Password*',
                        hintText: 'Confirm Password',
                        controller: employerRegisterController.repeatPassword,
                        // icon: Icons.email,
                        obscureText: !employerRegisterController.confirmPassVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            employerRegisterController.confirmPassVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              employerRegisterController.confirmPassVisible =
                              !employerRegisterController.confirmPassVisible;
                              employerRegisterController.update();
                            });

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
                     employerRegisterController.confirmPasswordError==null?SizedBox():Row(
                       children: [
                         SubText(employerRegisterController.confirmPasswordError!,color: Colors.red,),
                       ],
                     ),
                      DecoratedInputField(
                        name: 'address',
                        text: 'Address*',
                        hintText: 'Address',
                        controller: employerRegisterController.addressController,
                        // icon: Icons.email,

                        keyboard: TextInputType.text,
                        validations: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),

                        ]),
                        onChange: (val) {},
                      ),
                    //  CustomButton(textColor: Colors.white,btnColor: AppColors.green,)
                    ],),
                  employerRegisterController.addressError==null?SizedBox():Row(
                    children: [
                      SubText(employerRegisterController.addressError!,color: Colors.red,),
                    ],
                  ),



                ],
              ),
          ),
        ),
      ),
      ),
    );
  }
}
