import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/video_interview.dart';
import 'package:careAsOne/model/all_job_applicants.dart';
import 'package:careAsOne/view/Employeer/video_interview_meetings/video_interview.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
    as DatePicker;

class VideoInterview extends StatefulWidget {
  @override
  _VideoInterviewState createState() => _VideoInterviewState();
}

class _VideoInterviewState extends State<VideoInterview> {
  final videoInterviewKey = new GlobalKey<FormBuilderState>();

  List<String> jobs = [];
  List? weightData;
  String? appId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoInterviewController>(
      init: VideoInterviewController(),
      builder: (_) => FormBuilder(
        key: videoInterviewKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
              width: double.maxFinite,
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainHeading('Video Interviews'),
                  SizedBox(height: 20),
                  SubText(
                    "SELECT APPLICANT",
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5.0),
                  _.userJobService.allInterviewApplicants == null
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: double.maxFinite,
                          height: 40.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.7)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Applicant",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: double.maxFinite,
                          height: 40.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.7)),
                          ),
                          child: DropdownButton<AllApplicantsInterview>(
                            elevation: 16,
                            iconEnabledColor: AppColors.green,
                            iconDisabledColor: Colors.grey,
                            isExpanded: true,
                            underline: Container(
                              height: 0,
                            ),
                            onChanged: (AllApplicantsInterview? newValue) {
                              _.dropdownValue2 =
                                  "${newValue!.firstName}--${newValue.title}";
                              _.applicantId = newValue.applicantId;
                              _.id = newValue.id;
                              _.startDateRange = DateTime.now();
                              _.endDateRange = DateTime.now();
                              _.getRelativeAvailability(
                                  _.applicantId.toString(), _.id.toString());

                              _.update();
                            },
                            hint: _.dropdownValue2 == "" ||
                                    _.dropdownValue2 == null
                                ? Text(
                                    "Select",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(color: AppColors.green),
                                  )
                                : Text(_.dropdownValue2!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(color: AppColors.green)),
                            items: _.userJobService.allInterviewApplicants
                                .map<DropdownMenuItem<AllApplicantsInterview>>(
                                    (dynamic value) {
                              return DropdownMenuItem<AllApplicantsInterview>(
                                value: value.firstName == null ||
                                        value.firstName.isEmpty
                                    ? " "
                                    : value,
                                child:
                                    Text(value.firstName + "--" + value.title),
                              );
                            }).toList(),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  SubText(
                    "SELECT DATE",
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5.0),
                  InkWell(
                    onTap: () {
                      _.selectInterviewDate(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      margin: EdgeInsets.only(top: 0),
                      width: double.maxFinite,
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubText(
                            _.interviewDate == null
                                ? "Select Date"
                                : DateFormat("MM-dd-y")
                                    .format(_.interviewDate!)
                                    .toString(),
                            color: Colors.grey,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SubText(
                    "SELECT SLOT",
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.maxFinite,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _.selectedSlot,
                      underline: SizedBox(),
                      items: _.updatedSlot
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SubText(value, size: 12.0),
                        );
                      }).toList(),
                      onChanged: (val) {
                        _.selectedSlot = val;
                        _.update();
                      },
                      hint: SubText(_.selectedSlot ?? "Select Time Slot",
                          size: 12.0),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SubText(
                    "INTERVIEW TYPE",
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                      value: _.selectedInterviewType,
                      underline: SizedBox(),
                      items: _.interviewTypeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SubText(value, size: 12.0),
                        );
                      }).toList(),
                      onChanged: (val) {
                        _.selectedInterviewType = val!;
                        _.update();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    onTap: () {
                      if (videoInterviewKey.currentState!.validate()) {
                        if (_.applicantId == null || _.id == null) {
                          showToast(
                              msg: "Select Applicant",
                              backgroundColor: Colors.red);
                        } else if (_.interviewDate != null &&
                            _.selectedSlot != null) {
                          _.scheduleInterviewNew(context, {
                            "job_id": "${_.id}",
                            "applicant_id":"${_.applicantId}",
                            "date": DateFormat('MM-dd-y').format(_.interviewDate!).toString(),
                            "schedule_time":_.selectedSlot,
                            "schedule_type":_.selectedInterviewType.toLowerCase()
                          });
                        } else {
                          showToast(
                              msg: "Please Select Date & Time",
                              backgroundColor: Colors.red);
                        }
                      }
                    },
                    btnColor: AppColors.green,
                    textColor: AppColors.white,
                    title: "SAVE SCHEDULE",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    onChange: (val) {
                      _.interViewName = val!.toLowerCase();
                      _.searchedList = [];
                      _.update();
                      for (int i = 0; i < _.scheduledInterview.length; i++) {
                        if (_.scheduledInterview[i].firstName!
                            .toLowerCase()
                            .contains(_.interViewName.toLowerCase())) {
                          _.searchedList.add(_.scheduledInterview[i]);
                          _.update();
                        }
                      }
                    },
                    validators: FormBuilderValidators.compose([]),
                    suffixIcon: IconButton(
                        onPressed: () {},
                        color: AppColors.green,
                        icon: Icon(
                          Icons.search,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.green)),
                        )
                      : _.scheduledInterview == null ||
                              _.scheduledInterview.isEmpty
                          ? Center(
                              child: SubText("No Scheduled Interviews",
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            )
                          : _.searchedList.length == 0
                              ? Column(
                                  children: List.generate(
                                      _.scheduledInterview.length, (index) {
                                  return VideoInterviewCard(
                                    name: _.scheduledInterview[index].firstName,
                                    date: _.scheduledInterview[index]
                                        .formatedInterviewDate,
                                    videoLink: () {
                                      Get.to(() => CreateVideoMeeting(),
                                          arguments: [
                                            _.scheduledInterview[index].email
                                          ]);
                                    },
                                  );
                                }))
                              : Column(
                                  children: List.generate(_.searchedList.length,
                                      (index) {
                                    return VideoInterviewCard(
                                      name: _.searchedList[index].firstName,
                                      date: _.searchedList[index]
                                          .formatedInterviewDate
                                          .toString(),
                                      videoLink: () {
                                        Get.to(() => CreateVideoMeeting());
                                      },
                                    );
                                  }),
                                ),
                ],
              ),
            ),
          ),
        ),
      ),
      // )
    );
  }
}

class finalJobs {
  final String name;
  final String job;
  bool selected = false;

  finalJobs(this.name, this.job);
}
