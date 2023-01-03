import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader_with_message.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/job_seeker_single_chat.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/notification_key/notification_service_key.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;

class SendMessageController extends GetxController {
  TextEditingController messageTextController = new TextEditingController();
  var one = Get.arguments;
  var token;
  var message;
  bool isLoading = false;
  final scrollControllers = ScrollController();
  SeekerSingleMessageList seekerSingleMessageList=SeekerSingleMessageList();
/*  List<CompanyApplicants> msgList;
  List<CompanyApplicants> responseData;

  List<JobApplications> jobApplicantList;
  List<JobApplications> jobApplicantData;
  List<AllMessages> allMessages = [];
  List<AllMessages> messageData = [];*/
  SeekerProfileModel? seekerProfileModel;
  final myProfile = Get.find<ProfileService>();
  GetStorage storage = new GetStorage();
  @override
  void onInit() async {
    token = storage.read('authToken');
   // responseData = [];
    isLoading = true;
    update();
    seekerProfileModel = await myProfile.getSeekerData(token);
    // jobApplicantData = [];

 await getAllSeekerMessages(token);

    getEmployerUnseenChat(one[1],one[2]);
    isLoading = false;
    update();
 getToLastMessage();
    super.onInit();
  }
/*  void runInIsolate(SendPort sendPort)async{

    Dio dio=Dio();
    try {
      Response response = await dio.post(
          '${BaseApi.domainName}api/job-seeker/get-history?api_token=$token&chat_id=${one[1]}&chat_user_id=${one[2]}',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        seekerSingleMessageList=SeekerSingleMessageList.fromJson(response.data);
        isLoading=false;
        update();
        Isolate(sendPort,terminateCapability: Capability()).kill(priority: Isolate.immediate);
      }
    } on DioError  catch (ex) {
      if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
        showToast(msg: "Time out");
      } else {
        Get.back();
        Get.back();
        showToast(msg: "Something went wrong");
      }
    }
  }*/
  getToLastMessage()async{
    await Future.delayed(const Duration(milliseconds: 50));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollControllers.animateTo(
          scrollControllers.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    });
  }

  void sendMessage(BuildContext context,String message) async {
  CircularLoaderWithMessage().showAlert(context);
    messageTextController.text = '';
    Dio dio = new Dio();
    try {
      Future.delayed(Duration(seconds: 7)).then((value) async {
        Response response =
        await dio.post('${BaseApi.domainName}api/job-seeker/message-save',
            queryParameters: {'api_token': token},
            options: Options(headers: {'Accept': 'application/json'}),
            data: {
              "company_id": one[0],
              "chat_id": one[1],
              "employer_id": one[2],
              "message": message,
              "status": one[3]
            });
        if (response.statusCode == 200) {
          await getAllSeekerMessages(token);
          update();
          Get.back();
          showToast(msg: "Sent");
          sendNotification();
          update();
        } else {
          Get.back();
        }
      });
    }catch(e){
      showToast(msg: "Not Sent");
      Get.back();
    }
  }
  Stream getAllMessages(Duration refreshTime)async*{
    while(true){

      await Future.delayed(refreshTime);
      yield await getAllSeekerMessages(token);
    }
  }

  getAllSeekerMessages(token) async {

    Dio dio = new Dio();
    try {
      Response response = await dio.post(
          '${BaseApi.domainName}api/job-seeker/get-history?api_token=$token&chat_id=${one[1]}&chat_user_id=${one[2]}',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
seekerSingleMessageList=SeekerSingleMessageList.fromJson(response.data);
isLoading=false;
        update();
      }
    } on DioError  catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        Get.back();
        showToast(msg: "Something went wrong");
      }
    }
  }
sendNotification()async{
  var headers= <String, String>{
    'Authorization': 'key=$api_key',
    'Content-Type': 'application/json'
  };
  var body= jsonEncode(<String,dynamic>{
  "to" : "${one[8]}",
  "collapse_key" : "New Message",
  "priority": "high",
  "notification" : {
  "title": "New Message",
  "body" : "${myProfile.seekerProfileModel!.firstName} sent you a message",
    "sound":"default"
  }
  });
  final response=await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headers,
      body: body);
  }
  // Future<List<JobApplications>> getApplicationData(token) async {
  //   jobApplicantList = [];
  //   allMessages = [];
  //   responseData = [];
  //   Dio dio = new Dio();
  //   Response response = await dio.get(
  //       '${BaseApi.domainName}api/job-seeker/message-list',
  //       queryParameters: {'api_token': token},
  //       options: Options(headers: {"Accept": "application/json"}));
  //   if (response.statusCode == 200) {
  //     jobApplicantList = [];
  //     allMessages = [];
  //     responseData = [];
  //     response.data['data']['jobApplications'].forEach((e) {
  //       jobApplicantList.add(JobApplications.fromJson(e));
  //       jobApplicantData = jobApplicantList;
  //     });
  //
  //     jobApplicantData.forEach((element) {
  //       allMessages.addAll(element.messages);
  //       allMessages.forEach((element) {
  //         messageData = [];
  //       });
  //     });
  //     messageData = [];
  //     for (int i = 0; i < allMessages.length; i++) {
  //       if (allMessages[i].to.toString() == one[2].toString() ||
  //           allMessages[i].from.toString() == one[2].toString()) {
  //         // messageData.addAll(allMessages);
  //         messageData.add(allMessages[i]);
  //       }
  //     }
  //     isLoading = false;
  //     update();
  //   }
  //   isLoading = false;
  //   update();
  //   // return jobApplicantData;
  // }
  getEmployerUnseenChat( String chatId, String chatUserId) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        '${BaseApi.domainName}api/update-messages-seen',
        queryParameters: {'api_token': token,"chat_id":chatId, "chat_user_id":chatUserId},
        options: Options(headers: {'Accept': 'application/json'}));
    if (response.statusCode == 200) {
      update();
      //
    }else{
    }
  }
}
