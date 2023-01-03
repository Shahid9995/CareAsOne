import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/view/auth_screens/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart'hide Response;

class SetNewPasswordController extends GetxController{
  var data=Get.arguments;
  bool visibilityNewPass=false;
  bool visibilityConfirmPass=false;
  TextEditingController newPassController=TextEditingController();
  TextEditingController confirmPassController=TextEditingController();
  GlobalKey<FormBuilderState> setPassKey = GlobalKey<FormBuilderState>();
  updatePassword()async{
    Dio dio=new Dio();
    try {
      Response response = await dio.post(
          "${BaseApi.domainName}api/update-password",
          queryParameters: {
            'token': data[0],
            'email': data[1],
            'new_password': newPassController.text
          });
      if (response.statusCode == 200) {
        showToast(msg: "Your Password Is Successfully Changed");
        Get.offAll(() => LoginPage());
      } else {

      }
    }on DioError catch(e){
      if(e.response!.statusCode==422){
        showToast(msg: "Verification Code Is Incorrect");
      }
    }
  }

}