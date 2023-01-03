import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
class JobSeekerController extends GetxController {
  var token;
  var gender;
  bool isLoading = false;
  bool genderType = false;

  void submit(BuildContext context, {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    Response? response =
        await BaseApi.post(url: "job-seeker/pre-questions", params: params!);
    responseBody = response!.data;
    if (response.statusCode == 200) {
      if (responseBody != null) {
        Get.toNamed(AppRoute.homeMasterRoute);
      }
    } else {
      showToast(msg: 'Something went wrong');
    }
  }
}
