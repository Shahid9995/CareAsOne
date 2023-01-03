import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/Employeer/docs.dart';
import 'package:careAsOne/model/docs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:get_storage/get_storage.dart';

class AddDocsController extends GetxController {
  var token;
  final storage = GetStorage();
  List<DocsModel>? docsList;
  List<DocsModel>? responseData;
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
    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "resume": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();

    dio
        .post("${BaseApi.domainName}api/employer/upload-documents",
            options: Options(headers: {"Accept": "application/json"}),
            queryParameters: {"api_token": token},
            data: data)
        .then((response) async {
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          showToast(msg: 'Document Uploaded Successfully');
        });

        await Get.find<EmpDocsController>().getDocsList(token);
        Get.find<EmpDocsController>().update();
        Get.back();
        isLoading = false;
        update();
      }
    }).catchError((error) => showToast(msg: error));
    isLoading = false;
    update();
  }
}
