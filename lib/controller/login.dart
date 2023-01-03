import 'dart:async';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/plans.dart';
import 'package:careAsOne/services/subscription.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final subScriptionService = Get.find<SubscriptionService>();
  List<PlanModel>? plansList;
  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool passwordVisible = false;

  void login(BuildContext context, {required Map<String, dynamic> body}) async {
    isLoading = true;
    update();
    Response? response = await BaseApi.post(url: 'login', params: body);

    if (response!.statusCode == 200) {
      if (response.data['data'] != null) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          isLoading = false;
          update();
          showToast(msg: 'Login Successful');
          GetStorage storage = GetStorage();
          storage.write("authToken", response.data["data"]["api_token"]);
          storage.write("userType", response.data["data"]["user_type"]);
          storage.write("userId", response.data["data"]["id"]);
          storage.write("deviceToken", response.data["data"]["device_token"]);
        storage.write("verifiedAt", response.data["data"]["email_verified_at"]);
          if(response.data["data"]["formQuestion"]==null){
            storage.write("preQuestion", "null");
          }else{
            storage.write("preQuestion", "filled");
          }

          if (response.data["data"]["user_type"] == "employer") {
if(response.data["data"]["email_verified_at"]!=null){
  Get.offAllNamed(AppRoute.empHomeMasterRoute);
}else{
  Get.offAllNamed(AppRoute.verifyEmailPage);
}
          } else {
            if(response.data["data"]["email_verified_at"]==null){
              Get.offAllNamed(AppRoute.verifyEmailPage);
            }else if(response.data['formQuestion']==null){

              Get.offAllNamed(AppRoute.preQuestionnaireRoute);
            }else{
              storage.write("preQuestion", "filled");
              Get.offAllNamed(AppRoute.homeMasterRoute);
            }

          }

        });
      }
    } else if (response.data != null) {
      isLoading = false;
      update();
      print(response.data);
      showToast(msg: 'Invalid Username or password');
    }
  }
}
