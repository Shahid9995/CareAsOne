import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/Employeer/emp_profile.dart';
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


class EmpProfilePage extends StatelessWidget {
  final scaffoldKeyEmployee = new GlobalKey<ScaffoldState>();
  final empProfileKey = new GlobalKey<FormBuilderState>();

  String? isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      if (input == originalFormatString) {
        return "true";
      }
      return null;
    } catch (e) {
      return "false";
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    return GetBuilder<EmpProfileController>(
        init: EmpProfileController(),
        builder: (_) => Scaffold(
            backgroundColor: AppColors.bgGreen,
            body: Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              margin: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: empProfileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainHeading('Profile Settings'),
                      SizedBox(height: 20.0),
                      SubText("My Account", size: 20, color: AppColors.green),
                      _.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.green)),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Center(
                                    child: _.image == null
                                        ? CircularCachedImage(
                                            iconColor: Colors.grey,
                                            radius: width(context) / 8,
                                            imageUrl:
                                                "https://www.pngitem.com/pimgs/m/421-4212617_person-placeholder-image-transparent-hd-png-download.png",
                                          )
                                        : CircularCachedImage(
                                            radius: width(context) / 8,
                                            imageUrl:
                                                "${BaseApi.domainName}${_.image}"),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(onTap: ()async{
                                      await _
                                          .showSelectionDialog(context);
                                    },
                                      child: Column(children: [
                                   Icon(
                                              FontAwesomeIcons.edit,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                        SubText("upload pic")
                                      ]),
                                    ),
                                    SizedBox(width: 15,),
                                    /*        IconButton(
                                        onPressed: () async {
                                          await _.showSelectionDialog(context);
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.edit,
                                          color: Colors.grey,
                                          size: 20,
                                        )),*/
                                    _.image == null
                                        ? SizedBox()
                                        : InkWell(
                                      onTap: ()async{
                                        await _.showSelectionDialog(
                                            context,
                                            isDelete: true);
                                      },
                                          child: Column(
                                              children: [
                                               Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.grey,
                                                      size: 25,
                                                    ),
                                                SubText("delete")
                                              ],
                                            ),
                                        )
                                  ],
                                ),
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
                                  controller: _.lName,
                                  icon: Icons.email,
                                  keyboard: TextInputType.text,

                                  validations: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                  onChange: (val) {
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SubText(
                                    "Email".toUpperCase(),
                                    size: 10,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: width(context),
                                  padding: EdgeInsets.only(
                                      top: 13, bottom: 13, left: 8),
                                  margin: EdgeInsets.only(bottom: 10, left: 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black38, width: 1)),
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
                                  controller: _.contact,
                                  icon: Icons.email,
                                  keyboard: TextInputType.phone,
                                  validations: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(),

                                  ]),
                                  onChange: (val) {
                                  },
                                ),
                                SizedBox(height: 15.0),
                                CustomButton(
                                  onTap: () {
                                    if (empProfileKey.currentState!.validate()) {
                                      _.updateProfile(context, params: {
                                        'first_name': _.fName.text,
                                        'last_name': _.lName.text,
                                        'dob': _.dob.text.isEmpty? "":_.dob.text,
                                        'phone_number': _.contact.text,
                                        'email': _.email.text
                                      });
                                    }
                                  },
                                  title: 'SAVE PROFILE',
                                  textColor: AppColors.white,
                                  btnColor: AppColors.green,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
