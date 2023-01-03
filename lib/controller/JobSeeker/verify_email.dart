import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart'hide Response;
import 'package:get_storage/get_storage.dart';

class VerifyEmailController extends GetxController {
  final authService = Get.find<AuthService>();
  EmpProfileModel? empProfileModel;
  final myProfile=Get.find<ProfileService>();
  var token;
  GetStorage storage=new GetStorage();
var email;
  @override
  void onInit() async{
    token=storage.read("authToken");
    empProfileModel=await myProfile.getUserData(token);
    super.onInit();
  }
  resendVerification(BuildContext context)async{
    CircularLoader().showAlert(context);
    Dio dio=new Dio();
    try{
    Response response=await dio.post("${BaseApi.domainName}api/resend-token",queryParameters: {'email':empProfileModel!.email});
    if(response.statusCode==200){
      Get.back();
      showToast(msg: "A Verification email is sent.");
    }else{
      Get.back();
      showToast(msg: "Something went wrong");
    }
  }
  catch(e){
      Get.back();
      showToast(msg: "Something went wrong");
  }
  }
}
