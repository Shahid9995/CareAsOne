import 'package:careAsOne/controller/Employeer/all_applicants.dart';
import 'package:get/get.dart';

class AllApplicantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllApplicantsController>(() => AllApplicantsController());
  }
}
