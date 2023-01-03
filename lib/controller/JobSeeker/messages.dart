import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/jobseeker_message.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class MessagesController extends GetxController {
  var token;
  GetStorage storage = new GetStorage();
  List<CompanyApplicant> msgList=[];
  List<CompanyApplicant> responseData=[];
  bool isLoading=true;
  List<AllMessageJob>? jobApplicantList;
  List<AllMessageJob>? jobApplicantData;
  SeekerProfileModel? seekerProfileModel;
  final myProfile = Get.find<ProfileService>();

  @override
  Future<void> onInit() async {
    isLoading=true;
    update();
    responseData = [];

    jobApplicantData = [];

    token = storage.read("authToken");
    seekerProfileModel = await myProfile.getSeekerData(token);
    await getAllMessages(token);
    isLoading=false;
    update();
    super.onInit();
  }

  Future<List<CompanyApplicant>> getAllMessages(token) async {
    msgList = [];
    jobApplicantList = [];
    responseData = [];
    jobApplicantData = [];
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/message-list',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        response.data['data']['companyApplicants'].forEach((e) {
          msgList.add(CompanyApplicant.fromJson(e));
          responseData = msgList;
        });
        responseData.forEach((element) {
        });
        update();
      }
    } on DioError catch (e) {
      if(e.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
isLoading=false;
update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
}
