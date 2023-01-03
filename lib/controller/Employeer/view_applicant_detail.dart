import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/job_applicant.dart';
import 'package:careAsOne/model/jobs.dart';
import 'package:careAsOne/model/jobseeker_slots.dart';
import 'package:careAsOne/model/schedule_interview.dart';
import 'package:careAsOne/model/seeker_availability.dart';
import 'package:careAsOne/model/view_interview.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/user_job.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ViewApplicantDetailController extends GetxController {
  JobsModel? jobsModel;
  JobApplicantModel? jobsInterviewModel;
  ViewInterviewModel? viewInterviewModel;
  List<JobApplicantModel>? jobsApplicantModel;
  List<JobseekerAvailableSlots> jobseekerSlots = [];
  List<JobApplicantModel> responseBody = [];
  List<ScheduleInterviews> scheduledInterview=[];
  List<ScheduleInterviews> responseData=[];
  List<ScheduleInterviews> searchedList = [];
  List<String> selectedDateAvailability = [];
  List<String> updatedSlot = [];
  JobSeekerAvailability jobSeekerAvailability = JobSeekerAvailability();
  String? selectedSlot;
  List<String> interviewTypeList = ["Office", "Video"];
  String selectedInterviewType = "Office";
  DateTime? interviewDate;
  DateTime? startDateRange;
  DateTime? endDateRange;
  String? weekDayName;
  final storage = GetStorage();
  var token;
  bool isLoading = true;
  int remainPostJob = 0;
  var selectExp = "";
  var selectStatus = "";
  var filterStatus = "";
  var filterExp = "";
  bool showMore = false;
  bool showMoreRef = false;
  EmpProfileModel? empProfileModel;
  final myProfile = Get.find<ProfileService>();
  final userJobService = Get.find<UserJobService>();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  List<String> yearExperience = [
    "Select Experience",
    "0 year",
    "1 year",
    "2 year",
    "3 year",
    "4 year",
    "5 year",
    "6 year",
    "7 year",
    "8 year",
    "9 year",
    "10 year",
    "11 year",
    "12 year",
    "13 year",
    "14 year",
    "15 year",
  ];
  List<String> statusList = [
    "Select Status",
    "Pending",
    "Hired",
    "Rejected",
  ];

  final homeMaster = Get.find<HomeMasterController>();

  @override
  void onInit() async {
    token = storage.read("authToken");
    print(token);
    empProfileModel = await myProfile.getUserData(token);
    isLoading = true;
    update();
    if (Get.arguments != null) {
      jobsInterviewModel = Get.arguments["applicantModel"];
      jobsModel = Get.arguments["jobModel"];
      getIntervieweeList(token);
      isLoading = true;
      update();
      if (jobsInterviewModel!.startDateRange != null) {
        startDateRange =
            DateFormat('MM-dd-y').parse(jobsInterviewModel!.startDateRange!);
        endDateRange =
            DateFormat('MM-dd-y').parse(jobsInterviewModel!.endDateRange!);
        interviewDate = startDateRange;
      } else {
        interviewDate = null;
      }
      isLoading = false;
      update();
      if (jobsInterviewModel!.applicant!.jobSeekerDetails!.references == null) {
        jobsInterviewModel!.applicant!.jobSeekerDetails!.references = [];
      }
      await getAvailabilityNew(token);
    }
    super.onInit();
  }

  @override
  void onReady() async {
    isLoading = true;
    update();
    isLoading = false;
    update();
    super.onReady();
  }

  datePicker(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2090, 6, 7), onChanged: (value) {
      String nee = value.toString();
      update();
      date.text = nee.split(" ")[0];
      time.text = nee.split(" ")[1].split(":")[0] +
          ":" +
          nee.split(" ")[1].split(":")[1];
      update();
      final dateTime = DateTime.parse(nee);
      final format = DateFormat('yyyy-MM-dd');
      final clockString = format.format(dateTime);

      date.text = clockString;
      update();
    }, onConfirm: (value) {
      String nee = value.toString();
      update();
      date.text = nee.split(" ")[0];
      update();
      time.text = nee.split(" ")[1].split(":")[0] +
          ":" +
          nee.split(" ")[1].split(":")[1];
      update();
      final dateTime = DateTime.parse(nee);
      final format = DateFormat('yyyy-MM-dd');
      final clockString = format.format(dateTime);
      Get.back();
      setTimeDate(context);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    update();
  }

  Future<void> hireApplicant(BuildContext context, jobId,
      {Map<String, dynamic>? param}) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    Response? response = await BaseApi.post(
        url: 'jobs/applicant/hire', params: {"api_token": token}, body: param);
    if (response!.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Applicant Hired Successfully');
      });
      await userJobService.getJobApplicant(token, jobId);
      update();
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
      responseBody = response.data;
    }
  }

  Future<void> setTimeDate(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Schedule Interview',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[],
            ),
          ),
        );
      },
    );
  }

  selectInterviewDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: startDateRange!,
      firstDate: startDateRange!,
      lastDate: endDateRange!,
    );
    if (selected != null && selected != interviewDate) {
      FocusScope.of(context).requestFocus(FocusNode());
      interviewDate = selected;
      await getAvailableSlots(
          token, DateFormat("MM-dd-y").format(interviewDate!));
      //  getWeekDayFromDate(interviewDate);

      // update();
    }
  }

  getAvailabilityNew(token) async {
    isLoading = true;
    update();
    try {
      Dio dio = Dio();
      var response = await dio.get(
          BaseApi.domainName +
              "api/employer/get-availabilities-new/${jobsInterviewModel!.applicant!.id}",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseBody = response.data;
        jobSeekerAvailability = JobSeekerAvailability.fromJson(responseBody);
        jobSeekerAvailability.data!.forEach((element) {
          element.days!.forEach((element2) {
            if (element2.jobSeekerDetails!.isNotEmpty) {
              // preSelectedIds.add(element2.id);
            }
          });
        });
        if (jobSeekerAvailability.jobseekerDateRange == null) {
          // range = DateFormat('MM-dd-y').format(DateTime.now()).toString() +
          //     " - " +
          //     DateFormat('MM-dd-y').format(DateTime.now()).toString();
          // startDate = DateTime.now();
        } else {
          // range = jobSeekerAvailability.jobseekerDateRange;
        }

        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
      }
    } catch (e) {
      if (e is DioError) {
        isLoading = false;
        update();
        print(e.response);
        print(e.error);
      }
    }
  }

  getAvailableSlots(token, String date) async {
    jobseekerSlots = [];
    updatedSlot = [];
    selectedSlot = null;
    var body = {
      "date": date,
    };


    // try {
      Dio dio = Dio();
      var response = await dio.post(
          BaseApi.domainName +
              "api/employer/available-slot/show/new/${jobsInterviewModel!.applicant!.id}",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}),
          data: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseBody = response.data;
        print(responseBody);
        responseBody.forEach((e) {
          jobseekerSlots.add(JobseekerAvailableSlots.fromJson(e));
        });
        print(jobseekerSlots);
        jobseekerSlots.forEach((element) {
          updatedSlot.add(element.time!.startEnd.toString());
          selectedSlot = updatedSlot[0];
          print(selectedSlot);
          update();
        });

      } else {
        showToast(msg:"error");
      }
    // } catch (e) {
    //   if (e is DioError) {
    //     print(e.response);
    //     print(e.error);
    //   }
    // }
  }

