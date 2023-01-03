import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/employer_applicant_list.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class EmployerMessagesController extends GetxController {
  var token;

  var messageUnseenList=[];
  int receivedMessageCount=0;
  bool isLoading=true;
  final myProfile = Get.find<ProfileService>();
  EmployerApplicantsMessageList employerApplicantsMessageList=EmployerApplicantsMessageList();
  EmpProfileModel? empProfileModel;
  int totalCount = 0;
  var jobTitle;
  var title = [];
  var messagesForIndex = [];
  var index;
  var fromMsgId="0";

  GetStorage storage = new GetStorage();

  @override
  Future<void> onInit() async {
    token = storage.read('authToken');
    isLoading=true;
    update();

    jobTitle = [];
    empProfileModel = await myProfile.getUserData(token);
    await getEmployerMessageData(token);
    // getCurrentEmployer(token);
    isLoading=false;
    update();
    update();
    // TODO: implement onInit
    super.onInit();
  }

  ResponseBody? responseBody;

  getEmployerMessageData(token) async {

    print(token);
    try {
      Dio dio = new Dio();
      Response response = await dio.get(
          '${BaseApi.domainName}api/employer/get-all-applicants?api_token=$token',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));

      if (response.statusCode == 200) {
        //
        employerApplicantsMessageList=EmployerApplicantsMessageList.fromJson(response.data);
/*    response.data['data']['userJob'].forEach((e) {
      userJobList.add(UserJob.fromJson(e));
      userJobData = userJobList;
    });*/

        print(response.data);
/*    userJobData.forEach((element) {
      jobTitle = [];
      jobTitle = element.title;
      listElement.addAll(element.applications);
      listElementData = listElement;

      title = [];
      listElementData.forEach((element) {

        title.add(element.jobTitle);
        employerMessages.addAll(element.messages);
        messageList = employerMessages;
        index = [];
        index = element.messages.length;
        messageList.forEach((element) {
        });
        messagesForIndex.add(index);
      });
    });
    var messageSeenUnseenList = [];

    for (int i = 0; i < messageList.length; i++) {
      if (messageList[i].from.toString() == '96') {
        messageList[i].seen == 0 ?
        messageUnseenList.add(
            messageList[i].seen) : print('vv');
      } else {

      }
    }*/
      } else {
        AlertDialog(title: Text("Not Found"),
          content: Icon(Icons.error_outline_sharp, color: Colors.red,),);
      }
    } on DioError  catch (ex) {
      if(ex.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
        isLoading=false;
        update();
      }
    }
    //  return userJobData;
  }

/*  Future<List<EmployeeList>> getCurrentEmployer(token) async {

    Dio dio = new Dio();
    Response response = await dio.get(
        "${BaseApi.domainName}api/employer/messages",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}));
    if (response.statusCode == 200) {
      response.data['data']['employeeList'].forEach((e) {
        employeeList.add(EmployeeList.fromJson(e));
        employeeData = employeeList;
        employeeData.forEach((element) {
        });
      });
    }
    return employeeData;
  }*/

}
