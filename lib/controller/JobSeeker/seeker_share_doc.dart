import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/jobseeker_doc_controller.dart';
import 'package:careAsOne/model/all_employers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SeekerShareDoc extends GetxController{
  var token ="";
  GetStorage auth=new GetStorage();
  List<AllEmployer> employerList=[];
  List<AllEmployer> responseData=[];
  List <AllEmployer> searchedList=[];
  String empName="";
  bool isLoading=true;
  bool selectAll = false;
var id=[];
  @override
  void onInit()async {
    isLoading=true;
    update();
    token=auth.read("authToken");
    employerList=await getEmployerList(token);
isLoading=false;
update();
    super.onInit();
  }
  Future<List<AllEmployer>>getEmployerList(token)async{
    responseData=[];
    Dio dio=new Dio();
    Response response=await dio.get("${BaseApi.domainName}api/job-seeker/documents",queryParameters: {"api_token":token},options: Options(headers: {'Accept':'application/json'}));
    if(response.statusCode==200){
      response.data["employers"].forEach((e){employerList.add(AllEmployer.fromJson(e));});

    }
    return employerList;

  }
  Future showSelectionDialog(BuildContext context,
      {List? fileld, List? id}) {
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
            child:ListBody(
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
                              await shareDocument(fileld!,
                                  id!);
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

  shareDocument(List fileld, List id) async{
    isLoading = true;
    update();
    var response=await http.post(
      Uri.parse('${BaseApi.domainName}api/job-seeker/share-documents?api_token=$token'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept':'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "fileId": fileld,
        "id": id

      }),
    );
    if(response.statusCode==200){
      showToast(msg: "Shared Successful");
      //await getDocsList(token);
      await Get.find<JobSeekerDocsController>().getDocsList(token);

      update();
      id=[];
      Get.back();


      isLoading = false;
      update();
    }

    //Dio dio = new Dio();
   // Response response= await dio.post("${BaseApi.domainName}api/job-seeker/share-documents",queryParameters: {"api_token": token}, options: Options(headers: {'Accept':'application/json'},))
  }
}