/*
  getWeekDayFromDate(DateTime weekDay) {
    selectedDateAvailability = [];
    selectedSlot = null;
    update();
    weekDayName = DateFormat('EEEE').format(weekDay);
    print(weekDayName);
    if (weekDayName == "Monday") {
      for (int i = 0;
          i <
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.monday.length;
          i++) {
        selectedDateAvailability.add(jobsInterviewModel.applicant
            .jobSeekerDetails.availability.monday[i].from +
            " " +
            jobsInterviewModel.applicant.jobSeekerDetails.availability
                .monday[i].fromTime
                .toString()
                .split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.monday[i].to +
            " " +
            jobsInterviewModel.applicant.jobSeekerDetails.availability
                .monday[i].toTime
                .toString()
                .split(".")[1]);

  */
/*      if (scheduledInterview.isEmpty) {
          selectedDateAvailability.add(jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.monday[i].from +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.monday[i].fromTime
                  .toString()
                  .split(".")[1] +
              " - " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.monday[i].to +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.monday[i].toTime
                  .toString()
                  .split(".")[1]);
        } else {
          for (int j = 0; j < scheduledInterview.length; j++) {
            if (jobsInterviewModel.applicant.email.toString() ==
                scheduledInterview[j].email.toString()) {
              if (scheduledInterview[j].formatedInterviewDate.split(" ")[1] ==
                      jobsInterviewModel.applicant.jobSeekerDetails.availability
                              .monday[i].from +
                          " " +
                          jobsInterviewModel.applicant.jobSeekerDetails
                              .availability.monday[i].fromTime
                              .toString()
                              .split(".")[1] &&
                  scheduledInterview[j]
                          .formatedInterviewDate
                          .split(" ")[0]
                          .toString() ==
                      DateFormat('MM-dd-y').format(weekDay)) {
              } else {
                print(scheduledInterview[j].formatedInterviewDate.split(" ")[1] ==
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .monday[i].from +
                        " " +
                        jobsInterviewModel.applicant.jobSeekerDetails
                            .availability.monday[i].fromTime
                            .toString()
                            .split(".")[1] &&
                    scheduledInterview[j]
                        .formatedInterviewDate
                        .split(" ")[0]
                        .toString() ==
                        DateFormat('MM-dd-y').format(weekDay));
                print(jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .monday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .monday[i].fromTime
                        .toString()
                        .split(".")[1]);
                selectedDateAvailability.add(jobsInterviewModel.applicant
                        .jobSeekerDetails.availability.monday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .monday[i].fromTime
                        .toString()
                        .split(".")[1] +
                    " - " +
                    jobsInterviewModel
                        .applicant.jobSeekerDetails.availability.monday[i].to +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .monday[i].toTime
                        .toString()
                        .split(".")[1]);
              }
            }
          }
        }*/ /*

      }
      if (selectedDateAvailability[0] == "00:00 AM - 00:00 PM") {
        selectedDateAvailability = [];
        selectedSlot = null;
        update();
      } else {
        print(selectedDateAvailability.length);
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    } else if (weekDayName == "Tuesday") {
      for (int i = 0;
          i <
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.tuesday.length;
          i++) {
        selectedDateAvailability.add(jobsInterviewModel.applicant
            .jobSeekerDetails.availability.tuesday[i].from +
            " " +
            jobsInterviewModel.applicant.jobSeekerDetails.availability
                .tuesday[i].fromTime
                .toString()
                .split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.tuesday[i].to +
            " " +
            jobsInterviewModel.applicant.jobSeekerDetails.availability
                .tuesday[i].toTime
                .toString()
                .split(".")[1]);
       */
