import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/Employeer/homepage.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/plans.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/subscription.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;

class SubscriptionDetailController extends GetxController {
  var token;
  bool value1 = false;
  var plan = "";
  var data = Get.arguments;
  EmpHomeController? empHomeController;
  var cardNumberController = new TextEditingController();
  var cvcController = new TextEditingController();
  var exp = new TextEditingController();
  String monthDropDown = 'Jan';
  String yearDropDown = '2022';
  bool isLoading = false;
  final storage = GetStorage();
  bool? starterDocManage;
  bool? starterTrainingVideos;
  bool? mediumDocManage;
  bool? mediumTrainingVideos;
  bool? enterpriseDocManage;
  bool? enterpriseTrainingVideos;
  List<String> monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<PlanModel> planModelList = [];

  final subScriptionService = Get.find<SubscriptionService>();
  final myProfile = Get.find<ProfileService>();
  EmpProfileModel? empProfileModel;
  String mediumPlanNoAddOn = "medium";
  String starterPlanNoAddOn = "starter";
  String enterprisePlanNoAddOn = "enterprise";

  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;
    starterDocManage = false;
    starterTrainingVideos = false;
    mediumDocManage = false;
    mediumTrainingVideos = false;
    enterpriseDocManage = false;
    enterpriseTrainingVideos = false;
    update();
    empProfileModel = await myProfile.getUserData(token);
    planModelList = await subScriptionService.getSubscription(token);
    checkSubscription();
    isLoading = false;
    update();

    super.onInit();
  }

  checkSubscription() {
    plan = storage.read("plan");
    if (plan != "plans") {
    } else if (plan == "subscriptions") {
    }
  }

  Future<void> saveCardInformation(name, stripeId, cost) async {
    try {
      var headers = {
        'Accept': 'application/json'
      };
      var request = http.MultipartRequest('POST', Uri.parse('${BaseApi
          .domainName}api/employer/subscriptions/freeSubscription?api_token=$token'));
      request.fields.addAll({
        'plans': '$stripeId',
        'totalPrice': '$cost',
        'costId': '$name',
        'cardNumber': '${cardNumberController.text}',
        'cvv': '${cvcController.text}',
        'amount': '$cost',
        'expiration-month': '${monthList.indexOf(monthDropDown) + 1}',
        'expiration-year': '$yearDropDown'
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          showToast(msg: "Successfully Purchased");


          Get.offAllNamed(AppRoute.empHomeMasterRoute);
        });
      }
      else {
      }
    }catch(e){
      showToast(msg: "ERROR");
    }
  }

}
