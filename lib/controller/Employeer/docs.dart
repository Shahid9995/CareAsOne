import 'dart:convert';
import 'dart:ui';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/model/docs.dart';
import 'package:careAsOne/model/shared_doc.dart';
import 'package:careAsOne/model/signature_doc.dart';
import 'package:careAsOne/services/get_employee.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class EmpDocsController extends GetxController {
  var token;
  final storage = GetStorage();
  List<DocsModel> docsList=[];
  List<DocsModel> responseData=[];
  List<DocsModel> searchedList=[];
  String docName="";
  List<SharedDoc> shareDocsList=[];
  List<SharedDoc> responseDataShare=[];
  List<SignatureDocModel> signatureDocsList=[];
  List<SignatureDocModel> responseDataSignature=[];
  bool isLoading = true;
  bool allDocs = false;
  bool shreDocs = false;
  var dropDown = "";
  var applicantId = "";
  List id = [];
  List sharedDocId = [];
  TextEditingController controller=new TextEditingController();
  final empService = Get.find<EmployeeService>();

  @override
  void onInit() async {

    isLoading=true;
    update();
    token = storage.read("authToken");
    await getDocsList(token);
   await getShareDocsList(token);
    await getSignatureDocsList(token);
    await empService.getEmployess(token);
searchedList=[];
isLoading=false;
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    await empService.getEmployess(token);
    update();
    super.onReady();
  }
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
  Future<List<DocsModel>> getDocsList(token) async {

    docsList = [];
    responseData = [];
try{
    Response? response = await BaseApi.get(
        url: 'employer/documents', params: {"api_token": token});
    print(response!.data.toString());
    if (response.statusCode == 200) {
      if (response.data["data"] != null) {
        response.data["data"].forEach((ele) {
          responseData.add(DocsModel.fromJson(ele));
        });

        docsList = responseData;
        docsList.forEach((element) {
        });


      }
    }
    }on DioError catch (e) {
    if (e.type == DioErrorType.connectTimeout) {
    showToast(msg: "Time out");
    } else {
    showToast(msg: "ERROR");
    }


    }
    return docsList;
  }
  Future<List<SharedDoc>> getShareDocsList(token) async {

    shareDocsList = [];
    responseDataShare = [];
try {
  Response? response = await BaseApi.get(
      url: 'employer/received-documents', params: {"api_token": token});
  var newShared = response!.data['data'];

  if (response.statusCode == 200) {
    if (response.data["data"] != null) {
      response.data["data"].forEach((ele) {
        responseDataShare.add(SharedDoc.fromJson(ele));
      });

      shareDocsList = responseDataShare;
    }
  }
}on DioError catch (e) {
  if (e.type == DioErrorType.connectTimeout) {
    showToast(msg: "Time out");
  } else {
    showToast(msg: "ERROR");
  }


}
    return shareDocsList;
  }

  Future<List<SignatureDocModel>> getSignatureDocsList(token) async {

    signatureDocsList = [];
    responseDataSignature = [];
try {
  Response? response = await BaseApi.get(
      url: 'employer/signature-documents', params: {"api_token": token});
  print(response!.data.toString());
  if (response.statusCode == 200) {
    if (response.data["data"] != null) {
      response.data["data"].forEach((ele) {
        responseDataSignature.add(SignatureDocModel.fromJson(ele));
      });

      signatureDocsList = responseDataSignature;
    }
  }
}on DioError catch (e) {
  if (e.type == DioErrorType.connectTimeout) {
    showToast(msg: "Time out");
  } else {
    showToast(msg: "ERROR");
  }


}
    return signatureDocsList;
  }
 deleteDocument(List idList) async{

    var response=await http.post(
      Uri.parse('${BaseApi.domainName}api/employer/documents/delete?api_token=$token'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept':'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'id': idList,
      }),
    );
    if(response.statusCode==200){
      id=[];


      showToast(msg: "Deleted");
      await getDocsList(token);
      searchedList=[];
      update();
      Get.back();
      isLoading = false;
      update();
    }
  }

  Future<void> deleteSharedDocument(BuildContext context, idList,
      {Map<String, dynamic>? params}) async {
    print(idList);
isLoading=true;
update();
    Map<String, dynamic> responseBody;
    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}api/employer/share-document-delete?api_token=$token'));
    request.fields.addAll({'document_id': idList.toString()});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      showToast(msg: 'Document Deleted from shared');

      await getShareDocsList(token);
      isLoading = false;
      update();
    } else {
    }
  }

  Future showSelectionDialog(BuildContext context, List idList) {
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
                child: ListBody(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Do you want to Delete Document?",
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

                              await deleteDocument( idList);
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
