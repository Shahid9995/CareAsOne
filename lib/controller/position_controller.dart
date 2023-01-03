import 'package:get/get.dart';
class PositionController extends GetxController {
  bool nursingCheckbox = true;
  bool practicalNurse=false;
  bool directSupport=false;
  bool homeHealthAid=false;
  bool caregiver=false;
  bool medicalTech=false;
  bool regNurse=false;
  String positions = "Certified Nursing Assistant";
  String position1 = "";
  String position2 = "";
  String position3 = "";
  String position4 = "";
  String position5 = "";
  String position6 = "";

  @override
  void onInit() {
    nursingCheckbox = true;
    practicalNurse = false;
    directSupport = false;
    homeHealthAid = false;
    caregiver = false;
    medicalTech = false;
    regNurse = false;
    super.onInit();
  }
}
