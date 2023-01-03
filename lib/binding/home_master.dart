import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:get/get.dart';

class EmpHomeMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeMasterController>(HomeMasterController(), permanent: true);
  }
}