/* if (scheduledInterview.isEmpty) {
          selectedDateAvailability.add(jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.tuesday[i].from +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.tuesday[i].fromTime
                  .toString()
                  .split(".")[1] +
              " - " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.tuesday[i].to +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.tuesday[i].toTime
                  .toString()
                  .split(".")[1]);
        } else {
          for (int j = 0; j < scheduledInterview.length; j++) {
            if (jobsInterviewModel.applicant.email.toString() ==
                scheduledInterview[j].email.toString()) {
              if (scheduledInterview[j].formatedInterviewDate.split(" ")[1] ==
                      jobsInterviewModel.applicant.jobSeekerDetails.availability
                              .tuesday[i].from +
                          " " +
                          jobsInterviewModel.applicant.jobSeekerDetails
                              .availability.tuesday[i].fromTime
                              .toString()
                              .split(".")[1] &&
                  scheduledInterview[j]
                          .formatedInterviewDate
                          .split(" ")[0]
                          .toString() ==
                      DateFormat('MM-dd-y').format(weekDay)) {
              } else {
                selectedDateAvailability.add(jobsInterviewModel.applicant
                        .jobSeekerDetails.availability.tuesday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .tuesday[i].fromTime
                        .toString()
                        .split(".")[1] +
                    " - " +
                    jobsInterviewModel
                        .applicant.jobSeekerDetails.availability.tuesday[i].to +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .tuesday[i].toTime
                        .toString()
                        .split(".")[1]);
              }
            }
          }
        }*/ /*

      }
      if (selectedDateAvailability[0] == "00:00 AM - 00:00 PM") {
        selectedDateAvailability = [];
        selectedSlot = null;
        update();
      } else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    } else if (weekDayName == "Wednesday") {
      for (int i = 0;
          i <
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.wednesday.length;
          i++) {
        selectedDateAvailability.add(jobsInterviewModel.applicant
            .jobSeekerDetails.availability.wednesday[i].from +
            " " +
            jobsInterviewModel.applicant.jobSeekerDetails.availability
                .wednesday[i].fromTime
                .toString()
                .split(".")[1] +
            " - " +
            jobsInterviewModel.applicant.jobSeekerDetails.availability
                .wednesday[i].to +
            " " +
            jobsInterviewModel.applicant.jobSeekerDetails.availability
                .wednesday[i].toTime
                .toString()
                .split(".")[1]);
  */
