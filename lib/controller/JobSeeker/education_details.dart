import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/applicant_view_model.dart';
import 'package:careAsOne/model/seeker_employment_details.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class EducationDetailController extends GetxController {
  String dropdownValue = 'High School/Ged';
  bool isAccount = true;
  bool iswWork = false;
  var token;
  bool isEducation = false;
  bool gradBool=false;
  GetStorage storage = new GetStorage();
  SeekerProfileModel? applicant;
  AllJobSeekerDetails? jobSeekerDetails;
  EducationDetail? educationDetail;
  bool isLoading = false;
  TextEditingController majorDegree = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController universityName = TextEditingController();
  TextEditingController graduation = TextEditingController();

  @override
  Future<void> onInit() async {
    token = storage.read('authToken');
    isLoading = true;
    update();
    final myProfile = Get.find<ProfileService>();

    applicant = await myProfile.getSeekerData(token);

    jobSeekerDetails = await myProfile.getSeekerDetails(token);
    educationDetail = await myProfile.getEducationDetails(token);

    updateData();
    isLoading = false;
    update();
    super.onInit();
  }

  void saveEducationDetails(context, {Map<String, String>? body}) async {
    isLoading = true;
    update();
    CircularLoader().showAlert(context);
    var headers = {
      'Accept': 'application/json',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}api/job-seeker/education?api_token=$token'));
    request.fields.addAll(body!
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: "Updated Successfully.");
      });
      Get.back();
      await Get.find<HomeController>().getOverallData(token);
      update();
      await refreshData();
      updateData();
      isLoading = false;
      update();
    } else {
    }
  }

  updateData() {
    isLoading = true;
    update();
    dropdownValue = jobSeekerDetails!.highestQualification ?? "High School/Ged";
    if(educationDetail?.graduation!=null||educationDetail!=null){


      graduation.text=educationDetail!.graduation.toString().split(" ")[0];

    }else{
      graduation.text ="";
    }
    majorDegree.text = educationDetail!.majorDegree!;
    specialization.text = educationDetail!.specialization!;
    universityName.text = educationDetail!.university!;



    isLoading = false;
    update();
  }

  refreshData() async {
    isLoading=true;
    update();
    var myProfile = Get.find<ProfileService>();
    jobSeekerDetails = await myProfile.getSeekerDetails(token);
    educationDetail = await myProfile.getEducationDetails(token);
  }
}
