import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/view/auth_screens/verification_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart'hide Response;

class ForgetPasswordController extends GetxController{
TextEditingController emailController=TextEditingController();
GlobalKey<FormBuilderState> forgetKey = GlobalKey<FormBuilderState>();
  @override
  void onInit() {
    super.onInit();
  }
 sendPasswordResetMail(String email)async{
Dio dio =new Dio();
try{
Response response=await dio.post("${BaseApi.domainName}api/forget-password",queryParameters:{'email':email} );
if(response!=null) {
  if (response.statusCode == 200) {
    Get.to(() => VerificationCode(), arguments: [email]);
  }
}
}on DioError catch(e){
  if(e.response!.statusCode==422){
    showToast(msg: "Please Enter Correct Email");
  }
}
  }
}