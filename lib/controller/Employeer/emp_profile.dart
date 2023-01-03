import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'home_master.dart';


class EmpProfileController extends GetxController {
  EmpProfileModel? empProfileModel;
  var token;
  var gender;
  bool isLoading = false;
  bool genderType = false;
  final storage = GetStorage();
  String? genderRadioBtnVal;
  File? file;
  var image;
  final picker = ImagePicker();
  final homeMaster = Get.find<HomeMasterController>();
  final myProfile = Get.find<ProfileService>();

  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController contact = TextEditingController();

  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;
    update();
    empProfileModel = await myProfile.getUserData(token);
    await updateData();
    isLoading = false;
    update();


    super.onInit();
  }

  void handleGenderChange(String value) {
    genderRadioBtnVal = value;
    update();
  }

  void updateProfile(BuildContext context, {dynamic params}) async {
CircularLoader().showAlert(context);

    Dio dio =new Dio();
    try {
      Response response = await dio.post(
          "${BaseApi.domainName}api/employer/profile/save-profile",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}),
          data: params);
      if (response.statusCode == 200) {
        showToast(msg: "Updated Successfully.");
        Get.back();
      } else {
        showToast(msg: "Something Went Wrong");
      }
    }on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }


    }
  }

  updateData() async {
    empProfileModel = await myProfile.getUserData(token);
    fName.text = empProfileModel!.firstName.toString();
    lName.text = empProfileModel!.lastName.toString();
    email.text = empProfileModel!.email.toString();
    contact.text = empProfileModel!.phoneNumber.toString();
    if(empProfileModel!.dob!=null){
      dob.text = empProfileModel!.dob.toString().split(" ")[0];
    }else{
      dob.text="";
    }
    genderRadioBtnVal = empProfileModel!.gender.toString().capitalizeFirst;
    image = empProfileModel!.profileImage.toString();
    update();
  }

  Future<void> updateProfileImage(
    BuildContext context,
  ) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
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
    try {
      var headers = {'Accept': 'application/json'};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${BaseApi
                  .domainName}api/employer/profile/image-upload?api_token=$token'));
      request.files
          .add(await http.MultipartFile.fromPath('profile_image', file!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await updateData();
        update();
        // });
        Future.delayed(Duration(seconds: 2)).then((value) {
          showToast(msg: 'Updated Successfully.');
          // Get.offNamed(AppRoute.settingRoute);
        });
        Get.back();
        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
      }
    }catch (e) {

        showToast(msg: "ERROR");



    }
  }

   deleteProfile(context) async {
    isLoading = true;
    update();
try {
  final http.Response response = await http.delete(
    Uri.parse(
      '${BaseApi.fullUrl(
          "employer/profile/image-delete")}?api_token=$token',
    ),
    headers: <String, String>{
      'Accept': 'application/json;',
    },
  );
  if (response.statusCode == 200) {

    await updateData();
    update();
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

  return response;
}catch(e){
  showToast(msg:"ERROR");
}
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

  // Pic Image
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
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.camera,imageQuality: 40,);

    if (pickedFile != null) {
      file = File(pickedFile.path);
      await updateProfileImage(context);
      update();
    } else {
    }

  }

}

