import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/all_job_applicants.dart';
import 'package:careAsOne/model/job_applicant.dart';
import 'package:careAsOne/model/jobs.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class UserJobService extends GetxService {
  List<JobsModel> jobsModel=[];
  List<JobsModel> responseBody = [];
  List<JobsModel> emplList = [];
  List<JobApplicantModel> jobsApplicantModel=[];
  List<JobApplicantModel> responseBody1 = [];
  var authService = Get.find<AuthService>();
  String? applicantJob;
  var list = [];
  List<String> tagsWord = [];
  List<String> zipCodesNewList = [];

  List<String> citiesNewList = [];
  var remainPostJob;
  List<AllApplicantsInterview>applications = [];
  List<AllApplicantsInterview>allInterviewApplicants = [];
  Future<UserJobService> init() async {
    return this;
  }

  Future<List<JobsModel>> getUserJob(token) async {
    String keyWords = "";
    String city = "";
    String zipCode = "";
    responseBody = [];
    jobsModel = [];
    try {
      Response? response =
      await BaseApi.get(url: 'jobs', params: {"api_token": token});
      if (response!.statusCode == 200) {
        remainPostJob = response.data["remaining_post_jobs"].toString();
        if (responseBody != null) {
          response.data["data"].forEach((element) {
            responseBody.add(JobsModel.fromJson(element));
          });
          jobsModel = responseBody;
          jobsModel.forEach((element) {
            keyWords = element.keywords.toString();
            if (keyWords.contains('value')) {
              var listTagValue = [];
              try {
                var keywordJson;
                keywordJson = jsonDecode(keyWords);
                String keyWordVal = "";
                listTagValue = keywordJson as List;
                for (int i = 0; i < listTagValue.length; i++) {
                  keyWordVal = listTagValue[i]['value'] + " " + keyWordVal;
                  element.keywords = keyWordVal;
                  tagsWord.add("${listTagValue[i]['value']}");
                }
              } catch (e) {}
            } else {
              element.keywords = keyWords;
            }
            city = element.city.toString();
            if (city.contains('value')) {
              var cityList = [];
              try {
                var parsedJson;
                parsedJson = jsonDecode(city);
                String cityJson = "";
                cityList = parsedJson as List;
                for (int i = 0; i < cityList.length; i++) {
                  cityJson =
                      "${(i + 1 != cityList.length && i + 1 < city.length)
                          ? "|"
                          : " "}" + cityList[i]['value'] + "" + cityJson;
                  element.city = cityJson;
                  citiesNewList.add("${cityList[i]['value']}");
                  element.city = citiesNewList.toString();
                }
                element.city = cityJson;
              } catch (e) {}
            } else {
              element.city = city;
            }
            zipCode = element.zipCode.toString();
            if (zipCode.contains('value')) {
              var zipList = [];
              try {
                var zipJson;
                zipJson = jsonDecode(zipCode);
                String zipCodeVal = "";
                zipList = zipJson as List;
                for (int i = 0; i < zipList.length; i++) {
                  zipCodeVal = "${i + 1 != zipList.length && i + 1 < city.length
                      ? "|"
                      : " "}" + zipList[i]['value'] + "" + zipCodeVal;
                  element.zipCode = zipCodeVal;
                  zipCodesNewList.add("${zipList[i]['value']}");
                }
                element.zipCode = zipCodeVal;
              } catch (e) {}
            } else {

            }
          });

        }
      } else if (responseBody != null) {

      } else {

      }
    }on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
        return jobsModel;
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }

    }
    return jobsModel;
  }

  Future<List<JobApplicantModel>> getJobApplicant(token, jobId) async {
    responseBody1 = [];
    jobsApplicantModel = [];
    print(jobId.toString()+"??");
    Response? response = await BaseApi.get(
        url: 'jobapplication/jobwiselist/$jobId', params: {"api_token": token});
    if (response!.statusCode == 200) {
      print(response.data);
      remainPostJob = response.data["remaining_post_jobs"];
      print(response.data["remaining_post_jobs"]);

        response.data["data"].forEach((element) {
          responseBody1.add(JobApplicantModel.fromJson(element));
        });
        jobsApplicantModel = responseBody1;

    } else if (responseBody != null) {
    } else {
    }
    return jobsApplicantModel;
  }

   getAllJobsApplicants(token) async {
    applications = [];
    allInterviewApplicants = [];
    Response? response = await BaseApi.get(
        url: 'jobapplication/create_interview', params: {"api_token": token});
    if (response!.statusCode == 200) {
      response.data['data'].forEach((e) {
        allInterviewApplicants.add(AllApplicantsInterview.fromJson(e));
      });
      return allInterviewApplicants;
    }
  }
}
