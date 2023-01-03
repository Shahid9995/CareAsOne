import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/JobSeeker/seeker_account.dart';
import 'package:careAsOne/view/profile/setting/form_key.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  // final jobSeekerAccountKey = new GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate= DateTime.now();
    var clockString;
    var pickedDate;
    //  GetStorage storage;
    return GetBuilder<SeekerAccountController>(
      init: SeekerAccountController(),
      builder: (_) => Container(
        height: height(context) * 0.65,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.green)),
                      )
                    : Center(
                        child: _.image == null
                            ? CircularCachedImage(
                                radius: width(context) / 8,
                                imageUrl:
                                    'https://image.freepik.com/free-photo/front-view-man-with-straight-face_23-2148364723.jpg',
                              )
                            : CircularCachedImage(
                                radius: width(context) / 8,
                                imageUrl: "${BaseApi.domainName}${_.image}"),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: ()async{
                      await _.showSelectionDialog(context);
                    },
                    child: Column(
                      children: [
                       Icon(
                              FontAwesomeIcons.edit,
                              color: Colors.grey,
                              size: 20,
                            ),
                        SubText("upload pic")
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  _.image == null
                      ? SizedBox()
                      : InkWell(
                    onTap: () async {
                      await _.showSelectionDialog(context,
                          isDelete: true);
                    },
                        child: Column(children: [
                             Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                            SubText("delete")
                          ]),
                      ),
                ],
              ),
              FormBuilder(
                  key: FormKey.acountKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedInputField(
                          name: 'First Name',
                          text: "FIRST NAME*",
                          hintText: 'First Name',
                          icon: Icons.email,
                          controller: _.fName,
                          keyboard: TextInputType.text,
                          validations: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChange: (val) {
                            val = _.fName.text;
                          },
                        ),
                        DecoratedInputField(
                          name: 'Last Name',
                          text: "LAST NAME*",
                          hintText: 'Last Name',
                          icon: Icons.email,
                          controller: _.lName,
                          keyboard: TextInputType.text,
                          validations: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChange: (val) {
                          },
                        ),
                        SizedBox(height: 12.7,),
                        SubText('GENDER', size: 10.0),
                        Row(
                          children: <Widget>[
                            Radio<String>(
                              value: "Male",
                              groupValue: _.genderRadioBtnVal,
                              onChanged: _.handleGenderChange,
                            ),
                            Text("Male"),
                            Radio<String>(
                              value: "Female",
                              groupValue: _.genderRadioBtnVal,
                              onChanged: _.handleGenderChange,
                            ),
                            Text("Female"),
                          ],
                        ),
                        _.genderBool==true?SubText('This field is required.', size: 10.0,color: Colors.red,):SizedBox(),
                        SizedBox(
                          height: 5,
                        ),
                        SubText(
                          "EMAIL*",
                          size: 11,
                        ),
                        Container(
                          width: width(context),
                          padding:
                              EdgeInsets.only(top: 13, bottom: 13, left: 8),
                          margin: EdgeInsets.only(bottom: 10, left: 0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black38, width: 1)),
                          child: SubText(
                            _.email.text,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                        DecoratedInputField(
                          name: 'Phone',
                          text: "PHONE*",
                          hintText: 'Phone',
                          controller: _.phone,
                          icon: Icons.email,
                          keyboard: TextInputType.phone,
                          validations: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChange: (val) {
                          },
                        ),
                        SizedBox(height: 12.7,),
                        SubText(
                          "DATE OF BIRTH*",
                          size: 11,
                        ),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(1920, 8),
                                lastDate: DateTime.now());
                            pickedDate=picked;
                            if (picked != null && picked != selectedDate) {
                              selectedDate = picked;
                              _.dob.text = picked.toString().split(" ")[0];
                              _.update();
                            }else{
                              _.dobBool=true;
                              _.update();
                            }
                          },
                          child: Container(
                            width: width(context),
                            padding:
                                EdgeInsets.only(top: 13, bottom: 13, left: 8),
                            margin: EdgeInsets.only(bottom: 10, left: 0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black38, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SubText(
                                  _.dob.text != null
                                      ? _.dob.text
                                      : "Date of Birth",
                                  size: 15,
                                  color: Colors.grey[700],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _.dobBool==true?SubText("This field is required.", size: 11,color: Colors.red,):SizedBox(),
                        DecoratedInputField(
                          name: 'City',
                          text: "CITY*",
                          hintText: 'City',
                          icon: Icons.email,
                          controller: _.city,
                          keyboard: TextInputType.text,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                          ],
                          validations: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChange: (val) {
                          },
                        ),
                        DecoratedInputField(
                          name: 'State',
                          text: "STATE*",
                          hintText: 'State',
                          icon: Icons.email,
                          controller: _.state,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                          ],
                          keyboard: TextInputType.text,
                          validations: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChange: (val) {
                          },
                        ),
                        DecoratedInputField(
                          name: 'Zip Code',
                          text: "ZIP CODE*",
                          hintText: 'Zip Code',
                          icon: Icons.email,
                          controller: _.zipCode,
                          keyboard: TextInputType.number,
                          validations: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.integer(),
                            FormBuilderValidators.minLength(4)
                          ]),
                          onChange: (val) {
                          },
                        ),
                        SizedBox(height: 15.0),
                        CustomButton(
                          onTap: () {
                            if (FormKey.acountKey.currentState!.validate()) {
                              if((pickedDate!=null&&selectedDate!=null)||_.dob.text!=null){
                              }else{
                                _.dobBool=true;
                                _.update();
                              }

                              if(_.genderRadioBtnVal==null) {
                                _.genderBool=true;
                                _.update();

                              }
                            else {
                                if(_.dob.text=="dd/mm/yyyy"){
                                  showToast(msg:"please enter Date Of Birth");
                                }else{
                                  _.dobBool=false;
                                  _.update();
                                  _.saveAccountDetails(context, body: {
                                    "first_name": _.fName.text,
                                    "last_name": _.lName.text,
                                    "phone_number": _.phone.text,
                                    "city": _.city.text,
                                    "state": _.state.text,
                                    "gender": _.genderRadioBtnVal,
                                    "zip_code": _.zipCode.text,
                                    "dob": _.dob.text,
                                  });
                                }

                              }

                              //Get.offAndToNamed("/homeMaster");
                            }
                          },
                          title: 'SAVE CHANGES',
                          textColor: AppColors.white,
                          btnColor: AppColors.green,
                        ),
                      ])),
              SizedBox(height: 30.0),
              DecoratedInputField(
                name: 'current',
                text: "Current Password",
                hintText: '8 - 16 symbols',
                icon: Icons.email,
                controller: _.currentPassword,
                obscureText: !_.currentPasswordVisible,
                showSuffixIcon: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _.currentPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.green,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable

                    _.currentPasswordVisible = !_.currentPasswordVisible;
                    _.update();
                  },
                ),
                keyboard: TextInputType.text,
                validations: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(8),
                  FormBuilderValidators.maxLength(16)
                ]),
                onChange: (val) {
                },
              ),
              DecoratedInputField(
                name: 'new',
                text: "New Password",
                hintText: '8 - 16 symbols',
                icon: Icons.email,
                controller: _.newPassword,
                obscureText: !_.newPasswordVisible,
                showSuffixIcon: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _.newPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.green,
                  ),
                  onPressed: () {
                    _.newPasswordVisible = !_.newPasswordVisible;
                    _.update();
                  },
                ),
                keyboard: TextInputType.text,
                validations: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(8),
                  FormBuilderValidators.maxLength(16)
                ]),
                onChange: (val) {
                },
              ),
              DecoratedInputField(
                name: 'confirm',
                text: "Confirm New Password",
                hintText: 'Repeat password',
                icon: Icons.email,
                controller: _.matchNewPassword,
                obscureText: !_.matchPasswordVisible,
                showSuffixIcon: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _.matchPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.green,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable

                    _.matchPasswordVisible = !_.matchPasswordVisible;
                    _.update();
                  },
                ),
                keyboard: TextInputType.text,
                validations: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(8),
                  FormBuilderValidators.maxLength(16)
                ]),
                onChange: (val) {
                },
              ),
              SizedBox(height: 15.0),
              CustomButton(
                onTap: () {
                  _.changePassword(context, body: {
                    'current_password': _.currentPassword,
                    'new_password': _.newPassword,
                    'password_confirm': _.matchNewPassword
                  });
                },
                title: 'CHANGE PASSWORD',
                textColor: AppColors.white,
                btnColor: AppColors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, selectedDate) async {}
}
