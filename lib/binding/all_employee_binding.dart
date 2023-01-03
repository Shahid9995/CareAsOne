
import 'package:careAsOne/controller/Employeer/manage_emp.dart';
import 'package:get/get.dart';
class AllEmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageEmployeesController>(() => ManageEmployeesController());
  }
}