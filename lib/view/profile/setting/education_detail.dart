import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/JobSeeker/education_details.dart';
import 'package:careAsOne/view/profile/setting/form_key.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class EducationDetailsPage extends StatelessWidget {
  final jobSeekerEduKey = new GlobalKey<FormBuilderState>();
  final jobSeekerEdu = new GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    var clockString;
    DateTime selectedDate = new DateTime.now();
 DateTime? picked;
    return GetBuilder<EducationDetailController>(
        init: EducationDetailController(),
        builder: ((_) {
          return Container(
            height: height(context) * 0.4,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SubText("EDUCATION".toUpperCase(), size: 10.0),

                  SizedBox(
                    height: 6,
                  ),
                  FormBuilder(
                      key: FormKey.acountEducationKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        width: double.maxFinite,
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.black.withOpacity(0.7)),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _.dropdownValue,
                          underline: SizedBox(),
                          items: <String>[
                            'High School/Ged',
                            'College/Post-Graduate',
                            'University/Master'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: SubText(value, size: 12.0),
                            );
                          }).toList(),
                          onChanged: (val) {
                            _.dropdownValue = val!;
                            _.update();
                          },
                        ),
                      ),
                          
                          DecoratedInputField(
                            name: 'major',
                            text: "MAJOR*",
                            hintText: 'Major',
                            icon: Icons.email,
                            controller: _.majorDegree,
                            keyboard: TextInputType.text,
                            validations: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            onChange: (val) {
                            },
                          ),
                          
                          DecoratedInputField(
                            name: 'Degree',
                            text: "DEGREE*",
                            hintText: 'Degree',
                            icon: Icons.email,
                            controller: _.specialization,
                            keyboard: TextInputType.text,
                            validations: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            onChange: (val) {
                            },
                          ),
                          
                          DecoratedInputField(
                            name: 'University',
                            text: "UNIVERSITY*",
                            hintText: 'University',
                            icon: Icons.email,
                            keyboard: TextInputType.text,
                            controller: _.universityName,
                            validations: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            onChange: (val) {
                            },
                          ),
                          
                          SizedBox(height: 12.7,),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "YEAR OF GRADUATION*",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                InkWell(
                                  onTap: () async {
                                     picked =
                                        (await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(1920, 8),
                                            lastDate: DateTime.now()));
                                    if (picked != null &&
                                        picked != selectedDate) {
                                      selectedDate = picked!;
_.update();
                                      _.graduation.text = picked.toString().split(" ")[0];
                                      _.update();
                                    }
                                  },
                                  child: Container(
                                    width: width(context),
                                    padding: EdgeInsets.only(
                                        top: 13, bottom: 13, left: 8),
                                    margin:
                                        EdgeInsets.only(bottom: 10, left: 0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black38, width: 1)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SubText(
                                          _.graduation.text != ""
                                              ? _.graduation.text
                                              : "Year of graduation",
                                          size: 15,

                                        ),
                                    Padding(padding: EdgeInsets.only(right: 15),child: Icon(Icons.calendar_today,color: Colors.grey,),)

                                      ],
                                    ),
                                  ),
                                ),
                                _.gradBool?SubText("This Field is Required",color: Colors.red,size: 12,):SizedBox(),
                              ]),
                        ],
                      )),
                  
                  CustomButton(
                    onTap: () {
                      if (
                          FormKey.acountEducationKey.currentState!.validate()) {
if(_.graduation.text==""){
  showToast(msg: "please enter graduation year");
_.gradBool=true;
_.update();
}else{
  _.gradBool=false;
  _.update();
  _.saveEducationDetails(context, body: {
    'highest_qualification': _.dropdownValue,
    'education_details[MajorDegree]': _.majorDegree.text,
    'education_details[Specialization]':
    _.specialization.text,
    'education_details[University]':
    _.universityName.text,
    'education_details[graduation]': _.graduation.text.toString().split(" ")[0],
  });
}



                      }
                    },
                    title: 'SAVE',
                    textColor: AppColors.white,
                    btnColor: AppColors.green,
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