/*      if (scheduledInterview.isEmpty) {
          selectedDateAvailability.add(jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.wednesday[i].from +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.wednesday[i].fromTime
                  .toString()
                  .split(".")[1] +
              " - " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.wednesday[i].to +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.wednesday[i].toTime
                  .toString()
                  .split(".")[1]);
        } else {
          for (int j = 0; j < scheduledInterview.length; j++) {
            if (jobsInterviewModel.applicant.email.toString() ==
                scheduledInterview[j].email.toString()) {
              if (scheduledInterview[j].formatedInterviewDate.split(" ")[1]+" "+scheduledInterview[j].formatedInterviewDate.split(" ")[2] ==
                      jobsInterviewModel.applicant.jobSeekerDetails.availability
                              .wednesday[i].from +
                          " " +
                          jobsInterviewModel.applicant.jobSeekerDetails
                              .availability.wednesday[i].fromTime
                              .toString()
                              .split(".")[1] &&
                  scheduledInterview[j]
                          .formatedInterviewDate
                          .split(" ")[0]
                          .toString() ==
                      DateFormat('MM-dd-y').format(weekDay)) {

              }else{

                selectedDateAvailability.add(jobsInterviewModel.applicant
                        .jobSeekerDetails.availability.wednesday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .wednesday[i].fromTime
                        .toString()
                        .split(".")[1] +
                    " - " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .wednesday[i].to +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .wednesday[i].toTime
                        .toString()
                        .split(".")[1]);
              }
            }else{
              selectedDateAvailability.add(jobsInterviewModel.applicant
                  .jobSeekerDetails.availability.wednesday[i].from +
                  " " +
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .wednesday[i].fromTime
                      .toString()
                      .split(".")[1] +
                  " - " +
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .wednesday[i].to +
                  " " +
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .wednesday[i].toTime
                      .toString()
                      .split(".")[1]);
            }
          }
        }*/ /*

      }
      if (selectedDateAvailability[0] == "00:00 AM - 00:00 PM") {
        selectedDateAvailability = [];
        selectedSlot = null;
        update();
      } else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    } else if (weekDayName == "Thursday") {

        for (int i = 0;
            i <
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.thursday.length;
            i++) {
          selectedDateAvailability.add(jobsInterviewModel.applicant
              .jobSeekerDetails.availability.thursday[i].from +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .thursday[i].fromTime
                  .toString()
                  .split(".")[1] +
              " - " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.thursday[i]
                  .to +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .thursday[i].toTime
                  .toString()
                  .split(".")[1]);
       */
