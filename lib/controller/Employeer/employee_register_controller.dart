import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/emp_registration_errors.dart';
import 'package:careAsOne/model/employer_payment_plans.dart';
import 'package:careAsOne/view/auth_screens/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/auth_screens/register/employer_register/account.dart';
import '../../view/auth_screens/register/employer_register/card_information.dart';
import '../../view/auth_screens/register/employer_register/employer_plans.dart';

class EmployerRegisterController extends GetxController {
  String? planId;
  String? stripePlanId;
  String? costId;
  String? planType;
  String? amount;
  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;
  String? addressError;
  String? planError;
  String? holderNameError;
  String? cardNumberError;
  String? cvvError;
  int currentMonth=1;
  bool isLoading = false;
  bool isCheck = false;
  bool passwordVisible = false;
  bool confirmPassVisible = false;
  bool seekerVisible = false;
  bool confirmSeekerVisible = false;
  final formKey = GlobalKey<FormState>();
  EmployerErrors employerErrors=EmployerErrors();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController holderNameController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  String hintMonth="January";
  List<String> monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<MonthModel>monthModelList=[];
  List<String> yearList = ["2022", "2023", "2024", "2025", "2026", "2027"];
  String ?selectedMonth ="01";
  String selectedYear = "2022";
  String cvv = "";
  bool showBack = false;
  String holderName = "";
  String expireDate = "";
  String cardNumber = "";
  TextEditingController phone = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  EmployerPlans employerPlans = EmployerPlans();
  TextEditingController addressController = TextEditingController();
  List<Plans> plansList = [];
  List pages = [
    EmployerAccountScreen(),
    EmployerPlansScreen(),
    EmployerCardScreen()
  ];
  int currentPage = 0;
  @override
  void onInit() async {
    await getPlansInformation();
    monthModelList.add(MonthModel(monthDigit: "01",monthChar: "January"));
    monthModelList.add(MonthModel(monthDigit: "02",monthChar: "February"));
    monthModelList.add(MonthModel(monthDigit: "03",monthChar: "March"));
    monthModelList.add(MonthModel(monthDigit: "04",monthChar: "April"));
    monthModelList.add(MonthModel(monthDigit: "05",monthChar: "May"));
    monthModelList.add(MonthModel(monthDigit: "06",monthChar: "June"));
    monthModelList.add(MonthModel(monthDigit: "07",monthChar: "July"));
    monthModelList.add(MonthModel(monthDigit: "08",monthChar: "August"));
    monthModelList.add(MonthModel(monthDigit: "09",monthChar: "September"));
    monthModelList.add(MonthModel(monthDigit: "10",monthChar: "October"));
    monthModelList.add(MonthModel(monthDigit: "11",monthChar: "November"));
    monthModelList.add(MonthModel(monthDigit: "12",monthChar: "December"));
    // TODO: implement onInit
    super.onInit();
  }

  getPlansInformation() async {
    Dio dio = Dio();
    var headers = {"Accept": "application/json"};
    var response = await dio.get(BaseApi.domainName + "api/plan-details",
        options: Options(headers: headers));
    var responseBody = response.data;
    print(responseBody);
    if (response.statusCode == 200) {
      employerPlans = EmployerPlans.fromJson(responseBody);
      for (int i = 0; i < employerPlans.data!.length; i++) {
        if (employerPlans.data![i].id.toString() == "1" ||
            employerPlans.data![i].id.toString() == "7" ||
            employerPlans.data![i].id.toString() == "13") {
          plansList.add(employerPlans.data![i]);
          update();
        }
      }
    } else {
      showToast(msg: "Something went wrong");
    }
  }

  postEmployeeAllData() async {
    Dio dio = Dio();
    var headers = {"Accept": "application/json"};
    var body = {
      "first_name": firstName.text,
      "last_name": lastName.text,
      "email": email.text,
      "password": password.text,
      "password-confirmation": repeatPassword.text,
      "phone_number": phone.text,
      "address": addressController.text,
      "plan_type": planType.toString().toLowerCase(),
      "plan_id": stripePlanId,
      "costId": planType.toString().toLowerCase(),
      "cardName": holderNameController.text,
      "cardNumber": cardNumberController.text,
      "cvv": cvvController.text,
      "expiration-month": selectedMonth,
      "expiration-year": selectedYear,
      "totalPrice": amount,
      "amount": amount,


    };
    print(jsonEncode(body));
    try {
      var response = await dio.post(BaseApi.domainName + "api/emp-registerapi",
          options: Options(headers: headers), data: body);
      var responseBody = response.data;
      print(responseBody);
      if (response.statusCode == 200) {
        Get.offAll(() => LoginPage());
      } else {
        showToast(msg: "Something went wrong");
      }
    }catch(e){
      if(e is DioError){
        print(e.message);
        print(e.response);
        print(e.error);
       if(e.response!.data!=null){
         employerErrors=EmployerErrors.fromJson(e.response!.data);
         if(employerErrors.errors!["first_name"]!=null) {
           firstNameError = employerErrors.errors!["first_name"]![0];
         }else{
           firstNameError=null;
         }
         if(employerErrors.errors!["last_name"]!=null) {
           lastNameError = employerErrors.errors!["last_name"]![0];
         }else{
           lastNameError=null;
         }
         if(employerErrors.errors!["email"]!=null) {
           emailError = employerErrors.errors!["email"]![0];
         }else{
           emailError=null;
         }
         if(employerErrors.errors!["password"]!=null) {
           passwordError = employerErrors.errors!["password"]![0];
         }else{
           passwordError=null;
         }
         if(employerErrors.errors!["password-confirmation"]!=null) {
           confirmPasswordError =
           employerErrors.errors!["password-confirmation"]![0];
         }else{
           confirmPasswordError=null;
         }
         if(employerErrors.errors!["phone_number"]!=null) {
           phoneError = employerErrors.errors!["phone_number"]![0];
         }else{
           phoneError=null;
         }
         if(employerErrors.errors!["address"]!=null) {
           addressError = employerErrors.errors!["address"]![0];
         }else{
           addressError=null;
         }
         if(employerErrors.errors!["plan_type"]!=null) {
           planError = employerErrors.errors!["plan_type"]![0];
         }else{
           planError=null;
         }
         if(employerErrors.errors!["cardName"]!=null) {
           holderNameError = employerErrors.errors!["cardName"]![0];
         }else{
           holderNameError=null;
         }
         if(employerErrors.errors!["cardNumber"]!=null) {
           cardNumberError = employerErrors.errors!["cardNumber"]![0];
         }else{
           cardNumberError=null;
         }
         if(employerErrors.errors!["cvv"]!=null) {
           cvvError = employerErrors.errors!["cvv"]![0];
         }else{
           cvvError=null;
         }
         update();
         showToast(msg: "Please make sure provided information is valid",backgroundColor: Colors.red);

       }

      }
    }
  }
}
class MonthModel{
  String? monthDigit;
  String? monthChar;
  MonthModel({this.monthDigit,this.monthChar});

}