import 'dart:convert';
import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader_with_message.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/company_profile.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/single_applicant_message.dart';
import 'package:careAsOne/notification_key/notification_service_key.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;

class SendMessageEmployer extends GetxController {
  TextEditingController textEditingController = new TextEditingController();
  var two = Get.arguments;
  var token;
  var message;
  bool isLoading = true;
  CompanyProfile? companyProfile;

  final scrollControllers = ScrollController();

  EmpProfileModel? empProfileModel;
  int totalCount = 0;
  var jobTitle;
  var title = [];
  var messageAll = [];
  var messagesCount = [];
  final myProfile = Get.find<ProfileService>();
  String status = "";
  GetStorage storage = new GetStorage();
  EmployeeSingleMessageList employeeSingleMessageList=EmployeeSingleMessageList();
  List<SingleApplicantMessageList> singleApplicantMessageList=[];
  @override
  Future<void> onInit() async {
    token = storage.read('authToken');

    isLoading = true;
    update();
    companyProfile = await myProfile.getCurrentUserCompany(token);
    empProfileModel = await myProfile.getUserData(token);
//  await updateData();

    await getEmployerMessageData(token);
    await getEmployerUnseenChat(two[4],two[3]);
    //scrollController.position.maxScrollExtent;
    moveToBottom();
    isLoading = false;
    update();
    // TODO: implement onInit
    super.onInit();
  }
  moveToBottom()async{
    await Future.delayed(const Duration(milliseconds: 50));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollControllers.animateTo(
          scrollControllers.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    });
  }
  getToLastMessage()async{
    await Future.delayed(const Duration(milliseconds: 50));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollControllers.animateTo(
          scrollControllers.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    });
  }
  ResponseBody? responseBody;
  Stream getAllMessages(Duration refreshTime)async*{
    while(true){
      await Future.delayed(refreshTime);
      yield await getEmployerMessageData(token);
    }
  }

getEmployerMessageData(token) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.post(
          '${BaseApi.domainName}api/employer/messages/employee-messages?chat_id=${two[4]}&chat_user_id=${two[3]}',
          queryParameters: {'api_token': token,},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        //
        if (response.data["data"] == "No Message Found") {
          isLoading = false;
          update();
          print(response.data);
        } else {
          employeeSingleMessageList = EmployeeSingleMessageList.fromJson(response.data);
        }
      } else {

isLoading = false;
update();
      }
    }catch(e){
      showToast(msg: "Something went wrong");
      Get.back();
      isLoading = false;
      update();
    }

  }
   sendMessage(BuildContext context,message, status) async {
    textEditingController.text = "";
    Dio dio = new Dio();
    CircularLoaderWithMessage().showAlert(context);
    try {
      Future.delayed(Duration(seconds: 7)).then((value) async {
        Response response =
        await dio.post("${BaseApi.domainName}api/employer/messages/store",
            queryParameters: {"api_token": token},
            options: Options(headers: {"Accept": "application/json"}),
            data: {
              "message": message,
              "jobseeker_id": two[3],
              "company_id": companyProfile!.id.toString(),
              "chat_id": two[4],
              "status": two[5]
            });
        if (response.statusCode == 200) {
          FocusScope.of(context)
              .requestFocus(FocusNode());
          Get.back();
          showToast(msg: "Sent");
          await getEmployerMessageData(token);

          update();
          sendNotification();
          update();
        } else {

        }
      });
    }catch(e){
      showToast(msg: "Something went wrong");
   Get.back();
    //  Get.back();
    }
  }
  sendNotification(){
    var headers= <String, String>{
      'Authorization': 'key=$api_key',
      'Content-Type': 'application/json'
    };
    var body= jsonEncode(<String,dynamic>{
      "to" : "${two[7]}",
      "collapse_key" : "New Message",
      "priority": "high",
      "notification" : {
        "title": "New Message",
        "body" : "${myProfile.empProfileModel!.firstName} sent you a message",
        "sound":"default"
      }
    });
    final response= http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headers,
        body: body);
  }
  getEmployerUnseenChat( String chatId, String chatUserId) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        '${BaseApi.domainName}api/update-messages-seen',
        queryParameters: {'api_token': token,"chat_id":chatId, "chat_user_id":chatUserId},
        options: Options(headers: {'Accept': 'application/json'}));
    if (response.statusCode == 200) {
      update();
    }else{

    }
  }
}