/*   if(scheduledInterview.isEmpty){
            selectedDateAvailability.add(jobsInterviewModel.applicant
                .jobSeekerDetails.availability.thursday[i].from +
                " " +
                jobsInterviewModel.applicant.jobSeekerDetails.availability
                    .thursday[i].fromTime
                    .toString()
                    .split(".")[1] +
                " - " +
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.thursday[i]
                    .to +
                " " +
                jobsInterviewModel.applicant.jobSeekerDetails.availability
                    .thursday[i].toTime
                    .toString()
                    .split(".")[1]);
          }else{
          for (int j = 0; j < scheduledInterview.length; j++) {
            if (jobsInterviewModel.applicant.email.toString() ==
                scheduledInterview[j].email.toString()) {
              if (scheduledInterview[j].formatedInterviewDate.split(" ")[1]+" "+scheduledInterview[j].formatedInterviewDate.split(" ")[2]  ==
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .thursday[i].from +
                      " " +
                      jobsInterviewModel.applicant.jobSeekerDetails
                          .availability.thursday[i].fromTime
                          .toString()
                          .split(".")[1] &&
                  scheduledInterview[j]
                      .formatedInterviewDate
                      .split(" ")[0]
                      .toString() ==
                      DateFormat('MM-dd-y').format(weekDay)) {

              } else {
                selectedDateAvailability.add(jobsInterviewModel.applicant
                    .jobSeekerDetails.availability.thursday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .thursday[i].fromTime
                        .toString()
                        .split(".")[1] +
                    " - " +
                    jobsInterviewModel
                        .applicant.jobSeekerDetails.availability.thursday[i]
                        .to +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .thursday[i].toTime
                        .toString()
                        .split(".")[1]);
              }

            }else{
              selectedDateAvailability.add(jobsInterviewModel.applicant
                  .jobSeekerDetails.availability.thursday[i].from +
                  " " +
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .thursday[i].fromTime
                      .toString()
                      .split(".")[1] +
                  " - " +
                  jobsInterviewModel
                      .applicant.jobSeekerDetails.availability.thursday[i]
                      .to +
                  " " +
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .thursday[i].toTime
                      .toString()
                      .split(".")[1]);
            }
          }
        }*/ /*

      }

      if (selectedDateAvailability[0] == "00:00 AM - 00:00 PM") {
        selectedDateAvailability = [];
        selectedSlot = null;
        update();
      } else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    } else if (weekDayName == "Friday") {

        for (int i = 0;
            i <
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.friday.length;
            i++) {
          selectedDateAvailability.add(jobsInterviewModel
              .applicant.jobSeekerDetails.availability.friday[i].from +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .friday[i].fromTime
                  .toString()
                  .split(".")[1] +
              " - " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.friday[i]
                  .to +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.friday[i]
                  .toTime
                  .toString()
                  .split(".")[1]);
       */
