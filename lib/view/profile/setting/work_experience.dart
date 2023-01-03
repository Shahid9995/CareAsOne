
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/JobSeeker/experience_controller.dart';
import 'package:careAsOne/model/seeker_employment_details.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';

class WorkExperiencePage extends StatefulWidget {
  @override
  _WorkExperiencePageState createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
  SeekerEmploymentDetails seekerEmploymentDetails = SeekerEmploymentDetails();
  final jobSeekerExpKey = new GlobalKey<FormBuilderState>();
  var companyDetailsCopy;
  List<Map<String, dynamic>> comDetailDouble = [];
  var maps = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var clockString;
   var selectedDates =  DateTime.now();
    return GetBuilder<SeekerExperienceController>(
        init: SeekerExperienceController(),
        builder: (_) => Container(
            height: height(context) * 0.65,
            child: SingleChildScrollView(
                child: FormBuilder(
              key: jobSeekerExpKey,
              child: Column(
                children: [
                  SizedBox(height: height(context) / 15),
                  DecoratedInputField(
                    name: 'Experience',
                    text: "YEARS OF EXPERIENCE",
                    hintText: 'Experience',
                    icon: Icons.email,
                    controller: _.yearOfExperience,
                    keyboard: TextInputType.number,
                    validations: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer(),
                    ]),
                    onChange: (val) {

                    },
                  ),

                  SizedBox(height: 20),
                  Text(
                    "Work History",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.green),
                  ),
                  Column(
                      children: List.generate(
                          _.companies.length,
                          (index) => Column(children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DecoratedInputField(
                                        name: 'Job Title',
                                        text: "JOB TITLE*",
                                        hintText: "Job Title",
                                        icon: Icons.email,
                                        controller: _.jobTitle[index]
                                          ..text =
                                              _.companies[index]["Designation"],
                                        keyboard: TextInputType.text,
                                        validations:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        onChange: (val) {
                                          _.companies[index]["Designation"] =
                                              val;
                                        },
                                      ),
                                      
                                      DecoratedInputField(
                                        name: 'Current Company',
                                        text: "CURRENT COMPANY*",
                                        hintText: "Current Company",
                                        icon: Icons.email,

                                        controller: _.currentCompany[index]
                                          ..text =
                                              _.companies[index]["Company"],
                                        validations:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        onChange: (val) {
                                          _.companies[index]["Company"] = val;
                                        },
                                      ),

                                       
                                      SizedBox(height: 12.7,),
                           SubText("WORKING SINCE*",size: 11,),
                                        InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDates,
                                  firstDate: DateTime(1920, 8),
                                  lastDate: DateTime.now()
                                  );
                              if (picked != null ) {
                                setState(() {
                                  selectedDates = picked;
 final dateTime = DateTime.parse(selectedDates.toString());
                                  final format = DateFormat('dd/MM/yyyy');
                                  clockString = format.format(dateTime);
                                  _.update();
                                  _.companies[index]["WorkingSince"]=selectedDates.toString().split(" ")[0];
                                  _.update();
                                });
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [

                                  clockString==null&&_.companies[index]["WorkingSince"]==null?SubText(
                                          "Working Since",
                                            size: 15,
                                            color: Colors.grey[700],

                                               ):clockString!=null?
                                  SubText(
                                    "$clockString",
                                    size: 15,
                                    color: Colors.grey[700],

                                  ):_.companies[index]["WorkingSince"]!=null&&clockString==null?  SubText(
                                    "${_.companies[index]["WorkingSince"]}",
                                    size: 15,
                                    color: Colors.grey[700],

                                  ):SubText("Invalid"),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Icons.calendar_today,color: Colors.grey,),
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
                                        controller: _.skillSet[index]
                                          ..text = _.companies[index]["Skills"],
                                        validations:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        onChange: (val) {
                                          _.companies[index]["Skills"] = val;
                                        },
                                      ),
                                      
                                      DecoratedInputField(
                                        name: 'City',
                                        text: "CITY*",
                                        hintText: "City",
                                        icon: Icons.email,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[a-z A-Z]")),
                                        ],
                                        controller: _.city[index]
                                          ..text =
                                              _.companies[index]["Location"],
                                        keyboard: TextInputType.text,
                                        validations:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        onChange: (val) {
                                          _.companies[index]["Location"] = val;
                                        },
                                      ),
                                      
                                      DecoratedInputField(
                                        name: 'State',
                                        text: "STATE*",
                                        hintText: "State",
                                        icon: Icons.email,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[a-zA-Z]")),
                                        ],
                                        controller: _.state[index]
                                          ..text = _.companies[index]["State"],
                                        keyboard: TextInputType.text,
                                        validations:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        onChange: (val) {
                                          _.companies[index]["State"] = val;
                                        },
                                      ),
                                      CustomTransparentButton(
                                        icon: Icons.delete,
                                        onTap: () {
                                          if (_.companies.length < 2) {
                                            showToast(
                                                msg:
                                                    "You cannot delete last entry",
                                                backgroundColor: Colors.red);
                                          } else {
                                            _.companies.removeAt(index);
                                            _.update();
                                          }
                                        },
                                        title: "DELETE",
                                      )
                                    ]),
                              ]))),
                  CustomTransparentButton(
                    onTap: () async {
                      await _.showSelectionDialog(context);
                    },
                    title: "ADD NEW",
                  ),

                  Column(children: [
                    SizedBox(height: 25),
                    Text(
                      "Add References",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.green),
                    ),
                    SizedBox(height: 15),
            Column(children: List.generate(_.reference.length, (index) {
              return Column(children: [
                DecoratedInputField(
                  name: 'Person Name',
                  text: "NAME OF THE PERSON",
                  hintText: 'Person Name',
                  icon: Icons.email,
                  controller: _.refPersonName[index]..text=_.reference[index]['ReferralPersonName'],
                  keyboard: TextInputType.name,
                  onChange: (val) {
                    _.reference[index]['ReferralPersonName']=val;
                  },
                ),
                
                DecoratedInputField(
                  name: 'Company Name',
                  text: "CURRENT COMPANY",
                  hintText: 'Company Name',
                  icon: Icons.email,
                  controller: _.refCompany[index]..text=_.reference[index]['CompanyName'],
                  keyboard: TextInputType.text,
                  validations:FormBuilderValidators.compose([

                  ]),
                  onChange: (val) {
                    _.reference[index]['CompanyName']=val;
                  },
                ),
                
                DecoratedInputField(
                  name: 'Phone number',
                  text: "PHONE Number",
                  hintText: 'Phone Number',
                  icon: Icons.email,
                  controller: _.refPhone[index]..text=_.reference[index]['PhoneNo'],

                  keyboard: TextInputType.phone,
                  validations: FormBuilderValidators.compose(
                      [FormBuilderValidators.numeric()]),
                  onChange: (val) {
                    _.reference[index]['PhoneNo']=val;
                  },
                ),
                
                DecoratedInputField(
                  name: 'Email',
                  text: "EMAIL",
                  hintText: 'Email',
                  icon: Icons.email,
                  controller: _.refEmail[index]..text=_.reference[index]['Email'],
                  keyboard: TextInputType.emailAddress,
                  validations: FormBuilderValidators.compose(
                      [FormBuilderValidators.email(),
                      ]),
                  onChange: (val) {
                    _.reference[index]['Email']=val;
                  },
                ),
                CustomTransparentButton(
                  icon: Icons.delete,
                  onTap: () {
                      _.reference.removeAt(index);
                      _.update();
                  },
                  title: "DELETE",
                )
              ],);}),)
            /*       */,
                    CustomTransparentButton(
                      onTap: () async {
                        // _.addList();
                        await _.showSelectionDialogReference(context);
                      },
                      title: "ADD NEW",
                    ),
                    SizedBox(height: Get.height / 14),
                    CustomButton(
                      onTap: () {
                        if (jobSeekerExpKey.currentState!.validate()) {
                          if(_.companies.length==0){
showToast(msg: "Please enter work history");
                          }else{
                            _.saveWorkHistory(context);
                          }
                        }
                      },
                      title: 'SAVE CHANGES',
                      textColor: AppColors.white,
                      btnColor: AppColors.green,
                    ),
                  ])
                ],
              ),
            ))));
  }
}