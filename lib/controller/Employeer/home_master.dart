
import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/employer_mesage_controller.dart';
import 'package:careAsOne/model/all_sticky_model.dart';
import 'package:careAsOne/model/company_profile.dart';
import 'package:careAsOne/model/dashboard.dart';
import 'package:careAsOne/model/emp_profile.dart';
import 'package:careAsOne/model/employer_message_model.dart';
import 'package:careAsOne/model/plans.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/subscription.dart';
import 'package:careAsOne/view/Employeer/all_applicants.dart';
import 'package:careAsOne/view/Employeer/company_setting.dart';
import 'package:careAsOne/view/Employeer/documents/documents.dart';
import 'package:careAsOne/view/Employeer/emp_manage.dart';
import 'package:careAsOne/view/Employeer/homepage.dart';
import 'package:careAsOne/view/Employeer/profile_setting.dart';
import 'package:careAsOne/view/Employeer/subscription_details.dart';
import 'package:careAsOne/view/Employeer/training_videos.dart';
import 'package:careAsOne/view/Employeer/video_interview.dart';
import 'package:careAsOne/view/job_seeker/verify_email.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart'hide Response;
import 'package:get_storage/get_storage.dart';

import '../../view/new_feed/maintab.dart';

class HomeMasterController extends GetxController {
  int currentPage=1;
  var plan = "";
  var token;
  var count = 0;
  var newMessageCount;
  String documentAddon = '';
  String trainingAddon = '';
  bool isLoading = true;
  List<PlanModel> plansList=[];
  final noteKey = new GlobalKey<FormState>();
  List<PlanModel> responseBody=[];
  TextEditingController noteController = TextEditingController();
  StickyNotesModel stickyNotesModel = StickyNotesModel();
  List<StickyNotes> stickyNote = [];
  List colorsData = [
    AppColors.successColor,
    AppColors.dangerColor,
    AppColors.oceanBlue,
    AppColors.warningColor,
    AppColors.purpleColor,


  ];
  int selectedColor = 0;
  Color? newColor;
  GetStorage storage = GetStorage();
  var data = Get.arguments;
  EmpProfileModel? empProfileModel;
  EmpDashboardModel empDashboardModel = new EmpDashboardModel();
  List<PlanModel> planModelList = [];
  CompanyProfile? companyProfile;
  List<EmployeeList>? empList;
  List<EmployeeList>? empListData;
  List<UserJob>? userJobList;
  List<Application>? listElement;
  List<Application>? listElementData;
  List<UserJob>? userJobData;
  List<Message>? employerMessages;
  List<Message>? messageList;
  List<EmployeeList>? employeeList;
  List<EmployeeList>? employeeData;
  var jobTitle;
  var title = [];
  var messagesForIndex = [];
  var index;
  var receivedMessageCount = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final myProfile = Get.find<ProfileService>();
  final authService = Get.find<AuthService>();
  final subScriptionService = Get.find<SubscriptionService>();


  final List<Widget> pages = [
    EmpHomePage(),
    VideoInterview(),
    ManageEmployees(),
    EmpDocumentsPage(),
    AllApplicants(),
    TrainingVideo(),
    SubscriptionDetails(),
    EmpHomePage(),
    EmpProfilePage(),
    CompanyProfilePage(),
    MainTab(),
  ];

  @override
  void onInit() async {
    print("====HomeMasterController======");
    isLoading = true;
  update();
    token = storage.read("authToken");
    print("===token:$token=======");
    newMessageCount = 0;
    await getAllStickyNotes(token);
    empDashboardModel = await getDashboardData(token);
    planModelList = await getSubscription(token);
    companyProfile = await myProfile.getCompanyProfileData(token);
    await getMessageCounterData(token);
    plan = storage.read("plan");
    update();
   empProfileModel = await myProfile.getUserData(token);
    checkCompanyProfile();
    super.onInit();
  }
  Stream getCounter(Duration refreshTime)async*{
    while(true){
      await Future.delayed(refreshTime);
      yield await getMessageCounterData(token);
    }
  }
  hello() {
    if (plan == 'subscriptions') {
      currentPage = 0;
      update();
    } else {
      currentPage = 6;
      update();
    }
  }

  checkCompanyProfile() {
    if (empProfileModel!.verifiedAt == null) {
      Get.to(() => VerifyEmailPage());
    }
    else if (plan == 'plans') {
      currentPage = 6;
      showToast(msg: "Please complete these steps to move forward.");
      isLoading = false;
      update();
    } else {
      currentPage = 0;
      isLoading = false;
      update();
    }
  }
  void navigateToPage(int index) {
    currentPage = index;
    update();
    Get.back();
  }
  Future<List<PlanModel>> getSubscription(token,) async {
    responseBody = [];
    plansList = [];
    try {
      Response? response = await BaseApi.get(
          url: 'employer/subscriptions', params: {"api_token": token});
      if (response!.statusCode == 200) {
        if (response.data["plans"] == "plans") {
          plansList = [];
          response.data["data"].forEach((element) {
            responseBody.add(PlanModel.fromJson(element));
          });

          storage.write("plan", response.data["plans"]);
          var planing = storage.read("plan");
          plansList = responseBody;
        } else if (
            response.data["plans"] == "subscriptions") {
          storage.write("plan", response.data["plans"]);
          storage.write(
              "bought", response.data['data']['subscriptions']['name']);
          plansList = responseBody;
        }
      } else if (responseBody != null) {
      } else {
      }
    } on DioError  catch (ex) {
      if(ex.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
      //  showToast(msg: "ERROR");
      }
    }
    return plansList;
  }

