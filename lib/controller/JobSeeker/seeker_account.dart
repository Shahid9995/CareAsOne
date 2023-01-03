import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class SeekerAccountController extends GetxController {
  bool isLoading = false;
  var token;

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController matchNewPassword = TextEditingController();
  File? file;
  var image;
  bool genderType = false;
  bool dobBool=false;
  bool genderBool=false;
  bool currentPasswordVisible = false;
  bool newPasswordVisible = false;
  bool matchPasswordVisible = false;
  SeekerProfileModel? applicant;
  String genderRadioBtnVal = "";
  final authService = Get.find<AuthService>();
  GetStorage storage = GetStorage();
  final homeMaster = Get.find<HomeController>();
  final myProfile = Get.find<ProfileService>();

  @override
  void onInit() async {
    token = storage.read("authToken");
    print(token);
    isLoading = true;
    update();
    applicant = await myProfile.getSeekerData(token);
    await updateData();
    isLoading = false;
    update();
    super.onInit();
  }

  void handleGenderChange(String? value) {
    genderRadioBtnVal = value!;
    genderBool=false;
    update();
  }

  Future<void> saveAccountDetails(BuildContext context,
      {Map<String, String>? body}) async {
    isLoading = true;
    update();
    CircularLoader().showAlert(context);
    Dio dio = new Dio();
    Response response = await dio.post(
        "${BaseApi.domainName}api/job-seeker/profile-save",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: body);
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 4)).then((value) {
        showToast(msg: "Updated Successfully.");
      });
      await Get.find<HomeController>().getOverallData(token);
      update();
      applicant = await myProfile.getSeekerData(token);
Get.back();
      isLoading = false;
      update();
    } else {
      showToast(msg: "Something went wrong.");
    }
  }

  Future<void> changePassword(BuildContext context,
      {Map<String, dynamic>? body}) async {
    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}api/job-seeker/change-password?api_token=$token'));
    request.fields.addAll({
      'current_password': currentPassword.text,
      'new_password': newPassword.text,
      'password_confirm': matchNewPassword.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      currentPassword.text = "";
      newPassword.text = "";
      matchNewPassword.text = "";
      showToast(msg: 'Password is changed successfully');
    } else {
      showToast(msg: 'Invalid password!');
    }
  }

  updateData() {
    isLoading = true;
    update();
    fName.text = applicant!.firstName.toString();
    lName.text = applicant!.lastName.toString();
    email.text = applicant!.email.toString();
    genderRadioBtnVal = applicant!.gender.toString().capitalizeFirst!;
    phone.text = applicant!.phoneNumber.toString();

    city.text = applicant!.city.toString();
    state.text = applicant!.state.toString();
    zipCode.text = applicant!.zipCode.toString();
    image = applicant!.profileImage.toString();
    if (applicant!.dob != null) {
      dob.text=applicant!.dob.toString().split(" ")[0];
    } else {
      dob.text = "dd/mm/yyyy";
    }
    isLoading = false;
    update();
  }

  Future showSelectionDialog(BuildContext context, {isDelete = false}) {
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: !isDelete
                      ? ListBody(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                openCamera(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: AppColors.green,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Camera",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, color: AppColors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.image,
                                  color: AppColors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    openGallery(context);
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Gallery",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, color: AppColors.green),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : ListBody(
                          children: [
                            ListBody(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Do you want to Delete Image?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: AppColors.green),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          deleteProfile(context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ));
        });
  }
  Future openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      file = File(pickedFile.path);
      await updateProfileImage(context);
      update();
    } else {

    }
  }

  Future openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );

    if (pickedFile != null) {
      file = File(pickedFile.path);
      await updateProfileImage(context);
      update();
    } else {
    }

  }

  Future<void> updateProfileImage(
    BuildContext context,
  ) async {
    isLoading = true;
    update();

    String fileName = file!.path.split('/').last;
    FormData body = FormData.fromMap({
      "profile_image": await MultipartFile.fromFile(file!.path,
          filename: fileName, contentType: new MediaType("image", "png")
          // contentType: MediaType(
          //   "jpg",
          //   "png",
          // ),
          )
    });
    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}api/job-seeker/profile-image?api_token=$token'));
    request.files
        .add(await http.MultipartFile.fromPath('profile_image', file!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    Get.back();
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) async {
        showToast(msg: 'Updated Successfully.');
        applicant = await myProfile.getSeekerData(token);
        await updateData();
        update();
      });
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
      Get.back();
    }
  }

  Future<void> deleteProfile(context) async {
    Dio dio = new Dio();
    isLoading = true;
    update();
CircularLoader().showAlert(context);
    Response response = await dio.delete(
        "${BaseApi.domainName}api/job-seeker/delete-profile-image",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}));

    if (response.statusCode == 200) {
      await updateData();
      Get.back();
      update();
      // });
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: 'Deleted Successfully.');
      });
      image = null;
      Get.back();
      isLoading = false;
      update();
    } else {
      Get.back();
      isLoading = false;
      update();
      showToast(msg: "Something went wrong");
    }
  }
}
