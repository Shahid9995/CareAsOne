
import 'package:careAsOne/controller/Employeer/employer_mesage_controller.dart';
import 'package:get/get.dart';

class EmpMessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EmployerMessagesController>(EmployerMessagesController(), permanent: true);
  }
}