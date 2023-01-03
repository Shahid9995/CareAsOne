import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/job_applicant.dart';
import 'package:careAsOne/model/jobs.dart';
import 'package:careAsOne/model/view_interview.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/user_job.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class JobApplicantsController extends GetxController {
  JobsModel? jobsModel;
  ViewInterviewModel? viewInterviewModel;
  List<JobApplicantModel>? jobsApplicantModel;
  List<JobApplicantModel> responseBody = [];
  final storage = GetStorage();
  var token;
  bool isLoading = false;
  int remainPostJob = 0;
  var selectExp = "";
  var selectStatus = "";
  var filterStatus = "";
  var filterExp = "";
  EmpProfileModel? empProfileModel;
  final myProfile = Get.find<ProfileService>();

  final userJobService = Get.find<UserJobService>();

  List<String> yearExperience = [
    "Select Experience",
    "0 years",
    "1 year",
    "2 years",
    "3 years",
    "4 years",
    "5 years",
    "6 years",
    "7 years",
    "8 years",
    "9 years",
    "10 years",
    "11 years",
    "12 years",
    "13 years",
    "14 years",
    "15 years",
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
    isLoading = true;
    update();
    if (Get.arguments != null) {
      jobsModel = Get.arguments["jobModel"];

      jobsApplicantModel =
          await userJobService.getJobApplicant(token, jobsModel!.id);
      isLoading = false;
      update();
    }
    empProfileModel = await myProfile.getUserData(token);
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    jobsApplicantModel =
        await userJobService.getJobApplicant(token, jobsModel!.id);

    super.onReady();
  }

  Future<void> hireApplicant(BuildContext context, jobId,
      {Map<String, dynamic>? param}) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    Dio dio = new Dio();
    Response response = await dio.post(
        "${BaseApi.domainName}api/jobs/applicant/hire",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: param);
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Applicant Hired Successfully');
      });

      jobsApplicantModel = await userJobService.getJobApplicant(token, jobsModel!.id);
      update();
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
    Dio dio = new Dio();

    Response response = await dio.post(
        "${BaseApi.domainName}api/jobs/applicant/reject",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: param);
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Applicant Rejected Successfully');
      });

      jobsApplicantModel = await userJobService.getJobApplicant(token, jobsModel!.id);
      isLoading = false;
      update();
    } else {
      showToast(msg:"Something went wrong");
      isLoading = false;
      update();
    }
  }

  Future<void> viewSchedule(BuildContext context,
      {Map<String, dynamic>? param}) async {
    print(token);
    isLoading = true;
    update();
    try {
      Map<String, dynamic> responseBody;
      Response? response = await BaseApi.get(
        url: 'jobs/applicant/interview-schedule',
        params: param,
      );
      if (response!.statusCode == 200) {
        if (response.data["data"] != null) {
          viewInterviewModel =
              ViewInterviewModel.fromJson(response.data["data"]);
          update();
          showSelectionDialog(context, viewInterviewModel);
        } else {
          showSelectionDialog(context, null);

          isLoading = false;
          update();
        }


        isLoading = false;
        update();
      } else {
        responseBody = response.data;
      }
    } on DioError  catch (ex) {
      if(ex.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
        showToast(msg: "ERROR");
      }
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
                child: view!=null?ListBody(
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
                            "${view.applicant!.firstName} ${view.applicant!.lastName}",
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
                                SubText("${view.interviewDate.toString().split("T")[1].split("-")[0]}",
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
                ):Center(child:Column(children:[
                  SubText("Video Interview",size: 30,color: AppColors.green,),
                  SizedBox(height: 10,),
                  SubText("No Interview is Scheduled"),
              ])),
              ));
        });
  }
}
