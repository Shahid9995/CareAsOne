import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class PreQuestion extends GetxController {
  var token;
  bool isLoading = false;
  SeekerProfileModel? applicant;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final myProfile = Get.find<ProfileService>();
  final authService = Get.find<AuthService>();
  GetStorage storage = GetStorage();

  void submit(BuildContext context, {Map<String, dynamic>? body}) async {
    isLoading = true;
    update();
    try {
      Response? response = await BaseApi.post(
          url: 'job-seeker/pre-questions',
          params: {"api_token": token},
          body: body);
      if (response!.statusCode == 200) {
        if (response.data['data'] != null) {
          // profile = ProfileModel.fromJson(responseBody['data']);
          // DialogLoader.showLoader(context);
          showToast(msg: "Saved");
          storage.write("preQuestion", "filled");
          Get.offAndToNamed(AppRoute.homeMasterRoute);
        }
      }
    } on DioError  catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
  }

  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;
    update();
    //applicant = await myProfile.getSeekerData(token);

    isLoading = false;
    update();

    update();
    super.onInit();
  }
  @override
  void onClose() {

    super.onClose();
  }
}
