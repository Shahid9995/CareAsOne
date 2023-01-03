import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/Employeer/manage_emp.dart';
import 'package:careAsOne/model/employees.dart';
import 'package:careAsOne/services/get_employee.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class EmpEditEmployeeController extends GetxController {
  Employees? employees;
  var status = "Enable";
  bool isLoading = false;
  var token;
  File? file;
  var image;
  final picker = ImagePicker();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController totalSalary = TextEditingController();
  TextEditingController empFName = TextEditingController();
  TextEditingController empLName = TextEditingController();
  final employeeService = Get.find<EmployeeService>();
  final storage = GetStorage();

  @override
  void onInit() {

    if (Get.arguments != null) {
      token = storage.read("authToken");
      employees = Get.arguments["empData"];
      jobTitle.text = employees!.jobTitle.toString();
      email.text = employees!.email.toString();
      totalSalary.text = employees!.salary.toString();
      empFName.text = employees!.name.toString().split(" ")[0];
       empLName.text = employees!.lastName.toString();
      status = employees!.status == 1 ? "Enable" : "Disable";
    }

    employeeService.getEmployess(token);
    super.onInit();
  }

  //final homeMaster = Get.find<HomeMasterController>();

  Future<void> updateEmployee(BuildContext context, Map<String, dynamic> body,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    Dio dio =new Dio();
    try {
      Response response = await dio.post(
          "${BaseApi.domainName}api/employer/employees/update",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}),
          data: body);

      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 2)).then((value) async {
          showToast(msg: 'Employee Updated');

        });


        Get.find<ManageEmployeesController>().update();
        Get.find<ManageEmployeesController>().getEmpList();
        update();
        Get.back();
        isLoading = false;
        update();

        //     Get.find<ManageEmployeesController>().update();
// Get.find<ManageEmployeesController>().update();

        update();

        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
      }
    }on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
  }
  Future openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      file = File(pickedFile.path);
      update();
    } else {
    }
  }
}
