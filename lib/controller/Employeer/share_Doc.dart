import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/model/employees.dart';
import 'package:careAsOne/services/get_employee.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SharedDocsController extends GetxController {
  var token;
  final storage = GetStorage();
  bool isLoading = false;
  bool selectAll = false;
  var dropDown = "";
  var applicantId = "";
  List id = [];
  List<Employees> searchedList=[];
  String empName="";
  List<Employees> empList = [];

  final empService = Get.find<EmployeeService>();

  @override
  void onInit() async {
    token = storage.read("authToken");
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    isLoading = true;
    update();
    empList = await empService.getEmployess(token);
    isLoading = false;
    update();
    super.onReady();
  }

  Future<void> shareDocument(fileId, userId, type,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    if (type == "video") {
      isLoading = true;
      update();
      var response=await http.post(
        Uri.parse('${BaseApi.domainName}api/employer/training/video-share?api_token=$token'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept':'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          "fileId": fileId,
          "id": userId
        }),
      );
      if(response.statusCode==200){
        showToast(msg: "Shared Successful");
        update();
        Get.back();
        isLoading = false;
        update();
      }






    } else {
isLoading = true;
update();
var response=await http.post(
  Uri.parse('${BaseApi.domainName}api/employer/document-share?api_token=$token'),
  headers: <String, String>{
    'Content-Type': 'application/json',
    'Accept':'application/json'
  },
  body: jsonEncode(<String, dynamic>{
    "fileId": fileId,
    "id": userId
  }),
);
if(response.statusCode==200){
  showToast(msg: "Shared Successful");
  // await getDocsList(token);
  update();
  Get.back();
  isLoading = false;
  update();
}
    }
  }

  Future showSelectionDialog(BuildContext context,
      {List? fileld, List? id, type}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
              // title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: type=="document"?ListBody(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Do you want to Share Document?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: AppColors.green),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: Colors.grey,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: AppColors.green,
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              await shareDocument( fileld,
                                  id, type);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ):ListBody(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Do you want to Share Video?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: AppColors.green),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: Colors.grey,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: AppColors.green,
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              await shareDocument( fileld,
                                  id, type);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
