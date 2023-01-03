import 'dart:async';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/model/plans.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class SubscriptionService extends GetxService {
  List<PlanModel> plansList=[];
  List<PlanModel> responseBody=[];
  GetStorage storage = GetStorage();

  Future<SubscriptionService> init() async {
    return this;
  }

  Future<List<PlanModel>> getSubscription(
    token,
  ) async {
    responseBody = [];
    plansList = [];
    Response? response = await BaseApi.get(
        url: 'employer/subscriptions', params: {"api_token": token});
    if (response!.statusCode == 200) {
      if (response != null && response.data["plans"] == "plans") {
        plansList = [];
        response.data["data"].forEach((element) {
          responseBody.add(PlanModel.fromJson(element));
        });

        storage.write("plan", response.data["plans"]);
        var planing = storage.read("plan");
        plansList = responseBody;
      } else if (response != null &&
          response.data["plans"] == "subscriptions") {
        storage.write("plan", response.data["plans"]);
        storage.write("bought", response.data['data']['subscriptions']['name']);
        plansList = responseBody;
      }
    } else if (responseBody != null) {
    } else {
    }
    return plansList;
  }
}
