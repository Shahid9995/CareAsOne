import 'dart:convert';
import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/Employeer/all_applicants.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
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

class PostJobController extends GetxController {
  // String dropdownValue = 'NEWEST';
  JobsModel? jobsModel;
  List<JobsModel> allJobs = [];
  List<String> positionModelList = [];
  List<String> experienceModelList = [];
List<String> citySeparator=const [','];
List<String> keywordSeparator=const [" ",','];
  List<String> servicetagsList = [];
  List<String> cityList = [];
  var cityEmpList = [];

  List<String> zipsList = [];
  String? dropdownValue;

  List<String> decodedList = [];
  List<KeywordClass> mapTagsList = [];
  var managedTags = [];
  var encodedCities = [];
  var managedZipCode = [];

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
  List<String> scheduleList = [
    "Full Time",
    "Part Time",
    "Full Time & Part Time"
  ];

  final homeMaster = Get.find<HomeMasterController>();
  final userJobService = Get.find<UserJobService>();
  final authService = Get.find<AuthService>();
  final myProfile = Get.find<ProfileService>();
  List<String> finalList = [];
  List<String> finalZipList = [];
  List<String> finalTagList = [];
  bool isKeyTag = false;
  bool isCityTag = false;
  bool isZipTag = false;
  TextEditingController jobTitle = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController description = TextEditingController();
  String? isUpdate;
  List<JobsModel>? model;

  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;
    update();
    if (Get.arguments != null) {
      if (Get.arguments["postModel"] != null) {
        model = await getAllJobs(token);

        jobsModel = Get.arguments["postModel"];
        managedTags = [];
        encodedCities = [];

        managedZipCode = [];
        empProfileModel = await myProfile.getUserData(token);
        jobTitle.text = jobsModel!.title.toString();
        city.text = jobsModel!.city.toString();
        dropdownValue = jobsModel!.state.toString();
        zipCode.text = jobsModel!.zipCode.toString();
        salary.text = jobsModel!.salary.toString();
        description.text = jobsModel!.description.toString();
        schedule = jobsModel!.schedule.toString();
        position = jobsModel!.position.toString();
        experience = jobsModel!.experience.toString();
        await getJobExperience(token);
        await getJobPostion(token);
        if (jobsModel!.jobType == "hourly") {
          jobType = 1;
        } else {
          jobType = 2;
        }
        if (jobsModel!.status == "enable") {
          status = 1;
        } else {
          status = 2;
        }
        isLoading = false;
        update();
      }
    } else {
      empProfileModel = await myProfile.getUserData(token);
      await getJobExperience(token);
      await getJobPostion(token);
    }

    isLoading = false;
    update();
    super.onInit();
  }

 getAllJobs(token) async {
    Dio dio = new Dio();
    Response response = await dio.get("${BaseApi.domainName}api/jobs",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}));
    if (response.statusCode == 200) {
      response.data['data'].forEach((e) {
        allJobs.add(JobsModel.fromJson(e));
      });
      List<String> newList = [];
      List<String> tempZipCodes = [];
      List<String> tempTags = [];
      var citiesGet = json.decode(response.data["data"][0]["city"]);
      var zipGet = json.decode(response.data["data"][0]["zip_code"]);
      var tagGet = json.decode(response.data["data"][0]["keywords"]);
      for (int i = 0; i < citiesGet.length; i++) {
        newList.add(citiesGet[i]['value']);
      }
      for (int i = 0; i < zipGet.length; i++) {
        tempZipCodes.add(zipGet[i]['value']);
      }
      for (int i = 0; i < tagGet.length; i++) {
        tempTags.add(tagGet[i]['value']);
      }
      finalList = newList;
      finalTagList = tempTags;
      finalZipList = tempZipCodes;
    }
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
      } else {}
      return positionModelList;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
      if (e.response!.statusCode == 401) {
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
    CircularLoader().showAlert(context);
    // isLoading = true;
    // update();
    Dio dio = new Dio();
    Response response = await dio.post("${BaseApi.domainName}api/jobs/store",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: params);
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
     //   Get.back();
      });
      showToast(msg: "Job Posted");

      await userJobService.getUserJob(token);
      update();
      Get.find<AllApplicantsController>().update();
      Get.back();
      Get.back();
      // Get.back();
      // isLoading = false;
      // update();
    } else {
      // Get.back();
      // isLoading = false;
      // update();
      showToast(msg: "Something Went Wrong");
    }
  }

  Future<void> postJobUpdate(BuildContext context,
      {Map<String, dynamic>? params}) async {
    CircularLoader().showAlert(context);
    // isLoading = true;
    // update();
    Dio dio = new Dio();
    Response response = await dio.post('${BaseApi.domainName}api/jobs/update',
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: params);
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Job Updated Successfully');
       // Get.back();
      });
     await userJobService.getUserJob(token);
     update();
      Get.find<AllApplicantsController>().update();
      Get.back();
      Get.back();
     // Get.offAll(()=>AllApplicants());
     //  isLoading = false;
     //  update();
    }
  }

  Future openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    } else {
      print('No image selected.');
    }
  }
}
