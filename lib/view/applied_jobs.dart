import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/applied_jobs.dart';
import 'package:careAsOne/view/job_seeker/jobs_detail.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class AppliedJobsPage extends StatelessWidget {
  const AppliedJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    final width = Get.width;
    return GetBuilder<AppliedJobsController>(
        init: AppliedJobsController(),
        builder: (_) => SingleChildScrollView(
            child: Container(
                // height: Get.height * 1.8,
                width: width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeading('Applied Jobs'),
                    SizedBox(height: 10.0),
                    SearchField(
                      onChange: (val) {
                        _.jobName=val!.toLowerCase();
                        _.searchedList=[];
                        _.update();
                        for(int i=0;i<_.responseData.length;i++){
                          if(_.responseData[i].jobs!.title.toString().toLowerCase().contains(_.jobName.toLowerCase())){
                            _.searchedList.add(_.responseData[i]);
                            _.update();
                          }
                        }

                      },
                      validators: FormBuilderValidators.compose([]),
                      suffixIcon: Icon(Icons.search,color: AppColors.green,),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: double.maxFinite,
                      height: 40.0,
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: AppColors.black.withOpacity(0.7)),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _.dropdownValue,
                        underline: SizedBox(),
                        items: <String>['RECENT','OLD']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: SubText(value, size: 12.0),
                          );
                        }).toList(),
                        onChanged: (val) {
                            _.dropdownValue = val!;
                            _.reversedList=[];
                            if(_.dropdownValue=="RECENT"){
                              _.isRecent=true;
                             _.reversedList= _.responseData.reversed.toList();
                            }

                          _.update();
                        },
                      ),
                    ),
                    // SizedBox(height: 10.0),
                    _.searchedList.length==0?Column(
                      children: List.generate(_.reversedList.length==0?_.responseData.length:_.reversedList.length, (index) {
                        //var htmlContent=_.responseData[index].jobs.location;
                        return AppliedJobCard(
                          heading: _.reversedList.length==0?_.responseData[index].jobs!.title:_.reversedList[index].jobs.title,
                          location:
                          _.reversedList.length==0?'${_parseHtmlString(_.responseData[index].jobs!.location)}':'${_parseHtmlString(_.reversedList[index].jobs.location)}',
                          time: _.reversedList.length==0?_.responseData[index].appliedOn:_.reversedList[index].appliedOn,
                          status: _.reversedList.length==0?_.responseData[index].status.toString().capitalizeFirst:_.reversedList[index].status.toString().capitalizeFirst,
                          salary: _.reversedList.length==0?"\$ ${_.responseData[index].jobs!.salary}":"\$ ${_.reversedList[index].jobs.salary}",
                          onView: () {
                            Get.to(() => JobsDetails(), arguments: [
                              _.reversedList.length==0?_.responseData[index].jobId:_.reversedList[index].jobId,
                              _.reversedList.length==0?_.responseData[index].appliedOn:_.reversedList[index].appliedOn,
                              "Applied"
                            ]);
                          },
                          onTap: () {

                              _.deleteAppliedJob(_.responseData[index].id!);
                              },
                        );
                      }),
                    ):Column(children: List.generate(_.searchedList.length, (index) {
                      return AppliedJobCard(
                        heading: _.searchedList[index].jobs!.title,
                        location:
                        '${_parseHtmlString(_.searchedList[index].jobs!.location)}',
                        time: _.searchedList[index].appliedOn,
                        status: _.searchedList[index].status!.capitalizeFirst,
                        salary: "\$ ${_.searchedList[index].jobs!.salary}",
                        onView: () {
                          Get.to(() => JobsDetails(), arguments: [
                            _.searchedList[index].jobId,
                            _.searchedList[index].appliedOn,
                            "Applied"
                          ]);
                        },
                        onTap: () {
                          if(_.searchedList[index].status=="hired"){
                            showToast(msg:"You cannot delete this job");
                          }else{
                            _.deleteAppliedJob(_.searchedList[index].id!);
                          }

                        },
                      );
                    }),),
                  ],
                ))));
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