  Future<dynamic> addColorDialog(context) async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Add Sticky Note',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) =>
                    Container(
                      child: Form(
                        key: noteKey,
                        child:
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                            children: [
                              Expanded(
                                  child: DecoratedInputField(
                                    name:"Note",
                                    text: "Note",
                                    maxLines: 6,
                                    controller: noteController,
                                    validations: (String? val) {
                                      if (val == "" || val == null) {
                                        return "Field is required";
                                      } else {
                                        return null;
                                      }
                                    },
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "PICK COLOR",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    child: Row(
                                      children: List.generate(
                                        colorsData.length,
                                            (index) => Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              children: <Widget>[
                                                new Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    colorsData.elementAt(index),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedColor = index;
                                                        newColor = colorsData
                                                            .elementAt(index);
                                                      });

                                                      update();
                                                    },
                                                    child: Icon(Icons.done,
                                                        color: index ==
                                                            selectedColor
                                                            ? Colors.white
                                                            : colorsData
                                                            .elementAt(index),
                                                        size: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )

                                  /* GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: colorsData.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, childAspectRatio: 1.0),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: Column(
                                    children: <Widget>[
                                      new Container(
                                        height:20,
                                        width:20,
                                        decoration:BoxDecoration( color:colorsData.elementAt(index),),
                                        child:InkWell(
                                        onTap: () {
                                          setState((){
                                            selectedColor = index;
                                            newColor = colorsData.elementAt(index);
                                          });

                                          update();
                                        },
                                        child: Icon(Icons.done,
                                            color: index == selectedColor
                                                ? Colors.white
                                                : colorsData.elementAt(index),
                                            size: 20),

                                        ),

                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),*/
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(AppColors.green)),
                        onPressed: () {
                          if (noteKey.currentState!.validate()) {
                            Get.back();
                            postNote(context,token);
                          }
                        },
                        child: Text("SAVE")),
                  )
                ],
              )
            ],
          );
        });
  }
  Future<dynamic> editColorDialog({required BuildContext context,required String note,required String color,required String id}) async {
    noteController.text=note;
    if(color=="#00c292"){
      selectedColor=0;
      newColor=colorsData[0];
    }else if(color=="#fb3a3a"){
      selectedColor=1;
      newColor=colorsData[1];
    }else if(color=="#02bec9"){
      selectedColor=2;
      newColor=colorsData[2];
    }else if(color=="#fec107"){
      selectedColor=3;
      newColor=colorsData[3];
    }else {
      selectedColor=4;
      newColor=colorsData[4];
    }

    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Edit Sticky Note',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) =>
                    Container(
                      child: Form(
                        key: noteKey,
                        child:
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                            children: [
                              Expanded(
                                  child: DecoratedInputField(
                                    name:"Note",
                                    text: "Note",
                                    maxLines: 6,
                                    controller: noteController,
                                    validations: (val) {
                                      if (val == "" || val == null) {
                                        return "Field is required";
                                      } else {
                                        return null;
                                      }
                                    },
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "PICK COLOR",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    child: Row(
                                      children: List.generate(
                                        colorsData.length,
                                            (index) => Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              children: <Widget>[
                                                new Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    colorsData.elementAt(index),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedColor = index;
                                                        newColor = colorsData
                                                            .elementAt(index);
                                                      });

                                                      update();
                                                    },
                                                    child: Icon(Icons.done,
                                                        color: index ==
                                                            selectedColor
                                                            ? Colors.white
                                                            : colorsData
                                                            .elementAt(index),
                                                        size: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )

                                  /* GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: colorsData.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, childAspectRatio: 1.0),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: Column(
                                    children: <Widget>[
                                      new Container(
                                        height:20,
                                        width:20,
                                        decoration:BoxDecoration( color:colorsData.elementAt(index),),
                                        child:InkWell(
                                        onTap: () {
                                          setState((){
                                            selectedColor = index;
                                            newColor = colorsData.elementAt(index);
                                          });

                                          update();
                                        },
                                        child: Icon(Icons.done,
                                            color: index == selectedColor
                                                ? Colors.white
                                                : colorsData.elementAt(index),
                                            size: 20),

                                        ),

                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),*/
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(AppColors.green)),
                        onPressed: () {
                          if (noteKey.currentState!.validate()) {
                            Get.back();
                            editNote(context,token,id);
                          }
                        },
                        child: Text("SAVE")),
                  )
                ],
              )
            ],
          );
        });
  }

  postNote(BuildContext context, token) async {
    CircularLoader().showAlert(context);
    var body = {
      "note": noteController.text,
      "color": newColor == AppColors.successColor
          ? "#00c292"
          : newColor == AppColors.dangerColor
          ? "#fb3a3a"
          : newColor == AppColors.oceanBlue
          ? "#02bec9"
          : newColor == AppColors.warningColor
          ? "#fec107"
          : "#fec107",
    };
    print(body);
    Dio dio = new Dio();
    try {
      Response response = await dio.post('${BaseApi.domainName}api/notes',
          queryParameters: {"api_token": token},

          options: Options(headers: {"Accept": "application/json"},), data: body);

      if (response.statusCode == 201) {
        print(response.data);
        noteController.clear();
        selectedColor=0;
        update();
        await getAllStickyNotes(token);
        Get.back();
        update();
        showToast(msg: "Saved");
        //  await getAvailability(token);
      } else {
        print(response.data);
        showToast(msg: "Something went wrong");
        Get.back();
      }

    }catch(e){
      if(e is DioError){
        print(e.response);
        print(e.message);
        if(e.message.contains("429")){
          //showToast(msg: "Too Many requests");
        }

      }

      Get.back();
      showToast(msg: "Something went wrong");
    }
  }
  editNote(BuildContext context,token,id) async {
    CircularLoader().showAlert(context);
    var body = {
      "note": noteController.text,
      "color": newColor == AppColors.successColor
          ? "#00c292"
          : newColor == AppColors.dangerColor
          ? "#fb3a3a"
          : newColor == AppColors.oceanBlue
          ? "#02bec9"
          : newColor == AppColors.warningColor
          ? "#fec107"
          : "#9675ce",
    };
    print(body);
    Dio dio = new Dio();
    try {
      Response response = await dio.put('${BaseApi.domainName}api/notes/$id',
          queryParameters: {"api_token": token},

          options: Options(headers: {"Accept": "application/json"},), data: body);

      if (response.statusCode == 201) {
        print(response.data);
        noteController.clear();
        selectedColor=0;
        update();
        Get.back();
        await getAllStickyNotes(token);
        Get.back();
        update();
        showToast(msg: "Saved");
        //  await getAvailability(token);
      } else {
        print(response.data);
        showToast(msg: "Something went wrong");
        Get.back();
      }

    }catch(e){
      if(e is DioError){
        print(e.response);
      }
      Get.back();
      showToast(msg: "Something went wrong");
    }
  }

  deleteNote(BuildContext context,token,id) async {
    CircularLoader().showAlert(context);
    var body = {
      "note": noteController.text,
      "color": newColor == AppColors.successColor
          ? "#00c292"
          : newColor == AppColors.dangerColor
          ? "#fb3a3a"
          : newColor == AppColors.oceanBlue
          ? "#02bec9"
          : newColor == AppColors.warningColor
          ? "#fec107"
          : "#fec107",
    };
    print(body);
    Dio dio = new Dio();
    try {
      Response response = await dio.delete('${BaseApi.domainName}api/notes/$id',
          queryParameters: {"api_token": token},

          options: Options(headers: {"Accept": "application/json"},));

      if (response.statusCode == 201) {
        print(response.data);


        Get.back();
        showToast(msg: "Note Deleted");
        Get.back();
        await getAllStickyNotes(token);

        update();

        //  await getAvailability(token);
      } else {
        print(response.data);
        showToast(msg: "Something went wrong");
      }

    }catch(e){
      if(e is DioError){
        print(e.response);
      }
      showToast(msg: "Something went wrong");
    }
  }
  getAllStickyNotes(token) async {
    stickyNote=[];
    Dio dio = new Dio();
    try {
      Response response = await dio.get('${BaseApi.domainName}api/notes',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        stickyNotesModel = StickyNotesModel.fromJson(response.data);
        stickyNote = stickyNotesModel.stickyNote!;
        update();
      } else {
        showToast(msg: "Something went wrong");
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response);
        print(e.error);
      }



      /*  if (e.response.statusCode == 401) {
        showToast(msg: "Session Expired Login Again.");
        authService.logOut();
      }*/
    }
  }

  Future<EmpDashboardModel> getDashboardData(token) async {
    Map<String, dynamic> responseBody;
    try {
      Response? response = await BaseApi.get(
          url: 'dashboard-employer', params: {"api_token": token});
      responseBody = response!.data;
      if (response.statusCode == 200) {
        empDashboardModel = EmpDashboardModel.fromJson(responseBody["data"]);
      } else {
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        showToast(msg: "Session Expired Login Again.");
        authService.logOut();
      }
    }
    return empDashboardModel;
  }
   getMessageCounterData(token) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        '${BaseApi.domainName}api/total-messages-count',
        queryParameters: {'api_token': token},
        options: Options(headers: {'Accept': 'application/json'}));
    if (response.statusCode == 200) {
      receivedMessageCount =response.data['unSeenMsgs'];
      update();
    }else{
    }
  }

}
