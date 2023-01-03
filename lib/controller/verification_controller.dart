import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
class VerificationController extends GetxController{
  TextEditingController textEditingController=TextEditingController();
  GlobalKey<FormBuilderState> verifyKey = GlobalKey<FormBuilderState>();
  var email=Get.arguments;
}