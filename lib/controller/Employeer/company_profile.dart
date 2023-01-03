import 'dart:async';
import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/company_profile.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class CompanyProfileController extends GetxController {

  CompanyProfile? companyProfileModel;
  var token;
  final storage = GetStorage();
  bool isLoading = false;
  File? file;
  var image;
  final picker = ImagePicker();

  final homeMaster = Get.find<HomeMasterController>();

  TextEditingController companyName = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contactFName = TextEditingController();
  TextEditingController contactLName = TextEditingController(text: "");
  TextEditingController contactPhone = TextEditingController();
  EmpProfileModel? empProfileModel;
  final myProfile=Get.find<ProfileService>();
String logo="";
  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;

    update();
    companyProfileModel = await getCompanyData(token);
    empProfileModel=await myProfile.getUserData(token);
    isLoading = false;
    update();

    super.onInit();
  }

  Future<CompanyProfile> getCompanyData(token) async {
    Map<String, dynamic> responseBody;
    try {
      Response? response =
      await BaseApi.get(url: 'company', params: {"api_token": token});
      responseBody = response!.data;
      print(responseBody.toString());
      if (response.statusCode == 200) {
        if (responseBody["data"] != null)
          companyProfileModel = CompanyProfile.fromJson(responseBody["data"]);
        print(companyProfileModel!.name);
        print(companyProfileModel!.contactPerson);
        print(companyProfileModel!.country);
        companyName.text = companyProfileModel!.name??"";
        zipCode.text = companyProfileModel!.zipcode??"";
        city.text = companyProfileModel!.city??"";
        state.text = companyProfileModel!.state??"";
        country.text = companyProfileModel!.country??"";
        address.text=companyProfileModel!.address==null?"":companyProfileModel!.address;
        contactFName.text =
            (companyProfileModel!.contactPerson ?? "".capitalizeFirst)!;
        contactLName.text =
            (companyProfileModel!.presonLastName ?? "".capitalizeFirst)!;
        contactPhone.text = companyProfileModel!.phoneNumber??"";
        image = companyProfileModel!.logo;
        isLoading = false;
        update();
        update();
      } else if (responseBody != null) {
      } else {
      }
    }on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }


    }
    return companyProfileModel!;
  }

  Future<void> updateCompany(BuildContext context, {dynamic params, id}) async {
    isLoading = true;
    update();
    Dio dio =new Dio();
    Response response=await dio.post("${BaseApi.domainName}/api/company/$id",
        queryParameters: {"api_token":token},
        options: Options(headers: {"Accept":"application/json"}),data: params);
    if(response.statusCode==200){
      showToast(msg: "Successfully Updated");
      Timer(Duration(seconds: 2), () {
        Get.back();
      });

      isLoading=false;
      update();

      

    }else{
      showToast(msg: 'Something went wrong');
      isLoading=false;
      update();
    }


   /* var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}/api/company/$id?api_token=$token'));
    request.fields.addAll({
      'name': companyName.text,
      'city': city.text,
      'state': state.text,
      'country': country.text,
      'zipcode': zipCode.text,
      'contact_person': contactFName.text,
      'phone_number': contactPhone.text,
      'preson_last_name': contactLName.text
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showToast(msg: 'Company Details Saved');
      isLoading=false;

      update();
    } else {
      print(response.reasonPhrase);
      showToast(msg: 'Something went wrong');
      isLoading=false;
      update();
    }*/
  }

  // Pic Image
  Future openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image=null;
      file = File(pickedFile.path);

      update();
    } else {
      print('No image selected.');
    }
    // Navigator.of(context).pop();
  }
}
