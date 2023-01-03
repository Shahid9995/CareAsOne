import 'dart:async';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/company_profile.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http_parser/http_parser.dart';

class CompanyProfilePage extends StatelessWidget {
  //final scaffoldKeyCompany = new GlobalKey<ScaffoldState>();
  final companyKey = new GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanyProfileController>(
        init: CompanyProfileController(),
        builder: (_) => Scaffold(
            backgroundColor: AppColors.bgGreen,
            //endDrawer: HomeMasterPage(),
            body: Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              margin: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: companyKey,
                  child: _.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.green)),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainHeading('Company Settings'),
                            SizedBox(height: 20.0),
                            SubText("Company Settings Form",
                                size: 20, color: AppColors.green),
                            SizedBox(
                              height: 20,
                            ),
                            DecoratedInputField(
                              name: 'company Name',
                              controller: _.companyName,
                              text: "COMPANY NAME*",
                              hintText: 'Company Name',
                              icon: Icons.email,
                              keyboard: TextInputType.text,
                       inputFormatters: <TextInputFormatter>[
                         FilteringTextInputFormatter.allow(
                             RegExp("[a-z A-Z]")),
                       ],
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(30),

                              ]),
                              onChange: (val) {
                                val = _.companyName.text;
                              },
                            ),
                            DecoratedInputField(
                              name: 'Zip Code',
                              text: "ZIP CODE*",
                              hintText: 'Zip Code',
                              controller: _.zipCode,
                              icon: Icons.email,
                              keyboard: TextInputType.number,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(6),
                                FormBuilderValidators.minLength(4),
                                FormBuilderValidators.numeric()
                              ]),
                              onChange: (val) {
                              },
                            ),
                            DecoratedInputField(
                              name: 'City',
                              text: "CITY*",
                              controller: _.city,
                              hintText: 'City',
                              icon: Icons.email,
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
                              name: 'state',
                              text: "STATE*",
                              controller: _.state,
                              hintText: 'State',
                              icon: Icons.email,
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
                            ),    DecoratedInputField(
                              name: 'address',
                              text: "ADDRESS*",
                              controller: _.address,
                              hintText: 'Address',
                              icon: Icons.location_city,
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
                              name: 'Country',
                              text: "COUNTRY*",
                              controller: _.country,
                              hintText: 'Country',
                              icon: Icons.email,
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
                              name: 'Contact Person Name',
                              text: "CONTACT PERSON FIRST NAME*",
                              hintText: 'Contact Person Name',
                              icon: Icons.email,
                              keyboard: TextInputType.text,
                              controller: _.contactFName,
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
                              name: 'Contact Person Name',
                              text: "CONTACT PERSON Last NAME*",
                              hintText: 'Contact Person Name',
                              icon: Icons.email,
                              controller: _.contactLName,
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
                              name: 'Phone Number',
                              text: "PHONE NUMBER*",
                              hintText: 'Phone Number',
                              controller: _.contactPhone,
                              icon: Icons.email,
                              keyboard: TextInputType.phone,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),

                              ]),
                              onChange: (val) {
                              },
                            ),
                            _.image != null
                                ? InkWell(
                              onTap: (){

                              },
                                  child: Center(
                                      child: Image.network(
                                      "${BaseApi.domainName}${_.image}",
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    )),
                                )
                                : _.file != null
                                    ? InkWell(
                                        onTap: () {

                                        },
                                        child: Center(
                                            child: Image.file(
                                          _.file!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.fill,
                                        ))):SizedBox(),
                                     InkWell(
                                        onTap: () {
                                          _.openGallery(context);
                                        },
                                        child: UploadDocumentCard(
                                          format: 'png, jpg, jpeg',
                                          tilte: "Upload Company Logo",
                                          docName: "Choose Logo",
                                          isReceivedDoc: false, isSignatureDoc: false,
                                        ),
                                      ),
                            SizedBox(height: 15.0),
                            CustomButton(
                              onTap: () async {
                                if (companyKey.currentState!.validate()) {
                                  //  Get.to(ManageAvailability());
                                  if (_.file==null) {

                                      FormData formData = FormData.fromMap({
                                        "name": _.companyName.text,
                                        "zipcode": _.zipCode.text,
                                        "city": _.city.text,
                                        "state": _.state.text,
                                        "address":_.address.text,
                                        "country": _.country.text,
                                        "contact_person": _.contactFName.text.isEmpty?"":_.contactFName.text,
                                        "preson_last_name": _.contactLName.text.isEmpty?"":_.contactLName.text,
                                        "phone_number": _.contactPhone.text,
                                      });
                                      _.updateCompany(context,
                                          params: formData,
                                          id: _.companyProfileModel!.id);
                                  } else {
                                    String fileName =
                                        _.file!.path.split('/').last;
                                    FormData formData = FormData.fromMap({
                                      "name": _.companyName.text,
                                      "zipcode": _.zipCode.text,
                                      "city": _.city.text,
                                      "state": _.state.text,
                                      "address":_.address.text,
                                      "country": _.country.text,
                                      "contact_person": _.contactFName.text.isEmpty?"":_.contactFName.text,
                                      "preson_last_name": _.contactLName.text.isEmpty?"":_.contactLName.text,
                                      "phone_number": _.contactPhone.text,
                                      "logo": await MultipartFile.fromFile(
                                          _.file!.path,
                                          filename: fileName,
                                          contentType: MediaType(
                                            "jpg",
                                            "png",
                                          )),
                                    });
                                    _.updateCompany(context,
                                        params: formData,
                                        id: _.companyProfileModel!.id);


                                  }
                                  Timer(Duration(seconds: 5), () {
                                    Get.toNamed(AppRoute.empHomeMasterRoute);
                                  });
                                }
                              },
                              title: 'SAVE',
                              textColor: AppColors.white,
                              btnColor: AppColors.green,
                            ),
                          ],
                        ),
                ),
              ),
            )));
  }
}
