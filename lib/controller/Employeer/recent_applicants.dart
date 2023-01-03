import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/recent_applicants.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class RecentApplicantsController extends GetxController {
  bool isLoading = false;
  List<RecentApplicants>? recentApplicants;
  List<RecentApplicants>? applications;
  var token;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  GetStorage getStorage = new GetStorage();
  final myProfile = Get.find<ProfileService>();
  EmpProfileModel? empProfileModel;

  @override
  void onInit() async {
    token = getStorage.read("authToken");
    applications = [];
    empProfileModel = await myProfile.getUserData(token);
    // TODO: implement onInit
    recentApplicants = await getRecentApplicants(token);

    super.onInit();
  }

  Future<List<RecentApplicants>> getRecentApplicants(token) async {
    isLoading = true;
    update();
    recentApplicants = [];
    Dio dio = new Dio();
    Response response = await dio.get(
        "${BaseApi.domainName}api/employer/job-applications/recentApplicant",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "applicatioln/json"}));
    if (response.statusCode == 200) {
      response.data['data'].forEach((e) {
        recentApplicants!.add(RecentApplicants.fromJson(e));
      });
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
    return recentApplicants!;
  }
}
