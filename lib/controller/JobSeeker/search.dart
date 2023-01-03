import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/job_search_model.dart';
import 'package:careAsOne/model/overall_seeker_data.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/user_job.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchController extends GetxController {
  String? dropdownValue;

  GetStorage storage = new GetStorage();
  var token;
  String state = "";
  RefreshController refreshController =
      new RefreshController(initialRefresh: true);
  final authService = Get.find<AuthService>();

  // ignore: deprecated_member_use

  final home = Get.find<HomeController>();
  final userJobService = Get.find<UserJobService>();
  final myProfile = Get.find<ProfileService>();
  SeekerProfileModel? seekerProfileModel;
  bool isLoading = false;
  List<JobsSearchModel> jobList=[];
  List<JobsSearchModel> responseData = [];
  String city = "";
  var parsedJson;
  int currentPage = 2;
  var listValue = [];
  List<JobsSearchModel> append = [];
  var cityNew = "";
  Datam? data;
  var citiesNewList = [];
  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;
    update();
    data = await myProfile.getOverallData(token);
    responseData = [];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<List<JobsSearchModel>> getJobDataInList(token, isRefresh) async {
    isLoading = true;
    if (isRefresh) {
      currentPage = 1;
    }
    jobList = [];
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/search-jobs?page=$currentPage&api_token=$token',
          queryParameters: {
            'city': cityNew,
            'state': dropdownValue == "Select State" ? "" : dropdownValue
          },
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        var response1 = response.data['data']['jobs']['data'];
        response.data['data']['jobs']['data'].forEach((e) {
          jobList.add(JobsSearchModel.fromJson(e));
        });
        append = jobList;
        if (isRefresh) {
          responseData = jobList;
        } else if (!isRefresh) {
          responseData.addAll(append);
        }

        responseData.forEach((element) {
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
                    "${(i + 1 != cityList.length && i + 1 < city.length) ? "," : " "}" +
                        cityList[i]['value'] +
                        "" +
                        cityJson;
                element.city = cityJson;
                citiesNewList.add("${cityList[i]['value']}");
                element.city = citiesNewList.toString();
              }
              element.city = cityJson;
            } catch (e) {}
          } else {
            element.city = city;
          }
        });
        currentPage++;
        isLoading = false;
        update();
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Login Again.");
        authService.logOut();
      } else if (e.response!.statusCode == 500) {
        showToast(msg: "Server Error");
      }
    }
    return responseData;
  }
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
   applyOnJob(BuildContext context,int id) async {
    city = "";
    state = "";
    CircularLoader().showAlert(context);
    update();
    if ((data!.userEmploymentDetail == null ||
            data!.userEducationRecord == null ||
            data!.userRecord!.dob == null) &&
        data!.userEmploymentDetail!.resume == null) {
      showToast(
          msg: "Please Complete Work History or Upload Resume",
          backgroundColor: Colors.red);
    } else {
      Dio dio = new Dio();
      Response response = await dio.post(
          '${BaseApi.domainName}api/job-seeker/job-submit',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}),
          data: {"id": id});
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          showToast(msg: "Applied Successfully!");

/*        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AllApplicants(),
          ),
              (route) => false,
        );*/
          //  Get.offAndToNamed(AppRoute.homeMasterRoute);
        });

        getJobDataInList(token, true);
        Get.find<HomeController>().getAppliedJobsList(token);
        Get.back();
        update();
      }
      update();
    }
  }
  applyJobPopUp(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
     // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content:
            Text(
                        'Are you sure you are applying to the city and state you live in?',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),






          
          actions: <Widget>[
         Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Container(
         width: 100,
                  child: CustomButton(
                          onTap: () {
                            //    deleteNoticeData(accessToken, userId, context, id);
                            Get.back();

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CreateContractTemplate()),
                            // );
                          },
                    title: "No",
                          textColor: AppColors.green,
                          btnColor: Colors.white,

                        ),
                ),

                  Container(
                    width: 100,
                    child:  CustomButton(
                        onTap: () async{
                          //    deleteNoticeData(accessToken, userId, context, id);


                          await applyOnJob(context,id);
                          Get.back();


                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => CreateContractTemplate()),
                          // );
                        },
                      title: "Yes",
                        textColor: Colors.white,
                        btnColor: AppColors.green,
                      ),
                  )
                ],
              ),
            SizedBox(height: 20,),

          ],
        );
      },
    );
  }
}
