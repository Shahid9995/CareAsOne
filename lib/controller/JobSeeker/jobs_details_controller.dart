import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/job_details_model.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';

class JobsDetailsController extends GetxController {
  bool isLoading = false;
  var token;
  var data = Get.arguments;
  JobDetail? jobDetail;
  var keyWords;
  String city = "";
  var citiesNewList=[];
  var listValue = [];
  var keywordJson;
  var keywordList = [];
  List<Logo> logo = [];
  GetStorage getStorage = new GetStorage();
  final myProfile = Get.find<ProfileService>();
  SeekerProfileModel? seekerProfileModel;

  @override
  void onInit() async {
    isLoading = true;
    update();
    token = getStorage.read("authToken");
    seekerProfileModel = await myProfile.getSeekerData(token);
    await getAppliedJobsForView(token);
    isLoading = false;
    update();
    super.onInit();
  }

  Future<JobDetail> getAppliedJobsForView(token) async {
    Dio dio = new Dio();
    Response response = await dio.get(
        '${BaseApi.domainName}api/getJobDetailsForApi/${data[0]}',
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}));
    if (response.statusCode == 200) {
      jobDetail = JobDetail.fromJson(response.data["jobDetail"]);
      isLoading = false;
      update();
print(response.data);
      keyWords = jobDetail!.keywords;
      if (keyWords.contains('value')) {
        try {
          keywordJson = jsonDecode(keyWords);
          String keyWordVal = "";
          listValue = keywordJson as List;
          keywordList = [];
          for (int i = 0; i < listValue.length; i++) {
            keyWordVal = listValue[i]['value'] + " " + keyWordVal;
            jobDetail!.keywords = keyWordVal;
            keywordList.add("${listValue[i]['value']}");
            jobDetail!.keywords = keywordList.toString();
          }
        } catch (e) {}
        city = jobDetail!.city.toString();
        if (city.contains('value')) {
          var cityList = [];
          try {
            var parsedJson;
            parsedJson = jsonDecode(city);
            String cityJson = "";
            cityList = parsedJson as List;
            for (int i = 0; i < cityList.length; i++) {
              cityJson = "${(i+1!=cityList.length&&i+1<city.length)?",":" "}"+cityList[i]['value'] + "" + cityJson;
              jobDetail!.city = cityJson;
              citiesNewList.add("${cityList[i]['value']}");
              jobDetail!.city = citiesNewList.toString();
            }
            jobDetail!.city = cityJson;
          } catch (e) {}
        } else {
          jobDetail!.city = city;
        }
      } else {
        jobDetail!.keywords = keyWords;
      }
      response.data["logo"].forEach((e) {
        logo.add(Logo.fromJson(e));
      });
    }
    isLoading = false;
    update();
    return jobDetail!;
  }
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
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

                      CircularLoader().showAlert(context);
                      await applyOnJob(context, id);
                      Get.back();
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
   applyOnJob(BuildContext context,int id) async {



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
Get.back();
Get.find<HomeController>().getAppliedJobsList(token);
update();
Get.find<HomeController>().navigateToPage(1);
update();
        });

       // getJobDataInList(token, true);
        //await getAppliedJobsForView(token);
        update();
      }

    }


}