/*   if(scheduledInterview.isEmpty){
            selectedDateAvailability.add(jobsInterviewModel
                .applicant.jobSeekerDetails.availability.friday[i].from +
                " " +
                jobsInterviewModel.applicant.jobSeekerDetails.availability
                    .friday[i].fromTime
                    .toString()
                    .split(".")[1] +
                " - " +
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.friday[i]
                    .to +
                " " +
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.friday[i]
                    .toTime
                    .toString()
                    .split(".")[1]);
          } else {
            for (int j = 0; j < scheduledInterview.length; j++) {
              if (jobsInterviewModel.applicant.email.toString() ==
                  scheduledInterview[j].email.toString()) {
                if (scheduledInterview[j].formatedInterviewDate.split(" ")[1] ==
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .friday[i].from +
                        " " +
                        jobsInterviewModel.applicant.jobSeekerDetails
                            .availability.friday[i].fromTime
                            .toString()
                            .split(".")[1] &&
                    scheduledInterview[j]
                        .formatedInterviewDate
                        .split(" ")[0]
                        .toString() ==
                        DateFormat('MM-dd-y').format(weekDay)) {
                  selectedDateAvailability.add(jobsInterviewModel
                      .applicant.jobSeekerDetails.availability.friday[i].from +
                      " " +
                      jobsInterviewModel.applicant.jobSeekerDetails.availability
                          .friday[i].fromTime
                          .toString()
                          .split(".")[1] +
                      " - " +
                      jobsInterviewModel
                          .applicant.jobSeekerDetails.availability.friday[i]
                          .to +
                      " " +
                      jobsInterviewModel
                          .applicant.jobSeekerDetails.availability.friday[i]
                          .toTime
                          .toString()
                          .split(".")[1]);
                }
              }
            }
          }*/ /*

      }
      if (selectedDateAvailability[0] == "00:00 AM - 00:00 PM") {
        selectedDateAvailability = [];
        selectedSlot = null;
        update();
      } else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    } else if (weekDayName == "Saturday") {
List<String> datesInInterview=[];


        for (int i = 0;
            i <
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.saturday.length;
            i++) {
          String saturdayTime=DateFormat('MM-dd-y').format(weekDay)+" "+jobsInterviewModel.applicant
              .jobSeekerDetails.availability.saturday[i].from +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .saturday[i].fromTime
                  .toString()
                  .split(".")[1];
          String saturdayTimeTo=DateFormat('MM-dd-y').format(weekDay)+" "+jobsInterviewModel.applicant
              .jobSeekerDetails.availability.saturday[i].to +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .saturday[i].toTime
                  .toString()
                  .split(".")[1];
          print(saturdayTime);
*/
/*          selectedDateAvailability.add(jobsInterviewModel.applicant
              .jobSeekerDetails.availability.saturday[i].from +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .saturday[i].fromTime
                  .toString()
                  .split(".")[1] +
              " - " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.saturday[i]
                  .to +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .saturday[i].toTime
                  .toString()
                  .split(".")[1]);*/ /*

          if(scheduledInterview.isEmpty){
            selectedDateAvailability.add(saturdayTime.split(" ")[1]+" "+saturdayTime.split(" ")[2] + " - " + saturdayTimeTo.split(" ")[1]+" "+saturdayTimeTo.split(" ")[2]);
          }else{

     scheduledInterview.forEach((element) {
      // datesInInterview.add(element.formatedInterviewDate);
       String applicantDateTime=element.formatedInterviewDate;
       String applicantEmail=element.email;
       if(applicantEmail!=jobsInterviewModel.applicant.email){
         print(applicantEmail);
        selectedDateAvailability.add(saturdayTime.split(" ")[1]+" "+saturdayTime.split(" ")[2] + " - " + saturdayTimeTo.split(" ")[1]+" "+saturdayTimeTo.split(" ")[2]);
       }else if(jobsInterviewModel.applicant.email==applicantEmail&&applicantDateTime!=saturdayTime){
         print(applicantEmail);
         selectedDateAvailability.add(saturdayTime.split(" ")[1]+" "+saturdayTime.split(" ")[2] + " - " + saturdayTimeTo.split(" ")[1]+" "+saturdayTimeTo.split(" ")[2]);
       }
     });
*/
/*if(datesInInterview.contains(saturdayTime)&&jobsInterviewModel.applicant.email==applicantEmail){
  selectedDateAvailability.add(saturdayTime.split(" ")[1]+" "+saturdayTime.split(" ")[2] + " - " + saturdayTimeTo.split(" ")[1]+" "+saturdayTimeTo.split(" ")[2]);
}*/ /*


*/
/*          for (int j = 0; j < scheduledInterview.length; j++) {
            String applicantDateTime=scheduledInterview[j].formatedInterviewDate;
           String applicantEmail=scheduledInterview[j].email;
           print(applicantDateTime);
           print(applicantEmail);

           if(jobsInterviewModel.applicant.email!=applicantEmail){
             // BUild array list
             selectedDateAvailability.add(jobsInterviewModel.applicant
                 .jobSeekerDetails.availability.saturday[i].from +
                 " " +
                 jobsInterviewModel.applicant.jobSeekerDetails.availability
                     .saturday[i].fromTime
                     .toString()
                     .split(".")[1] +
                 " - " +
                 jobsInterviewModel
                     .applicant.jobSeekerDetails.availability.saturday[i]
                     .to +
                 " " +
                 jobsInterviewModel.applicant.jobSeekerDetails.availability
                     .saturday[i].toTime
                     .toString()
                     .split(".")[1]);
           }else if(jobsInterviewModel.applicant.email==applicantEmail&&applicantDateTime!=saturdayTime){
             //Build Array List
             selectedDateAvailability.add(jobsInterviewModel.applicant
                 .jobSeekerDetails.availability.saturday[i].from +
                 " " +
                 jobsInterviewModel.applicant.jobSeekerDetails.availability
                     .saturday[i].fromTime
                     .toString()
                     .split(".")[1] +
                 " - " +
                 jobsInterviewModel
                     .applicant.jobSeekerDetails.availability.saturday[i]
                     .to +
                 " " +
                 jobsInterviewModel.applicant.jobSeekerDetails.availability
                     .saturday[i].toTime
                     .toString()
                     .split(".")[1]);
           }*/ /*

            //selectedDateAvailability.toSet().toList();



       */
