import 'package:careAsOne/view/routes/routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  GetStorage storage = GetStorage();

  @override
  void onInit() {
    navigateToLogin();
    super.onInit();
  }

  void navigateToLogin(){
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      if (storage.read("userId") == null) {
        Get.offAllNamed(AppRoute.loginRoute);
      }  else if (storage.read("userType") == "employer") {
        if(storage.read("verifiedAt")==null){
          Get.offAllNamed(AppRoute.verifyEmailPage);
        }else {
          Get.offAllNamed(AppRoute.empHomeMasterRoute);
        }
      } else {
        if(storage.read("verifiedAt")==null){
          Get.offAllNamed(AppRoute.verifyEmailPage);
        }
        else if(storage.read("preQuestion")=="null"){
          Get.offAllNamed(AppRoute.preQuestionnaireRoute);
        }else{
          Get.offAllNamed(AppRoute.homeMasterRoute);
        }

      }
      //   AnimatedNavigator().pushAndRemoveUntil(
      //       context: context,
      //       duration: Duration(seconds: 2),
      //       curve: Curves.elasticInOut,
      //       page: LoginPage());
      // }
    });
  }
}
