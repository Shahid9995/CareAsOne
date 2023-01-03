import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/applicant_view_model.dart';
import 'package:careAsOne/model/company_profile.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/job_applicant.dart';
import 'package:careAsOne/model/overall_seeker_data.dart';
import 'package:careAsOne/model/seeker_employment_details.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class ProfileService extends GetxService {
  EmpProfileModel? empProfileModel;
  SeekerProfileModel? seekerProfileModel;
  AllJobSeekerDetails? seekerDetails;
  EducationDetail? educationDetails;
  SeekerEmploymentDetails? seekerEmploymentDetails;
  CompanyDetail? companyDetail;
  CompanyProfile companyProfile=CompanyProfile();
  Datam? data;

  var authService = Get.find<AuthService>();

  Future<ProfileService> init() async {
    return this;
  }

  Future<EmpProfileModel> getUserData(token) async {
    Map<String, dynamic> responseBody;
    try {
      Response? response =
          await BaseApi.get(url: 'user', params: {"api_token": token});
      responseBody = response!.data;
      if (response.statusCode == 200) {
        if (responseBody != null) {
          empProfileModel = EmpProfileModel.fromJson(responseBody);
        }
      } else if (responseBody != null) {
      } else {
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "Something went wrong");
        return empProfileModel!;
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }

    }
    return empProfileModel!;
  }

  Future<SeekerProfileModel> getSeekerData(token) async {
    Map<String, dynamic> responseBody;
    try {
      Response? response = await BaseApi.get(
          url: "job-seeker/profile", params: {"api_token": token});
      responseBody = response!.data['data']['user_record'];

      if (response.statusCode == 200) {
        if (responseBody != null) {
          seekerProfileModel = SeekerProfileModel.fromJson(responseBody);
        }
      } else if (responseBody != null) {

      } else {
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        //showToast(msg: "ERROR");
        return seekerProfileModel!;
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }

    }
    return seekerProfileModel!;
  }

  Future<AllJobSeekerDetails> getSeekerDetails(token) async {
    try {
      Map<String, dynamic> responseBody;
      Response? response = await BaseApi.get(
          url: "job-seeker/profile", params: {"api_token": token});
      responseBody = response!.data['data']['user_education_record'];
      if (response.statusCode == 200) {
        if (responseBody != null) {
          seekerDetails = AllJobSeekerDetails.fromJson(responseBody);
        }
      } else if (responseBody != null) {
      } else {
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
     //   showToast(msg: "ERROR");
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }


    }
    return seekerDetails!;
  }

  Future<SeekerEmploymentDetails> getCompanyDetails(token) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/profile',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        seekerEmploymentDetails = SeekerEmploymentDetails.fromJson(
            response.data['data']['user_employment_detail']);
      }
    }  on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
     //   showToast(msg: "ERROR");
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }


    }
    return seekerEmploymentDetails!;
  }

  Future<EducationDetail> getEducationDetails(token) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/profile',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        educationDetails = EducationDetail.fromJson(
            response
                .data['data']['user_employment_detail']['education_details']);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
       // showToast(msg: "ERROR");
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }


    }
    return educationDetails!;
  }

  Future<CompanyProfile> getCurrentUserCompany(token) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get("${BaseApi.domainName}api/company",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        companyProfile = CompanyProfile.fromJson(response.data['data']);
      }
      return companyProfile;
    }catch(e){
      return companyProfile;
    }
  }

  Future<Datam> getOverallData(token) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/profile',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        data = Datam.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
    //    showToast(msg: "ERROR");
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }


    }

    return data!;
  }

  Future<CompanyProfile> getCompanyProfileData(token) async {
    Map<String, dynamic> responseBody;
    try {
      Response? response =
          await BaseApi.get(url: 'company', params: {"api_token": token});
      responseBody = response!.data;
      if (response.statusCode == 200) {
        if (responseBody["data"] != "")
          companyProfile = CompanyProfile.fromJson(responseBody["data"]);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
     //   showToast(msg: "ERROR");
      }
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }

    }
    return companyProfile;
  }

}