/*     if (jobsInterviewModel.applicant.email.toString() ==
                scheduledInterview[j].email.toString()
                && scheduledInterview[j].formatedInterviewDate.split(" ")[1] ==
                jobsInterviewModel.applicant.jobSeekerDetails.availability
                    .saturday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails
                        .availability.saturday[i].fromTime
                        .toString()
                        .split(".")[1] &&
                scheduledInterview[j]
                    .formatedInterviewDate
                    .split(" ")[0]
                    .toString() !=
                    DateFormat('MM-dd-y').format(weekDay)) {
              selectedDateAvailability.add(jobsInterviewModel.applicant
                  .jobSeekerDetails.availability.saturday[i].from +
                  " " +
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .saturday[i].fromTime
                      .toString()
                      .split(".")[1] +
                  " - " +
                  jobsInterviewModel
                      .applicant.jobSeekerDetails.availability.saturday[i]
                      .to +
                  " " +
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .saturday[i].toTime
                      .toString()
                      .split(".")[1]);*/ /*



       */
/*       if (scheduledInterview[j].formatedInterviewDate.split(" ")[1] ==
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .saturday[i].from +
                      " " +
                      jobsInterviewModel.applicant.jobSeekerDetails
                          .availability.saturday[i].fromTime
                          .toString()
                          .split(".")[1] &&
                  scheduledInterview[j]
                      .formatedInterviewDate
                      .split(" ")[0]
                      .toString() ==
                      DateFormat('MM-dd-y').format(weekDay)) {
                selectedDateAvailability.add(jobsInterviewModel.applicant
                    .jobSeekerDetails.availability.saturday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .saturday[i].fromTime
                        .toString()
                        .split(".")[1] +
                    " - " +
                    jobsInterviewModel
                        .applicant.jobSeekerDetails.availability.saturday[i]
                        .to +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .saturday[i].toTime
                        .toString()
                        .split(".")[1]);
              }*/ /*

         //   }
        //  }
        }
      }
      if (selectedDateAvailability[0] == "00:00 AM - 00:00 PM") {
        selectedDateAvailability = [];
        selectedSlot = null;
        update();
      } else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(jsonEncode(selectedDateAvailability));
         selectedDateAvailability=selectedDateAvailability.toSet().toList();
          print(selectedSlot);
          update();
        }
      }
    } else {

        for (int i = 0;
            i <
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.sunday.length;
            i++) {
          selectedDateAvailability.add(jobsInterviewModel
              .applicant.jobSeekerDetails.availability.sunday[i].from +
              " " +
              jobsInterviewModel.applicant.jobSeekerDetails.availability
                  .sunday[i].fromTime
                  .toString()
                  .split(".")[1] +
              " - " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.sunday[i].to +
              " " +
              jobsInterviewModel
                  .applicant.jobSeekerDetails.availability.sunday[i]
                  .toTime
                  .toString()
                  .split(".")[1]);
     */
