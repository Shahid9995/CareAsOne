import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/employees.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class EmployeeService extends GetxService {
  List<Employees>? employeesList;
  List<Employees>? responseBody;
  List empList = [];
  var authService = Get.find<AuthService>();
  Future<EmployeeService> init() async {
    return this;
  }

  Future<List<Employees>> getEmployess(
    token,
  ) async {
    responseBody = [];
    employeesList = [];
    empList = [];
    try {
      Response? response = await BaseApi.get(
          url: 'employer/employees', params: {"api_token": token});
      if (response!.statusCode == 200) {
        if (response != null) {
          response.data["data"].forEach((element) {
            responseBody!.add(Employees.fromJson(element));
          });
          employeesList = responseBody;
          employeesList!.forEach((element) {
            empList.add(element.name);
          });
          // Get.find<HomeMasterController>().getEmployerMessageData(token);
          // update();
        }
      } else if (responseBody != null) {
      } else {
      }
    }on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
        return employeesList!;
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }

    }
    return employeesList!;
  }
}
