import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/all_job_applicants.dart';
import 'package:careAsOne/model/jobseeker_slots.dart';
import 'package:careAsOne/model/schedule_interview.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/user_job.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
    as DatePicker;
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../circular_loader/circular_loader.dart';

class VideoInterviewController extends GetxController {
  String? dropdownValue;
  String? dropdownValue2;
  bool isLoading = true;
  List<String> selectedDateAvailability = [];
  String? selectedSlot;
  List<String> interviewTypeList=["Office","Video"];
  String selectedInterviewType="Office";
  DateTime? interviewDate;
  List<JobseekerAvailableSlots> jobseekerSlots=[];
  List<String> updatedSlot=[];
  DateTime? startDateRange;
  DateTime? endDateRange;
  String? weekDayName;
  List<ScheduleInterviews> scheduledInterview=[];
  List<ScheduleInterviews> responseData=[];
  List<ScheduleInterviews> searchedList=[];
  String interViewName="";
  List<AllApplicantsInterview>? allApplicantInterview;

  var token;
  var applicantId;
  var id;
  var list;
  var secondList;
  final storage = GetStorage();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  final homeMaster = Get.find<HomeMasterController>();
  final userJobService = Get.find<UserJobService>();
  final myProfile = Get.find<ProfileService>();

  @override
  void onInit() async {
    token = storage.read("authToken");
    await userJobService.getUserJob(token);
    update();
    await getIntervieweeList(token);

    allApplicantInterview = await userJobService.getAllJobsApplicants(token);
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    await userJobService.getUserJob(token);
    update();
    super.onReady();
  }
  getRelativeAvailability(String applicantId,String jobId)async{
    await userJobService.getJobApplicant(token,jobId);
    for(int i=0; i<userJobService.jobsApplicantModel.length;i++){
      if(applicantId.toString()==userJobService.jobsApplicantModel[i].applicantId.toString()) {
        startDateRange=DateFormat("MM-dd-y").parse(userJobService.jobsApplicantModel[i].startDateRange!);
        endDateRange=DateFormat("MM-dd-y").parse(userJobService.jobsApplicantModel[i].endDateRange!);
        print(userJobService.jobsApplicantModel[i].applicant!.jobSeekerDetails!.availability);

      }else{

      }
      interviewDate=startDateRange;
      update();
    }
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
      await getAvailableSlots(applicantId,DateFormat("MM-dd-y").format(interviewDate!));
      //  getWeekDayFromDate(interviewDate);

      // update();
    }
  }
  getAvailableSlots(applicantId,String date) async {
    jobseekerSlots=[];
    updatedSlot=[];
    selectedSlot=null;
    var body={
      "date":date,
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
          BaseApi.domainName + "api/employer/available-slot/show/new/${applicantId}",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}),data: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseBody = response.data;
        print(responseBody);
        responseBody.forEach((e){
          jobseekerSlots.add(JobseekerAvailableSlots.fromJson(e));
        });
        print(jobseekerSlots);
        jobseekerSlots.forEach((element) {
          updatedSlot.add(element.time!.startEnd.toString());
          selectedSlot=updatedSlot[0];
        });
        update();
      } else {

      }
    } catch (e) {
      if (e is DioError) {

        print(e.response);
        print(e.error);
      }
    }
  }

  Future<void> scheduleInterviewNew(
      BuildContext context, Map<String, dynamic> body,
      {Map<String, dynamic>? param}) async {
    CircularLoader().showAlert(context);
    print(body);
    /*isLoading = true;
    update();*/
    try {
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

       await getIntervieweeList(token);
        Get.back();
        update();
        /*  isLoading = false;
      update();*/
      } else {
        /*   isLoading = false;
      update();*/
      }
    }catch(e){
      if(e is DioError){
        print(e.response);
        print(e.error);
      }
    }
  }

  Future<void> scheduleInterview(
      BuildContext context, Map<String, dynamic> body,
      {Map<String, dynamic>? param}) async {
    isLoading = true;
    update();
    Dio dio = new Dio();
    Response response = await dio.post(
        "${BaseApi.domainName}api/jobs/applicant/schedule-interview",
        queryParameters: {'api_token': token},
        options: Options(headers: {'Accept': 'application/json'}),
        data: body);
    if (response.statusCode == 200) {
      if(response.data["message"]=="Sehcdule Already Exits!"){
        showToast(msg: "Schedule Already Exists");
      }else{
        Future.delayed(Duration(seconds: 2)).then((value) {
          showToast(msg: 'Interview Scheduled Successfully');
        });
      }

      dropdownValue = "";
      dropdownValue2 = "";
      time.text = "";
      date.text = "";
      await getIntervieweeList(token);
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
    }
  }

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
        scheduledInterview.forEach((element) {
        });
        isLoading = false;
        update();
      }
   //   Get.find<HomeMasterController>().getEmployerMessageData(token);
    //  update();
    }
    return scheduledInterview;
  }