/*     if(scheduledInterview.isEmpty){
            selectedDateAvailability.add(jobsInterviewModel
                .applicant.jobSeekerDetails.availability.sunday[i].from +
                " " +
                jobsInterviewModel.applicant.jobSeekerDetails.availability
                    .sunday[i].fromTime
                    .toString()
                    .split(".")[1] +
                " - " +
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.sunday[i].to +
                " " +
                jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.sunday[i]
                    .toTime
                    .toString()
                    .split(".")[1]);
          }else{
          for (int j = 0; j < scheduledInterview.length; j++) {
            if (jobsInterviewModel.applicant.email.toString() ==
                scheduledInterview[j].email.toString()) {
              if (scheduledInterview[j].formatedInterviewDate.split(" ")[1] ==
                  jobsInterviewModel.applicant.jobSeekerDetails.availability
                      .sunday[i].from +
                      " " +
                      jobsInterviewModel.applicant.jobSeekerDetails
                          .availability.sunday[i].fromTime
                          .toString()
                          .split(".")[1] &&
                  scheduledInterview[j]
                      .formatedInterviewDate
                      .split(" ")[0]
                      .toString() ==
                      DateFormat('MM-dd-y').format(weekDay)) {
                selectedDateAvailability.add(jobsInterviewModel
                    .applicant.jobSeekerDetails.availability.sunday[i].from +
                    " " +
                    jobsInterviewModel.applicant.jobSeekerDetails.availability
                        .sunday[i].fromTime
                        .toString()
                        .split(".")[1] +
                    " - " +
                    jobsInterviewModel
                        .applicant.jobSeekerDetails.availability.sunday[i].to +
                    " " +
                    jobsInterviewModel
                        .applicant.jobSeekerDetails.availability.sunday[i]
                        .toTime
                        .toString()
                        .split(".")[1]);
              }
            }
          }
        }*/ /*

      }
      if (selectedDateAvailability[0] == "00:00 AM - 00:00 PM") {
        selectedDateAvailability = [];
        selectedSlot = null;
        update();
      } else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    }
    return weekDayName;
  }
*/

  Future<List<ScheduleInterviews>> getIntervieweeList(token) async {
    isLoading = true;
    scheduledInterview = [];
    responseData = [];
    update();
    Response? response = await BaseApi.get(
        url: 'jobs/applicant/schedule', params: {"api_token": token});
    if (response!.statusCode == 200) {
      if (response.data["data"] != null) {
        response.data["data"].forEach((ele) {
          responseData.add(ScheduleInterviews.fromJson(ele));
        });

        scheduledInterview = responseData;
        scheduledInterview.forEach((element) {});
        isLoading = false;
        update();
      }
      //   Get.find<HomeMasterController>().getEmployerMessageData(token);
      //  update();
    }
    return scheduledInterview;
  }

  Future<void> scheduleInterview(
      BuildContext context, Map<String, dynamic> body,
      {Map<String, dynamic>? param}) async {
    print(body);
    isLoading = true;
    update();
    Dio dio = new Dio();
    Response response = await dio.post(
        "${BaseApi.domainName}api/employer/schedule",
        queryParameters: {'api_token': token},
        options: Options(headers: {'Accept': 'application/json'}),
        data: body);
    if (response.statusCode == 200) {
      if (response.data["message"] == "Schedule Already Exits!") {
        print(response.data);
        showToast(msg: "Schedule Already Exists");
      } else {
        print(response.data);
        Future.delayed(Duration(seconds: 2)).then((value) {
          showToast(msg: 'Interview Scheduled Successfully');
        });
      }
      interviewDate = null;
      selectedSlot = null;
      updatedSlot = [];
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  Future<void> rejectApplicant(BuildContext context, jobId,
      {Map<String, dynamic>? param}) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    Response? response = await BaseApi.post(
        url: 'jobs/applicant/reject',
        params: {"api_token": token},
        body: param);
    if (response!.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Applicant Rejected Successfully');
      });
      await userJobService.getJobApplicant(token, jobId);
      update();
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
      responseBody = response.data;
    }
  }

  Future<void> viewSchedule(BuildContext context,
      {Map<String, dynamic>? param}) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    Response? response = await BaseApi.get(
      url: 'jobs/applicant/interview-schedule',
      params: param,
    );
    if (response!.statusCode == 200) {
      if (response.data["data"] != null) {
        viewInterviewModel = ViewInterviewModel.fromJson(response.data["data"]);
        update();
        showSelectionDialog(context, viewInterviewModel);
      }
      update();
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
      responseBody = response.data;
    }
  }

  Future showSelectionDialog(BuildContext context, ViewInterviewModel? view) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
              // title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SubText(
                            "Video Interview",
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SubText(
                            "${view!.applicant!.firstName} ${view.applicant!.lastName}",
                            fontWeight: FontWeight.bold,
                            size: 18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SubText(
                            "Interview Schedule for",
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.grey, size: 14),
                                SubText("${view.interviewDate.toString().split("T")[0]}",
                                    color: Colors.grey, size: 14),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: 14,
                                ),
                                SubText("${view.interviewDate.toString().split("T")[1]}",
                                    color: Colors.grey, size: 14),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(left: width(context)/8),
                          //   child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Icon(Icons.access_time,color: Colors.grey,size: 14,),
                          //       SubText("${view.interviewDate.split("T")[1]}",color: Colors.grey,size: 14),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: MaterialButton(
                        //     color: Colors.grey,
                        //     child: Text(
                        //       "Cancel",
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.pop(context);
                        //     },
                        //   ),
                        // ),
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
                              Get.back();
                              // await deleteJob(context, postId);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
