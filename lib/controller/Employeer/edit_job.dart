import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/jobs.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/user_job.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'all_applicants.dart';
import 'home_master.dart';

class EditJobController extends GetxController {
  JobsModel? jobsModel;
  List<String> positionModelList = [];
  List<String> experienceModelList = [];
  List<String> tagsList = [];
  List<KeywordClass> mapTagsList = [];
  int active = 0;
  int status = 1;
  int jobType = 1;
  var token;
  final storage = GetStorage();
  bool isLoading = false;
  var file;
  File? image;
  final picker = ImagePicker();
  String schedule = "";
  String position = "";
  String experience = "";
  EmpProfileModel? empProfileModel;
  List<String>? scheduleList = [
    "Full Time",
    "Part Time",
    "Full Time & Part Time"
  ];

  final homeMaster = Get.find<HomeMasterController>();
  final userJobService = Get.find<UserJobService>();
  final authService = Get.find<AuthService>();
  final myProfile = Get.find<ProfileService>();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController description = TextEditingController();

  //TextEditingController keywords=TextEditingController();

  @override
  void onInit() async {
    token = storage.read("authToken");

    await getJobPostion(token);
    await getJobExperience(token);
    empProfileModel = await myProfile.getUserData(token);

    if (Get.arguments != null) {
      if (Get.arguments["postModel"] != null) {
        jobsModel = Get.arguments["postModel"];


        jobTitle.text = jobsModel!.title.toString();
        city.text = jobsModel!.city.toString();
        state.text = jobsModel!.state.toString();
        zipCode.text = jobsModel!.zipCode.toString();
        salary.text = jobsModel!.salary.toString();
        description.text = jobsModel!.description.toString();
        schedule = jobsModel!.schedule.toString();
        position = jobsModel!.position.toString();
        experience = jobsModel!.experience.toString();

        tagsList = jobsModel!.keywords as List<String>;
        update();
        if (jobsModel!.jobType == "hourly") {
          status = 1;
        } else {
          status = 2;
        }
        if (jobsModel!.status == "enable") {
          jobType = 1;
        } else {
          jobType = 2;
        }
      }
      update();
    }

    super.onInit();
  }

   getJobPostion(token) async {
    isLoading = true;
    positionModelList = [];
    update();
    Map<String, dynamic> responseBody;
    try {
      Response? response = await BaseApi.get(
          url: 'positions-list', params: {"api_token": token});
      responseBody = response!.data;

      if (response.statusCode == 200) {
        if (responseBody["data"] != null) {
          responseBody["data"].forEach((ele) {
            positionModelList.add(ele["name"]);
            update();
          });
          isLoading = false;
          update();
        }
      } else if (responseBody != null) {
      } else {
        return positionModelList;
      }
      return positionModelList;
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        return positionModelList;
        showToast(msg: "Session Expired Login Again.");
        authService.logOut();
      }
    }
  }

  Future<List<String>> getJobExperience(token) async {
    isLoading = true;
    experienceModelList = [];
    update();
    Map<String, dynamic> responseBody;
    Response? response = await BaseApi.get(
        url: 'experiences-list', params: {"api_token": token});
    responseBody = response!.data;
    if (response.statusCode == 200) {
      if (responseBody["data"] != null) {
        responseBody["data"].forEach((ele) {
          experienceModelList.add(ele["name"]);
          update();
        });
        isLoading = false;
        update();
      }
    } else if (responseBody != null) {
    } else {}
    return experienceModelList;
  }

  Future<void> postJob(BuildContext context,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    Dio dio = new Dio();
    Response response = await dio.post("${BaseApi.domainName}api/jobs/store",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: params);
    if (response.statusCode == 200) {
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
      showToast(msg: "Something Went Wrong");
    }
  }

  Future<void> editJobUpdate(BuildContext context,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    Response? response = await BaseApi.post(
        url: 'jobs/update', body: params, params: {"api_token": token});
    if (response!.statusCode == 200) {
      // DialogLoader.showLoader(context);
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Job Updated Successfully');
      });
      await userJobService.getUserJob(token);
      Get.find<AllApplicantsController>().update();
      Get.back();
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
      responseBody = response.data;
    }
  }

  Future openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    } else {
    }
  }
}
