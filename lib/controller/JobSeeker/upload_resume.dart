import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/docs.dart';
import 'package:careAsOne/model/overall_seeker_data.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';


class UploadResumeController extends GetxController {
  var token;
  final storage = GetStorage();
  List<DocsModel> docsList=[];
  List<DocsModel> responseData=[];
  bool isLoading = true;

  String? coverLetterData;

  String? resumeData;
  String? certificationData;
  String? registryData;
  bool allDocs = false;
  var dropDown = "";
  var applicantId = "";
  List id = [];
  FormData? formData;
  File? resume;
  SeekerProfileModel? seekerProfileModel;
  final myProfile = Get.find<ProfileService>();
Datam? seekerDataOverall;
  @override
  void onInit() async {
    isLoading = true;
    update();
    token = storage.read("authToken");
    seekerProfileModel = await myProfile.getSeekerData(token);
    seekerDataOverall=await myProfile.getOverallData(token);
    getUploadedResume(token);
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    update();
    super.onReady();
  }

  Future<void> uploadResume(
      BuildContext context,
      File? resume,
      File? coverLetter,
      File? certification,
      File? registry,
      bool coverBool,
      bool resumeBool,
      bool certificateBool,
      bool registryBool,) async {
    isLoading = true;
    update();
    if (coverBool && certificateBool && resumeBool && registryBool) {
      String fileNameResume = resume!.path.split('/').last;
      String fileNameCover = coverLetter!.path.split('/').last;
      String fileNameCertification = certification!.path.split('/').last;
      String fileNameRegistry = registry!.path.split('/').last;

      formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(resume.path,
            filename: fileNameResume, contentType: MediaType("File", "pdf")),
        "cover_letter": await MultipartFile.fromFile(coverLetter.path,
            filename: fileNameCover, contentType: MediaType("File", "docx")),
        "certifications": await MultipartFile.fromFile(certification.path,
            filename: fileNameCertification,
            contentType: MediaType("File", "pdf")),
        "registry": await MultipartFile.fromFile(registry.path,
            filename: fileNameRegistry, contentType: MediaType("File", "pdf"))
      });
    } else if (coverBool == true &&
        certificateBool == false &&
        resumeBool == false &&
        registryBool == false) {
      String fileNameCover = coverLetter!.path.split('/').last;
      formData = FormData.fromMap({
        "cover_letter": await MultipartFile.fromFile(coverLetter.path,
            filename: fileNameCover, contentType: MediaType("File", "docx")),
      });
    } else if (coverBool == false &&
        certificateBool == true &&
        resumeBool == false &&
        registryBool == false) {
      String fileNameCertification = certification!.path.split('/').last;
      formData = FormData.fromMap({
        "certifications": await MultipartFile.fromFile(certification.path,
            filename: fileNameCertification,
            contentType: MediaType("File", "pdf")),
      });
    } else if (coverBool == false &&
        certificateBool == false &&
        resumeBool == true &&
        registryBool == false) {
      String fileNameResume = resume!.path.split('/').last;
      formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(resume.path,
            filename: fileNameResume, contentType: MediaType("File", "pdf")),
      });
    } else if (coverBool == false &&
        certificateBool == false &&
        resumeBool == false &&
        registryBool == true) {
      String fileNameRegistry = registry!.path.split('/').last;
      formData = FormData.fromMap({
        "registry": await MultipartFile.fromFile(registry.path,
            filename: fileNameRegistry, contentType: MediaType("File", "pdf"))
      });
    } else if (coverBool == true &&
        certificateBool == true &&
        resumeBool == false &&
        registryBool == false) {
      String fileNameCover = coverLetter!.path.split('/').last;
      String fileNameCertification = certification!.path.split('/').last;
      formData = FormData.fromMap({
        "certifications": await MultipartFile.fromFile(certification.path,
            filename: fileNameCertification,
            contentType: MediaType("File", "pdf")),
        "cover_letter": await MultipartFile.fromFile(coverLetter.path,
            filename: fileNameCover, contentType: MediaType("File", "docx")),
      });
    } else if (coverBool == true &&
        certificateBool == true &&
        resumeBool == true &&
        registryBool == false) {
      String fileNameResume = resume!.path.split('/').last;
      String fileNameCover = coverLetter!.path.split('/').last;
      String fileNameCertification = certification!.path.split('/').last;
      formData = FormData.fromMap({
        "certifications": await MultipartFile.fromFile(certification.path,
            filename: fileNameCertification,
            contentType: MediaType("File", "pdf")),
        "cover_letter": await MultipartFile.fromFile(coverLetter.path,
            filename: fileNameCover, contentType: MediaType("File", "docx")),
        "resume": await MultipartFile.fromFile(resume.path,
            filename: fileNameResume, contentType: MediaType("File", "pdf")),
      });
    } else if (coverBool == false &&
        certificateBool == false &&
        resumeBool == true &&
        registryBool == true) {
      String fileNameRegistry = registry!.path.split('/').last;
      String fileNameResume = resume!.path.split('/').last;
      formData = FormData.fromMap({
        "registry": await MultipartFile.fromFile(registry.path,
            filename: fileNameRegistry, contentType: MediaType("File", "pdf")),
        "resume": await MultipartFile.fromFile(resume.path,
            filename: fileNameResume, contentType: MediaType("File", "pdf")),
      });
    } else if (coverBool == false &&
        certificateBool == true &&
        resumeBool == false &&
        registryBool == true) {
      String fileNameCertification = certification!.path.split('/').last;
      String fileNameRegistry = registry!.path.split('/').last;
      formData = FormData.fromMap({
        "certifications": await MultipartFile.fromFile(certification.path,
            filename: fileNameCertification,
            contentType: MediaType("File", "pdf")),
        "registry": await MultipartFile.fromFile(registry.path,
            filename: fileNameRegistry, contentType: MediaType("File", "pdf")),
      });
    } else if (coverBool == true &&
        certificateBool == false &&
        resumeBool == true &&
        registryBool == false) {
      String fileNameCover = coverLetter!.path.split('/').last;
      String fileNameResume = resume!.path.split('/').last;
      formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(resume.path,
            filename: fileNameResume, contentType: MediaType("File", "pdf")),
        "cover_letter": await MultipartFile.fromFile(coverLetter.path,
            filename: fileNameCover, contentType: MediaType("File", "docx")),
      });
    } else if (coverBool == true &&
        certificateBool == false &&
        resumeBool == true &&
        registryBool == true) {
      String fileNameRegistry = registry!.path.split('/').last;
      String fileNameCover = coverLetter!.path.split('/').last;
      String fileNameResume = resume!.path.split('/').last;
      formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(resume.path,
            filename: fileNameResume, contentType: MediaType("File", "pdf")),
        "cover_letter": await MultipartFile.fromFile(coverLetter.path,
            filename: fileNameCover, contentType: MediaType("File", "docx")),
        "registry": await MultipartFile.fromFile(registry.path,
            filename: fileNameRegistry, contentType: MediaType("File", "pdf")),
      });
    } else if (coverBool == false &&
        certificateBool == true &&
        resumeBool == true &&
        registryBool == true) {
      String fileNameCertification = certification!.path.split('/').last;
      String fileNameResume = resume!.path.split('/').last;
      String fileNameRegistry = registry!.path.split('/').last;
      formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(resume.path,
            filename: fileNameResume, contentType: MediaType("File", "pdf")),
        "certifications": await MultipartFile.fromFile(certification.path,
            filename: fileNameCertification,
            contentType: MediaType("File", "pdf")),
        "registry": await MultipartFile.fromFile(registry.path,
            filename: fileNameRegistry, contentType: MediaType("File", "pdf")),
      });
    } else if (coverBool == true &&
        certificateBool == true &&
        resumeBool == false &&
        registryBool == true) {
      String fileNameRegistry = registry!.path.split('/').last;
      String fileNameCover = coverLetter!.path.split('/').last;
      String fileNameCertification = certification!.path.split('/').last;
      formData = FormData.fromMap({
        "cover_letter": await MultipartFile.fromFile(coverLetter.path,
            filename: fileNameCover, contentType: MediaType("File", "docx")),
        "certifications": await MultipartFile.fromFile(certification.path,
            filename: fileNameCertification,
            contentType: MediaType("File", "pdf")),
        "registry": await MultipartFile.fromFile(registry.path,
            filename: fileNameRegistry, contentType: MediaType("File", "pdf")),
      });
    }
    Dio dio = new Dio();

    dio
        .post("${BaseApi.domainName}api/job-seeker/resume-upload",
            options: Options(headers: {"Accept": "application/json"}),
            queryParameters: {"api_token": token},
            data: formData)
        .then((response) async {
      if (response.statusCode == 200) {
        await getUploadedResume(token);
        Future.delayed(Duration(seconds: 2)).then((value) {
          showToast(msg: "Successfully Uploaded");
        });
        Get.back();
        await Get.find<HomeController>().getOverallData(token);
        update();
        isLoading = false;
        update();
      }
    }).catchError((error) {});
    isLoading = false;
    update();
  }

  Future<void> getUploadedResume(token) async {
    isLoading = true;
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          "${BaseApi.domainName}api/job-seeker/resume",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        coverLetterData = response.data['data']['cover_letter'];
        resumeData = response.data['data']['resume'];
        certificationData = response.data['data']['certifications'];
        registryData = response.data['data']['registry'];
      }
      isLoading = false;
      update();
    } on DioError  catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
  }

  Future<void> deleteResume(String category) async {
    isLoading = true;
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.post(
          "${BaseApi.domainName}api/job-seeker/delete-uploaded-resume",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}),
          data: {
            "category": category,
          });
      if (response.statusCode == 200) {
        showToast(msg: "Deleted");

        getUploadedResume(token);
        Get.back();
        await Get.find<HomeController>().getOverallData(token);
        isLoading = false;
        update();
      }
      isLoading = false;
      update();
    } on DioError  catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
  }

  Future showSelectionDialog(BuildContext context, category) {
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
                              await deleteResume(category);
                              //Get.offAndToNamed("/homeMaster");
                              Get.back();
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
