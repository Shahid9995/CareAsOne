import 'package:careAsOne/controller/Employeer/homepage.dart';
import 'package:get/get.dart';

class EmpHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EmpHomeController>(EmpHomeController(), permanent: true);
  }
}
