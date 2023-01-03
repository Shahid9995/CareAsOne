import 'dart:async';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

class SignUpController extends GetxController {
  bool isLoading = false;
  bool isCheck = false;
  bool passwordVisible = false;
  bool confirmPassVisible = false;
  bool seekerVisible = false;
  bool confirmSeekerVisible = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void register(BuildContext context, {required Map<String, dynamic> params}) async {
    isLoading = true;
    update();
    CircularLoader().showAlert(context);
    Map<String, dynamic> responseBody;
    try{
    Response? response = await BaseApi.post(url: 'registerapi', params: params);
    if (response!.statusCode == 200) {
      // DialogLoader.showLoader(context);
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Registered Successfully\nCheck your email to verify.');
        email.text="";
        password.text="";
        firstName.text="";
        lastName.text="";
        phone.text="";
        repeatPassword.text="";
        Get.back();
        Get.offNamed(AppRoute.loginRoute);
      });
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
      responseBody = response.data;
      if (responseBody['errors']["email"][0] ==
          "The email has already been taken.") {
        showToast(msg: 'Email Already Exists');
        Get.back();
      } else {
        showToast(msg: '${responseBody['message']}');
        Get.back();
      }
    }
    }catch(e){
      showToast(msg: 'Something went wrong');
      Get.back();
      isLoading = false;
      update();
    }
  }
}
