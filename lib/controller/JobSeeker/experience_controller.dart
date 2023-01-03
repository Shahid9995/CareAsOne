import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/seeker_employment_details.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SeekerExperienceController extends GetxController {
  var token;
  SeekerProfileModel? applicant;

  var clockString;
  DateTime selectedDate = DateTime.now();
  final popUpKey = new GlobalKey<FormBuilderState>();
  SeekerEmploymentDetails? seekerEmploymentDetails;
  bool isLoading = false;
  final myProfile = Get.find<ProfileService>();
  GetStorage storage = GetStorage();
  TextEditingController yearOfExperience = TextEditingController();
  int index = 0;
  TextEditingController popupJobTitle = TextEditingController();

  TextEditingController popupCurrentCompany = TextEditingController();
  TextEditingController popupWorkingSince = TextEditingController();
  TextEditingController popupSkillSet = TextEditingController();
  TextEditingController popupCity = TextEditingController();
  TextEditingController popupState = TextEditingController();
  TextEditingController popupRefName = TextEditingController();

  TextEditingController popupRefCompanyName = TextEditingController();
  TextEditingController popupRefPhoneNo = TextEditingController();
  TextEditingController popupRefEmail = TextEditingController();
  var companies = [];
  var map = [];
  var dummy = [
    {
      "Designation": "Flutter",
      "Location": "California",
      "State": "California",
      "Skills": "Dart",
      "WorkingSince": "2021-09-24",
      "Company": "MixBox"
    }
  ];
  var reference = [];
  Map<String, dynamic>? mapsMerger;
  String? decoded;
  List<TextEditingController> refPersonName = [];
  List<TextEditingController> refCompany = [];
  List<TextEditingController> refPhone = [];
  List<TextEditingController> refEmail = [];

  List<TextEditingController> jobTitle = [];
  List<TextEditingController> currentCompany = [];
  List<TextEditingController> workingSince = [];
  List<TextEditingController> skillSet = [];
  List<TextEditingController> city = [];
  List<TextEditingController> state = [];
  Map<String, String> companyMap = {};

  @override
  void onInit() async {
    isLoading = true;
    update();
    token = storage.read("authToken");
    getDetails();
    getReferenceDetails();
    seekerEmploymentDetails = await getCompanyDetails(token);
    jobTitle = [for (int i = 1; i < 75; i++) TextEditingController()];
    currentCompany = [for (int i = 1; i < 75; i++) TextEditingController()];
    workingSince = [for (int i = 1; i < 75; i++) TextEditingController()];
    skillSet = [for (int i = 1; i < 75; i++) TextEditingController()];
    city = [for (int i = 1; i < 75; i++) TextEditingController()];
    state = [for (int i = 1; i < 75; i++) TextEditingController()];
    refPersonName = [for (int i = 1; i < 75; i++) TextEditingController()];
    refCompany = [for (int i = 1; i < 75; i++) TextEditingController()];
    refPhone = [for (int i = 1; i < 75; i++) TextEditingController()];
    refEmail = [for (int i = 1; i < 75; i++) TextEditingController()];
    updateData();
    yearOfExperience.text = seekerEmploymentDetails!.experience.toString();
    isLoading = false;
    update();
    super.onInit();
  }

  saveWorkHistory(BuildContext context) async {
    CircularLoader().showAlert(context);
    final response = await http.post(
      Uri.parse(
          '${BaseApi.domainName}api/job-seeker/employment-history?api_token=$token'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "year_of_experience": yearOfExperience.text,
        "company_details": companies,
        "references": reference,
      }),
    );
    if (response.statusCode == 200) {
      Get.back();
      showToast(msg: "Work History Saved", backgroundColor: AppColors.green);

      Get.find<HomeController>().update();

      await Get.find<HomeController>().getOverallData(token);
      update();
      isLoading = false;
      update();
    } else {
      showToast(msg: "ERROR");
    }
  }

  addList(popupJobTitle, popupCurrentCompany, popupSkillSet, popupCity,
      popupState, popupWorking) {
    var body = {
      "Designation": popupJobTitle,
      "Location": popupCity,
      "State": popupState,
      "Skills": popupSkillSet,
      "WorkingSince": popupWorking,
      "Company": popupCurrentCompany
    };
    companies.add(body);
    update();
  }

  addReference(
      popupReferenceName, popupCompanyName, popupPhoneNumber, popupEmail) {
    var body = {
      "ReferralPersonName": popupReferenceName,
      "CompanyName": popupCompanyName,
      "PhoneNo": popupPhoneNumber,
      "Email": popupEmail,
    };
    reference.add(body);
    update();
  }

  addCompany() {
    for (int i = 0; i < seekerEmploymentDetails!.companyDetails!.length; i++) {
      companyMap['year_of_experience'] = yearOfExperience.text;
      companyMap["company_details[$i][Designation]"] =
          seekerEmploymentDetails!.companyDetails![i].designation ?? "0";
      companyMap['company_details[$i][Location]'] =
          seekerEmploymentDetails!.companyDetails![i].location ?? "0";
      companyMap['company_details[$i][State]'] =
          seekerEmploymentDetails!.companyDetails![i].state ?? "0";
      companyMap['company_details[$i][Skills]'] =
          seekerEmploymentDetails!.companyDetails![i].skills ?? "0";
      companyMap['company_details[$i][WorkingSince]'] =
          seekerEmploymentDetails!.companyDetails![i].workingSince ?? "0";
      companyMap['company_details[$i][Company]'] =
          seekerEmploymentDetails!.companyDetails![i].companyName ?? "0";
    }
  }

  getDetails() async {
    Dio dio = new Dio();
    Response response = await dio.get(
        "${BaseApi.domainName}api/job-seeker/profile",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}));
    if (response.statusCode == 200) {
      companies.addAll(
          response.data["data"]["user_employment_detail"]["company_details"]);
    }
  }

  getReferenceDetails() async {
    Dio dio = new Dio();
    Response response = await dio.get(
        "${BaseApi.domainName}api/job-seeker/profile",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}));
    if (response.statusCode == 200) {
      reference.addAll(
          response.data["data"]["user_employment_detail"]["references"]);
    }
  }

  updateData() {
    isLoading = true;
    update();
    yearOfExperience.text = seekerEmploymentDetails!.experience!;
    isLoading = false;
    update();
  }
  Future<SeekerEmploymentDetails> getCompanyDetails(token) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/profile',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        seekerEmploymentDetails = SeekerEmploymentDetails.fromJson(
            response.data['data']['user_employment_detail']);
      }
    } catch (e) {
      return seekerEmploymentDetails!;}
    return seekerEmploymentDetails!;
  }

  Future showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              content:StatefulBuilder(builder: (context,setState)=> SingleChildScrollView(
                child: FormBuilder(
                  key: popUpKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListBody(
                      children: [
                        ListBody(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              "Work History",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.green),
                            ),
                            DecoratedInputField(
                              name: 'Job Title',
                              text: "JOB TITLE*",
                              hintText: "Job Title",
                              icon: Icons.email,
                              controller: popupJobTitle,
                              keyboard: TextInputType.text,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 10),
                            DecoratedInputField(
                              name: 'Current Company',
                              text: "CURRENT COMPANY*",
                              hintText: "Current Company",
                              icon: Icons.email,
                              controller: popupCurrentCompany,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 10),
                            SubText(
                              "WORKING SINCE*",
                              size: 11,
                            ),
                            InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(1920, 8),
                                    lastDate: DateTime.now());
                                if (picked != null && picked != selectedDate) {
                                  selectedDate = picked;
                                  update();
                                  setState((){
                                    popupWorkingSince.text =
                                    picked.toString().split(" ")[0];
                                  });

                                  update();
                                }
                              },
                              child: Container(
                                width: width(context),
                                padding: EdgeInsets.only(
                                    top: 13, bottom: 13, left: 8),
                                margin: EdgeInsets.only(bottom: 10, left: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black38, width: 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SubText(
                                      popupWorkingSince.text != ""
                                          ? "${popupWorkingSince.text.toString()}"
                                          : "Working Since",
                                      size: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            DecoratedInputField(
                              name: 'job duties',
                              text: "JOB DUTIES*",
                              hintText: "Job Duties",
                              icon: Icons.email,
                              keyboard: TextInputType.text,
                              controller: popupSkillSet,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 10),
                            DecoratedInputField(
                              name: 'City',
                              text: "CITY*",
                              hintText: "City",
                              icon: Icons.email,
                              controller: popupCity,
                              keyboard: TextInputType.text,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 10),
                            DecoratedInputField(
                              name: 'State',
                              text: "STATE*",
                              hintText: "State",
                              icon: Icons.email,
                              controller: popupState,
                              keyboard: TextInputType.text,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: MaterialButton(
                                    color: Colors.grey,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: MaterialButton(
                                    color: AppColors.green,
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (popUpKey.currentState!.validate()) {
                                        if (popupWorkingSince.text != "") {
                                          addList(
                                              popupJobTitle.text,
                                              popupCurrentCompany.text,
                                              popupSkillSet.text,
                                              popupCity.text,
                                              popupState.text,
                                              popupWorkingSince.text
                                                  .toString());
                                          popupJobTitle.text = "";
                                          popupCurrentCompany.text = "";
                                          popupSkillSet.text = "";
                                          popupCity.text = "";
                                          popupState.text = "";
                                          popupWorkingSince.text = "";
                                          Navigator.pop(context);
                                        } else {
                                          showToast(
                                              msg:
                                                  "Please Select Working since field");
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ));
        });
  }

  Future showSelectionDialogReference(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              // contentPadding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
              // title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: FormBuilder(
                  key: popUpKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListBody(
                      children: [
                        ListBody(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              "References",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.green),
                            ),
                            DecoratedInputField(
                              name: 'Referral Person Name',
                              text: "Referral Person Name",
                              hintText: "Referral Person Name",
                              icon: Icons.email,
                              controller: popupRefName,
                              keyboard: TextInputType.name,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 10),
                            DecoratedInputField(
                              name: 'Company Name',
                              text: "Company Name",
                              hintText: "Company Name",
                              icon: Icons.email,
                              controller: popupRefCompanyName,
                              keyboard: TextInputType.name,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 10),
                            DecoratedInputField(
                              name: 'phone number',
                              text: "Phone Number",
                              hintText: "Phone Number",
                              icon: Icons.email,
                              keyboard: TextInputType.phone,
                              controller: popupRefPhoneNo,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 10),
                            DecoratedInputField(
                              name: 'email',
                              text: "Email",
                              hintText: "Email",
                              icon: Icons.email,
                              controller: popupRefEmail,
                              keyboard: TextInputType.name,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: MaterialButton(
                                    color: Colors.grey,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: MaterialButton(
                                    color: AppColors.green,
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (popUpKey.currentState!.validate()) {
                                        addReference(
                                            popupRefName.text,
                                            popupRefCompanyName.text,
                                            popupRefPhoneNo.text,
                                            popupRefEmail.text);
                                        popupRefName.text = '';
                                        popupRefCompanyName.text = '';
                                        popupRefPhoneNo.text = '';
                                        popupRefEmail.text = '';
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
