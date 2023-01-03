import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/dashboard.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/recent_applicants.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class EmpHomeController extends GetxController {
  var token;
  bool isLoading = true;
  EmpProfileModel? empProfileModel;
  EmpDashboardModel? empDashboardModel;
  List<RecentApplicants> recentApplicants = [];
  List<RecentApplicants> recentApplications = [];
  final scaffoldKeyEmployer = new GlobalKey<ScaffoldState>();
  final authService = Get.find<AuthService>();
  final myProfile = Get.find<ProfileService>();
  final homeMaster = Get.find<HomeMasterController>();
  GetStorage storage = GetStorage();

  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;
    update();
    empProfileModel = await myProfile.getUserData(token);
    await getDashboardData(token);
    isLoading = false;
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    await getDashboardData(token);
    update();
    super.onReady();
  }

  Future<EmpDashboardModel> getDashboardData(token) async {
    Map<String, dynamic> responseBody;
    try {
      Response? response = await BaseApi.get(
          url: 'dashboard-employer', params: {"api_token": token});
      responseBody = response!.data;

      if (response.statusCode == 200) {
        if (responseBody != null) {
          empDashboardModel = EmpDashboardModel.fromJson(responseBody["data"]);
        }
      } else if (responseBody != null) {
        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        //showToast(msg: "ERROR");
      }
      if (e.response?.statusCode == 401) {
        showToast(msg: "Session Expired Login Again.");
        authService.logOut();
      }
    }
    return empDashboardModel!;
  }
}
