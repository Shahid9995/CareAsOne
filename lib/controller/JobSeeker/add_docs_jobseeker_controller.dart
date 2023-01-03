import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/docs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:get_storage/get_storage.dart';

import 'jobseeker_doc_controller.dart';

class AddDocsJobSeekerController extends GetxController {
  var token;
  final storage = GetStorage();
  List<DocsModel> docsList=[];
  List<DocsModel> responseData=[];
  bool isLoading = false;
  bool allDocs = false;
  var dropDown = "";
  var applicantId = "";
  List id = [];
  File? file;

  @override
  void onInit() async {
    token = storage.read("authToken");
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    update();
    super.onReady();
  }

  Future<void> uploadDocument(BuildContext context, File file,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    String fileName = file.path
        .split('/')
        .last;

    FormData data = FormData.fromMap({
      "document": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();
    try {
      dio
          .post("${BaseApi.domainName}api/job-seeker/save-documents",
          options: Options(headers: {"Accept": "application/json"}),
          queryParameters: {"api_token": token},
          data: data)
          .then((response) async {
        if (response.statusCode == 200) {
          // DialogLoader.showLoader(context);
          Future.delayed(Duration(seconds: 2)).then((value) {
            showToast(msg: 'Document Uploaded Successfully');
          });

          await Get.find<JobSeekerDocsController>().getDocsList(token);
          Get.find<JobSeekerDocsController>().update();
          Get.back();
          isLoading = false;
          update();
        }
      }).catchError((error){
      });
      isLoading = false;
      update();

    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
  }
}
