import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/employees.dart';
import 'package:careAsOne/services/get_employee.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ManageEmployeesController extends GetxController {
  List<Employees>? employeesList;
  List<Employees> searchedList=[];
  String employeesName="";
  List<Employees> employeeList=[];
  List<Employees>? responseBody;
  List empList = [];
  final storage = GetStorage();
  var token;
  bool isLoading = true;
  bool selectAll = false;
  List id = [];
  bool empSelect = false;

  final homeMaster = Get.find<HomeMasterController>();
  final employeeService = Get.find<EmployeeService>();

  @override
  void onInit() async {
    isLoading = true;
  update();
    token = storage.read("authToken");
await getEmpList();

    isLoading = false;
    update();
    super.onInit();
  }
getEmpList()async{
  employeesList = await employeeService.getEmployess(token);
  update();
}
  Future<void> deleteJob(BuildContext context, idList,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    update();
    Map<String, dynamic> responseBody;
    try {
      var headers = {'Accept': 'application/json'};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${BaseApi
                  .domainName}api/employer/employees/delete?api_token=$token'));
      request.fields.addAll({'id[]': id[0].toString()});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        id = [];
        employeesList = await getEmployess(token);
        update();
        Get.back();
        isLoading = false;
        update();
      } else {
        Get.back();
        isLoading = false;
        update();
      }
    }catch(e){
      showToast(msg: "ERROR");
    }
  }

  Future showSelectionDialog(BuildContext context, List idList) {
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
                        "Do you want to Delete Employee?",
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
                              await deleteJob(context, idList);
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
 getEmployess(
      token,
      ) async {
    responseBody = [];
    employeeList = [];
    empList = [];
    Response? response = await BaseApi.get(
        url: 'employer/employees', params: {"api_token": token});
    if (response!.statusCode == 200) {
      // remainPostJob = response.data["remaining_post_jobs"];
      if (response != null) {
        response.data["data"].forEach((element) {
          responseBody!.add(Employees.fromJson(element));
        });
        employeeList = responseBody!;
        employeeList.forEach((element) {
          empList.add(element.name);
        });
      }
    } else if (responseBody != null) {
    } else {
    }
    return employeeList;
  }
}
