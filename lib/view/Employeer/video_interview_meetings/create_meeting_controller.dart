import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/company_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart'hide Response;
import 'package:get_storage/get_storage.dart';
class CreateMeetingController extends GetxController{
  CompanyProfile? companyProfile;
  var token;
  var data=Get.arguments;
  GetStorage storage=new GetStorage();
  final company=Get.find<ProfileService>();
  @override
  void onInit() async{
    token=storage.read("authToken");
  companyProfile=await company.getCompanyProfileData(token);
    super.onInit();

  }
  sendInvitation(String meetingId)async{
    print(data[0]);
    print(companyProfile!.name);
    print(meetingId);
    Dio dio=new Dio();
    try {
      Response response = await dio.post(
          "${BaseApi.domainName}api/jobs/meeting/invitation",
          queryParameters: {"api_token": token},
          data: {"email": data[0],
            "company_name": companyProfile!.name, "meeting_id": meetingId});
      if (response.statusCode == 200) {
        showToast(msg: "Invitation email is sent");
      } else {

      }
    }catch(e){
      print(e);
      showToast(msg:"Error in Sending Email");
    }

  }
}