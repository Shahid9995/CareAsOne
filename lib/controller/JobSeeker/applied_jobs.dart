import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/applied_jobs.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class AppliedJobsController extends GetxController {
  GetStorage storage = new GetStorage();
  final authService = Get.find<AuthService>();
  var token;
  final home = Get.find<HomeController>();
  List<AppliedJobs> appliedJobList=[];
  List<AppliedJobs> responseData=[];
  List<AppliedJobs> searchedList=[];
  String jobName="";
String dropdownValue="RECENT";
bool isRecent=false;
var reversedList=[];
  @override
  void onInit() {
    token = storage.read("authToken");
    getAppliedJobsList(token);
    update();
    super.onInit();
  }

  getAppliedJobsList(token) async {
    appliedJobList = [];
    responseData = [];
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/jobs-applied',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        response.data['data'].forEach((e) {
          appliedJobList.add(AppliedJobs.fromJson(e));
        });
        responseData = appliedJobList;
        responseData.forEach((element) {
        });
      }
      reversedList=[];
      if(dropdownValue=="RECENT"){
        isRecent=true;
        reversedList= responseData.reversed.toList();
      }
      update();
      return responseData;
    } on DioError catch (e) {



      if(e.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
        showToast(msg: "ERROR");
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Login Again.");
        authService.logOut();
      }
    }
  }

  void deleteAppliedJob(int id) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        '${BaseApi.domainName}/api/job-seeker/delete-applied-jobs/$id',
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}));
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showToast(msg: "Deleted Successfully");
      });

      await getAppliedJobsList(token);
      Get.find<HomeController>().getAppliedJobsList(token);
      update();
    }

  }
}
