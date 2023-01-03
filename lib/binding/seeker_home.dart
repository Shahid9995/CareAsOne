
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:get/get.dart';

class HomeMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}