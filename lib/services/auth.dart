import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final storage = GetStorage();
var token;
  Future<AuthService> init() async {
    return this;
  }

  void logOut() async {
    token=storage.read("authToken");
try {
  Dio dio = new Dio();
  Response response = await dio.post("${BaseApi.domainName}api/logout",
      queryParameters: {'api_token': "$token"});
  if (response.statusCode == 200) {
    await storage.erase();
    Get.offAllNamed(AppRoute.loginRoute);
  } else {
    await storage.erase();
    Get.offAllNamed(AppRoute.loginRoute);
    showToast(msg: "Error");
  }
}catch(e){
  await storage.erase();
  Get.offAllNamed(AppRoute.loginRoute);
}

  }
}
