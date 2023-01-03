import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/company_profile.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/jobs.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/user_job.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class AllApplicantsController extends GetxController {
  List<JobsModel> responseBody = [];
  final storage = GetStorage();
  var token;
  bool isLoading = true;
  int remainPostJob = 0;
  CompanyProfile? companyProfile;
  EmpProfileModel? empProfileModel;
  final homeMaster = Get.find<HomeMasterController>();
  final userJobService = Get.find<UserJobService>();
  final myProfile = Get.find<ProfileService>();

  @override
  void onInit() async {
    isLoading = true;
    update();
    token = storage.read("authToken");
    empProfileModel = await myProfile.getUserData(token);
    companyProfile=await myProfile.getCurrentUserCompany(token);
    await userJobService.getUserJob(token);
    isLoading = false;
    update();
    super.onInit();
  }
  Future<void> deleteJob(BuildContext context, postId,
      {Map<String, dynamic>? params}) async {
    print(token);
    CircularLoader().showAlert(context);
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    Response? response = await BaseApi.post(
        url: 'jobs/delete/$postId', params: {"api_token": token});
    if (response!.statusCode == 200) {

      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Job Deleted Successfully');
      });
      await userJobService.getUserJob(token);
      update();
      Get.back();
      Get.back();
      isLoading = false;
      update();
    } else {
      Get.back();
      isLoading = false;
      update();
      responseBody = response.data;
    }
  }

  Future showSelectionDialog(BuildContext context, postId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Do you want to Delete Job?",
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
                              await deleteJob(context, postId);
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
