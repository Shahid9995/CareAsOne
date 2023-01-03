import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/search.dart';
import 'package:careAsOne/model/all_sticky_model.dart';
import 'package:careAsOne/model/applicant_view_model.dart';
import 'package:careAsOne/model/applied_jobs.dart';
import 'package:careAsOne/model/job_applicant.dart';
import 'package:careAsOne/model/overall_seeker_data.dart';
import 'package:careAsOne/model/seeker_employment_details.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/view/applied_jobs.dart';
import 'package:careAsOne/view/availability/manage_availability.dart';
import 'package:careAsOne/view/documents/documents.dart';
import 'package:careAsOne/view/job_seeker/join_meeting/video_interview.dart';
import 'package:careAsOne/view/job_seeker/verify_email.dart';
import 'package:careAsOne/view/job_seeker/videos.dart';
import 'package:careAsOne/view/profile/setting/setting.dart';
import 'package:careAsOne/view/profile/setting/upload_resume.dart';
import 'package:careAsOne/view/search/search.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../view/new_feed/maintab.dart';

class HomeController extends GetxController {
  int currentPage=1;
  var token;
  bool isLoading = true;
  bool accountData = false;
  Applicant? applicant;
  String? availabilityValidation;
  SeekerProfileModel? seekerProfileModel;
  List colorsData = [
    AppColors.successColor,
    AppColors.dangerColor,
    AppColors.oceanBlue,
    AppColors.warningColor,
    AppColors.purpleColor,
  ];
  int selectedColor = 0;
  Color? newColor;
  SeekerEmploymentDetails? seekerEmploymentDetails;
  List<AppliedJobs> appliedJobList=[];
  List<AppliedJobs> responseData=[];
  var receivedMessageCount = 0;
  TextEditingController noteController = TextEditingController();
  var mondayList = [];
  Map<String, String> overallMap = {};
  final scaffoldKeyJobSeeker = new GlobalKey<ScaffoldState>();
  final noteKey = new GlobalKey<FormState>();
  final myProfile = Get.find<ProfileService>();
  Datam? data;
  AllJobSeekerDetails? jobSeekerDetails;
  StickyNotesModel stickyNotesModel = StickyNotesModel();
  List<StickyNotes> stickyNote = [];
  final authService = Get.find<AuthService>();
  GetStorage storage = GetStorage();
  final List<Widget> pages = [
    SearchPage(),
    AppliedJobsPage(),
    JoinVideoMeeting(),
    VideosPage(),
    DocumentsPage(),
    ProfileSettingPage(),
    ManageAvailability(),
    UploadResumePage(),
    MainTab(),
  ];
  static SearchController? controller;
  @override
  void onInit() async {
    isLoading = true;
    update();
    token = storage.read("authToken");
    await getAppliedJobsList(token);
    await getAllStickyNotes(token);
    jobSeekerDetails = await myProfile.getSeekerDetails(token);
    seekerEmploymentDetails = await myProfile.getCompanyDetails(token);
    data = await getOverallData(token);
    isLoading = true;
    update();
    seekerProfileModel = await myProfile.getSeekerData(token);
    if (seekerProfileModel!.emailVerifiedAt == null) {
      Get.to(() => VerifyEmailPage());
    } else {
      currentPage = 5;
    }
    getAllStickyNotes(token);
    await getAvailabilityNew(token);
    await getMessageCounterData(token);
    isLoading = false;
    update();
    super.onInit();
  }
  Stream getCounter(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getMessageCounterData(token);
    }
  }
  void navigateToPage(int index) {
    currentPage = index;
    update();
    Get.back();
  }
   getAppliedJobsList(token) async {
    appliedJobList = [];
    responseData = [];
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/jobs-applied',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        response.data['data'].forEach((e) {
          appliedJobList.add(AppliedJobs.fromJson(e));
        });
        responseData = appliedJobList;
        responseData.forEach((element) {});
      }
      update();
      return responseData;
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

  Future<Datam> getOverallData(token) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/profile',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      if (response.statusCode == 200) {
        data = Datam.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        showToast(msg: "Session Expired Logged Out");
        authService.logOut();
      }
    }
    return data!;
  }
  getMessageCounterData(token) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        '${BaseApi.domainName}api/total-messages-count',
        queryParameters: {'api_token': token},
        options: Options(headers: {'Accept': 'application/json'}));
    if (response.statusCode == 200) {
      receivedMessageCount = response.data['unSeenMsgs'];
      update();
    } else {}
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
                            postNote(token);
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
                            editNote(token,id);
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

  getAvailabilityNew(token) async {
    isLoading = true;
    update();
    try {
      Dio dio = Dio();
      var response = await dio.get(
          BaseApi.domainName + "api/job-seeker/get-availabilities-new",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseBody = response.data;
        availabilityValidation=responseBody["availability_date"];

        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
      }
    } catch (e) {
      if (e is DioError) {
        isLoading = false;
        update();
        print(e.response);
        print(e.error);
      }
    }
  }

  postNote(token) async {
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
      update();
      showToast(msg: "Saved");
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
  editNote(token,id) async {
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
      update();
      showToast(msg: "Saved");
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

  deleteNote(token,id) async {
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
      await getAllStickyNotes(token);
      update();
      showToast(msg: "Note Deleted");
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

  void postAvailability(token) async {
    overallMap['availability[monday][0][from]'] = "00:00";
    overallMap['availability[monday][0][from_time]'] = "AM";
    overallMap['availability[monday][0][to]'] = "00:00";
    overallMap['availability[monday][0][to_time]'] = "PM";

    overallMap['availability[tuesday][0][from]'] = "00:00";
    overallMap['availability[tuesday][0][from_time]'] = "AM";
    overallMap['availability[tuesday][0][to]'] = "00:00";
    overallMap['availability[tuesday][0][to_time]'] = "PM";

    overallMap['availability[wednesday][0][from]'] = "00:00";
    overallMap['availability[wednesday][0][from_time]'] = "AM";
    overallMap['availability[wednesday][0][to]'] = "00:00";
    overallMap['availability[wednesday][0][to_time]'] = "PM";

    overallMap['availability[thursday][0][from]'] = "00:00";
    overallMap['availability[thursday][0][from_time]'] = "AM";
    overallMap['availability[thursday][0][to]'] = "00:00";
    overallMap['availability[thursday][0][to_time]'] = "PM";

    overallMap['availability[friday][0][from]'] = "00:00";
    overallMap['availability[friday][0][from_time]'] = "AM";
    overallMap['availability[friday][0][to]'] = "00:00";
    overallMap['availability[friday][0][to_time]'] = "PM";

    overallMap['availability[saturday][0][from]'] = "00:00";
    overallMap['availability[saturday][0][from_time]'] = "AM";
    overallMap['availability[saturday][0][to]'] = "00:00";
    overallMap['availability[saturday][0][to_time]'] = "PM";

    overallMap['availability[sunday][0][from]'] = "00:00";
    overallMap['availability[sunday][0][from_time]'] = "AM";
    overallMap['availability[sunday][0][to]'] = "00:00";
    overallMap['availability[sunday][0][to_time]'] = "PM";

    //Above Code Contain Mapping Solution For Availability

    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}/api/job-seeker/set-availability?api_token=$token'));
    request.fields.addAll(overallMap);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Saved");
    } else {
      print("Not Saved");
    }
  }
}
