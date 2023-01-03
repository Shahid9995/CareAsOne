import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/model/docs.dart';
import 'package:careAsOne/model/received_docs.dart';
import 'package:careAsOne/model/shared_doc.dart';
import 'package:careAsOne/model/signature_doc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ReceivedDocController extends GetxController {
  var token;
  final storage = GetStorage();
  List<DocsModel> docsList=[];
  List<DocsModel> responseData=[];
  List<ReceivedDocsModel> receiveddocsList=[];
  List<ReceivedDocsModel> receivedresponseData=[];
  List<SharedDoc> shareDocsList=[];
  List<SharedDoc> responseDataShare=[];
  List<SignatureDocModel> signatureDocsList=[];
  List<SignatureDocModel> responseDataSignature=[];
  bool isLoading = false;
  bool allDocs = false;
  bool shreDocs = false;
  var dropDown = "";
  var applicantId = "";
  List id = [];
  List sharedDocId = [];
  @override
  void onInit() async {
    token = storage.read("authToken");
    await getReceivedDocsList(token);
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    update();
    super.onReady();
  }

  Future<List<DocsModel>> getDocsList(token) async {
    isLoading = true;
    docsList = [];
    responseData = [];
    update();
    Response? response = await BaseApi.get(
        url: 'job-seeker/documents', params: {"api_token": token});
    if (response!.statusCode == 200) {
      if (response.data["data"] != null) {
        response.data["data"].forEach((ele) {
          responseData.add(DocsModel.fromJson(ele));
        });

        docsList = responseData;
        docsList.forEach((element) {
        });
        isLoading = false;
        update();
      }
    }
    return docsList;
  }

  Future<List<SharedDoc>> getShareDocsList(token) async {
    isLoading = true;
    shareDocsList = [];
    responseDataShare = [];
    update();
    Response? response = await BaseApi.get(
        url: 'job-seeker/received-documents', params: {"api_token": token});
    if (response!.statusCode == 200) {
      if (response.data["data"] != null) {
        response.data["data"].forEach((ele) {
          responseDataShare.add(SharedDoc.fromJson(ele));
        });
        shareDocsList = responseDataShare;
        isLoading = false;
        update();
      }
    }
    return shareDocsList;
  }

  Future<List<ReceivedDocsModel>> getReceivedDocsList(token) async {
    isLoading = true;
    receiveddocsList = [];
    receivedresponseData = [];
    update();
    try {
      Response? response = await BaseApi.get(
          url: 'job-seeker/received-documents', params: {"api_token": token});
      if (response!.statusCode == 200) {
        if (response.data["data"] != null) {
          response.data["data"].forEach((ele) {
            receivedresponseData.add(ReceivedDocsModel.fromJson(ele));
          });
          receiveddocsList = receivedresponseData;
          receiveddocsList.forEach((element) {
          });
          isLoading = false;
          update();
        }
      }
    } on DioError  catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
    return receiveddocsList;
  }

  Future<void> deleteDocument(BuildContext context, idList,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}api/job-seeker/delete-documents?api_token=$token'));
    request.fields.addAll({'id[]': idList[0].toString()});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Document Deleted Successfully');
      });
      id = [];
      await getDocsList(token);
      update();
      Get.back();
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();

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
                              await deleteDocument(context, idList);
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