/*  getWeekDayFromDate(DateTime weekDay) {
    selectedDateAvailability=[];
    selectedSlot=null;
    update();
    weekDayName = DateFormat('EEEE').format(weekDay);
    print(weekDayName);
    if (weekDayName == "Monday") {
      for (int i = 0;
      i <
          jobsInterviewModel
              .applicant.jobSeekerDetails.availability.monday.length;
      i++) {
        selectedDateAvailability.add(jobsInterviewModel
            .applicant.jobSeekerDetails.availability.monday[i].from +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.monday[i].fromTime.toString().split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.monday[i].to +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.monday[i].toTime.toString().split(".")[1]);
      }
      if(selectedDateAvailability[0]=="00:00 AM - 00:00 PM"){
        selectedDateAvailability=[];
        selectedSlot=null;
        update();
      }else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    }else if (weekDayName == "Tuesday") {
      for (int i = 0;
      i <
          jobsInterviewModel
              .applicant.jobSeekerDetails.availability.tuesday.length;
      i++) {
        selectedDateAvailability.add(jobsInterviewModel
            .applicant.jobSeekerDetails.availability.tuesday[i].from +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.tuesday[i].fromTime.toString().split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.tuesday[i].to +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.tuesday[i].toTime.toString().split(".")[1]);
      }
      if(selectedDateAvailability[0]=="00:00 AM - 00:00 PM"){
        selectedDateAvailability=[];
        selectedSlot=null;
        update();
      }else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    }else if (weekDayName == "Wednesday") {
      for (int i = 0;
      i <
          jobsInterviewModel
              .applicant.jobSeekerDetails.availability.wednesday.length;
      i++) {
        selectedDateAvailability.add(jobsInterviewModel
            .applicant.jobSeekerDetails.availability.wednesday[i].from +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.wednesday[i].fromTime.toString().split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.wednesday[i].to +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.wednesday[i].toTime.toString().split(".")[1]);
      }
      if(selectedDateAvailability[0]=="00:00 AM - 00:00 PM"){
        selectedDateAvailability=[];
        selectedSlot=null;
        update();
      }else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    }else if (weekDayName == "Thursday") {
      for (int i = 0;
      i <
          jobsInterviewModel
              .applicant.jobSeekerDetails.availability.thursday.length;
      i++) {
        selectedDateAvailability.add(jobsInterviewModel
            .applicant.jobSeekerDetails.availability.thursday[i].from +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.thursday[i].fromTime.toString().split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.thursday[i].to +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.thursday[i].toTime.toString().split(".")[1]);
      }
      if(selectedDateAvailability[0]=="00:00 AM - 00:00 PM"){
        selectedDateAvailability=[];
        selectedSlot=null;
        update();
      }else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    }else if (weekDayName == "Friday") {
      for (int i = 0;
      i <
          jobsInterviewModel
              .applicant.jobSeekerDetails.availability.friday.length;
      i++) {
        selectedDateAvailability.add(jobsInterviewModel
            .applicant.jobSeekerDetails.availability.friday[i].from +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.friday[i].fromTime.toString().split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.friday[i].to +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.friday[i].toTime.toString().split(".")[1]);
      }
      if(selectedDateAvailability[0]=="00:00 AM - 00:00 PM"){
        selectedDateAvailability=[];
        selectedSlot=null;
        update();
      }else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    } else if (weekDayName == "Saturday") {
      for (int i = 0;
      i <
          jobsInterviewModel
              .applicant.jobSeekerDetails.availability.saturday.length;
      i++) {
        selectedDateAvailability.add(jobsInterviewModel
            .applicant.jobSeekerDetails.availability.saturday[i].from +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.saturday[i].fromTime.toString().split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.saturday[i].to +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.saturday[i].toTime.toString().split(".")[1]);
      }
      if(selectedDateAvailability[0]=="00:00 AM - 00:00 PM"){
        selectedDateAvailability=[];
        selectedSlot=null;
        update();
      }else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    }else {
      for (int i = 0;
      i <
          jobsInterviewModel
              .applicant.jobSeekerDetails.availability.sunday.length;
      i++) {
        selectedDateAvailability.add(jobsInterviewModel
            .applicant.jobSeekerDetails.availability.sunday[i].from +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.sunday[i].fromTime.toString().split(".")[1] +
            " - " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.sunday[i].to +
            " " +
            jobsInterviewModel
                .applicant.jobSeekerDetails.availability.sunday[i].toTime.toString().split(".")[1]);
      }
      if(selectedDateAvailability[0]=="00:00 AM - 00:00 PM"){
        selectedDateAvailability=[];
        selectedSlot=null;
        update();
      }else {
        if (selectedSlot == null) {
          selectedSlot = selectedDateAvailability[0];
          print(selectedSlot);
          update();
        }
      }
    }
    return weekDayName;
  }*/
  datePicker(BuildContext context) {
    DatePicker.DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2090, 6, 7), onChanged: (value) {
      String nee = value.toString();
      // setState(() {
      date.text = nee.split(" ")[0];
      time.text = nee.split(" ")[1].split(":")[0] +
          ":" +
          nee.split(" ")[1].split(":")[1];
      final dateTime = DateTime.parse(nee);
      final format = DateFormat('yyyy-MM-dd');
      final clockString = format.format(dateTime);

      date.text = clockString;
      update();
    }, onConfirm: (value) {
    }, currentTime: DateTime.now(), locale: DatePicker.LocaleType.en);
  }
}
