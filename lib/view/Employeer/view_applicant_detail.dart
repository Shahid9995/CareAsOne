import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/view_applicant_detail.dart';
import 'package:careAsOne/view/Employeer/employer_message.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewApplicantDetail extends StatefulWidget {
  @override
  _ViewApplicantDetailState createState() => _ViewApplicantDetailState();
}

final Dio _dio = Dio();

String _progress = "-";

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final android = AndroidInitializationSettings('@mipmap/ic_launcher');
var iOSInitialize = const DarwinInitializationSettings();
final initSettings = InitializationSettings(android: android, iOS: iOSInitialize);

class _ViewApplicantDetailState extends State<ViewApplicantDetail> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    super.initState();
  }
  _onSelectNotification(savePath) {
    OpenFile.open(savePath);
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails('channel id', 'channel name',
        priority: Priority.high, importance: Importance.max);
    const iOS = DarwinNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getApplicationDocumentsDirectory();
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions(Permission permission) async {
    final status = await permission.request();
    return permission == PermissionStatus.granted;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> _startDownload(String savePath, String downloadUrl) async {
    CircularLoader().showAlert(context);
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(downloadUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      flutterLocalNotificationsPlugin.initialize(initSettings,
         onDidReceiveBackgroundNotificationResponse: _onSelectNotification(savePath));
      Get.back();
      await _showNotification(result);
      OpenFile.open(savePath);
      result.clear();
    }
  }

  Future<void> _download(String downloadUrl, String name) async {
    showToast(msg: "Download started ...");
    var dir;
    if (Platform.isAndroid) {
      dir = '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      dir = (await getTemporaryDirectory()).path;
    }
    final isPermissionStatusGranted =
        await _requestPermissions(Permission.storage);
    final savePath = '$dir' + '$name';
    await _startDownload(savePath, downloadUrl);
    if (isPermissionStatusGranted) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return GetBuilder<ViewApplicantDetailController>(
        init: ViewApplicantDetailController(),
        builder: (_) => Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColors.bgGreen,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              automaticallyImplyLeading: false,
              title: Container(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/images/playstore.png',
                      fit: BoxFit.fitWidth)),
              actions: [
                UnReadMsgIconButton(
                  onTap: () {
                    Get.to(() => EmployerMessage());
                  },
                  msgNumber: 0,
                ),
                InkWell(
                  onTap: () {
                    //  if(_.scaffoldKey.currentState.isDrawerOpen){
                    Get.back();
                    // }else{
                    //   _.scaffoldKey.currentState.openDrawer();
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.exit_to_app_rounded,
                        color: AppColors.green,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: _.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppColors.green,
                  ))
                : Container(
                    width: double.maxFinite,
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    margin: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: _.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.green)),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios,
                                              size: 16,
                                            ),
                                            Text("Back"),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    MainHeading('Application Details'),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                SubText("Personal Information",
                                    size: 20, color: AppColors.green),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: _.isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                              color: AppColors.green),
                                        )
                                      : Center(
                                          child: CircularCachedImage(
                                            radius: width / 8,
                                            imageUrl: _
                                                        .jobsInterviewModel!
                                                        .applicant!
                                                        .profileImageUrl !=
                                                    ""
                                                ? '${BaseApi.domainName}${_.jobsInterviewModel!.applicant!.profileImage}'
                                                : 'https://image.freepik.com/free-photo/front-view-man-with-straight-face_23-2148364723.jpg',
                                          ),
                                        ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                    child: SubText(
                                  "${_.jobsInterviewModel!.applicant!.firstName} ${_.jobsInterviewModel!.applicant!.lastName}",
                                  size: 17,
                                  fontWeight: FontWeight.bold,
                                )),
                                SizedBox(
                                  height: 10,
                                ),
                                _.jobsInterviewModel!.applicant!
                                            .jobSeekerDetails?.resume !=
                                        null
                                    ? CustomButton(
                                        title: "Download Resume".toUpperCase(),
                                        btnColor: Colors.white,
                                        textColor: AppColors.green,
                                        onTap: () async {
                                          await _requestPermissions(
                                              Permission.storage);
                                          String url =
                                              "${BaseApi.domainName}${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.resume}";

                                          var nameFile = url.substring(
                                              url.lastIndexOf("/") + 1);

                                          _download(url, nameFile);
                                        },
                                      )
                                    : SizedBox(),
                                SizedBox(height: 20),
                                /*         SubText("Job Seeker",
                              fontWeight: FontWeight.bold, size: 18),*/
                                /*           SizedBox(height: 15),
                          Row(children: [
                            Column(children: [
                              SubText(
                                "Job Title:".toUpperCase(),
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                "Current Company:".toUpperCase(),
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                "Location:".toUpperCase(),
                                color: Colors.grey,
                                size: 14,
                              ),          SubText(
                                "Email:".toUpperCase(),
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                "Phone:",
                                color: Colors.grey,
                                size: 14,
                              ),
                            ],),
                            Column(children: [
                              SubText(
                                _
                                    .jobsInterviewModel
                                    .applicant
                                    .jobSeekerDetails
                                    ?.companyDetails[0]
                                    .designation
                                    .toUpperCase(),
                                size: 12
                              ),
                              Expanded(
                                child: SubText(
                                  _
                                      .jobsInterviewModel
                                      .applicant
                                      .jobSeekerDetails
                                      ?.companyDetails[0]
                                      .company
                                      .toUpperCase(),
                                  size: 12
                                ),

                              ),
                              Expanded(
                                child: SubText(
                                  "${ _.jobsInterviewModel.applicant.jobSeekerDetails?.companyDetails[0].location}"
                                      .toUpperCase(),
                                  size: 12,

                                ),

                              ),
                              Expanded(
                                child: SubText(
                                  "${  _.jobsInterviewModel.applicant.email}"
                                      .toUpperCase(),
                                  size: 12
                                ),
                              ),
                              Expanded(
                                child: SubText(
                                  "${_.jobsInterviewModel.applicant.phoneNumber}"
                                      .toUpperCase(),
                                  size:12
                                ),
                              ),
                            ],)
                          ],),*/
                                _.jobsInterviewModel!.applicant!
                                            .jobSeekerDetails!.companyDetails !=
                                        null
                                    ? Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubText(
                                              "Job Title:".toUpperCase(),
                                              color: Colors.grey,
                                              size: 14,
                                            ),
                                            SubText(
                                                _
                                                    .jobsInterviewModel!
                                                    .applicant!
                                                    .jobSeekerDetails!
                                                    .companyDetails![0]
                                                    .designation!
                                                    .toUpperCase(),
                                                size: 12),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubText(
                                              "Current Company:".toUpperCase(),
                                              color: Colors.grey,
                                              size: 14,
                                            ),
                                            SubText(
                                                _
                                                    .jobsInterviewModel!
                                                    .applicant!
                                                    .jobSeekerDetails!
                                                    .companyDetails![0]
                                                    .company!
                                                    .toUpperCase(),
                                                size: 12),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubText(
                                              "Location:".toUpperCase(),
                                              color: Colors.grey,
                                              size: 14,
                                            ),
                                            SubText(
                                                "${_.jobsInterviewModel!.applicant!.city!.toUpperCase()} | ${_.jobsInterviewModel!.applicant!.state!.toUpperCase()}",
                                                size: 12),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubText(
                                              "Email:".toUpperCase(),
                                              color: Colors.grey,
                                              size: 14,
                                            ),
                                            SubText(
                                                "${_.jobsInterviewModel!.applicant!.email}"
                                                    .toUpperCase(),
                                                size: 12),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubText(
                                              "Phone:",
                                              color: Colors.grey,
                                              size: 14,
                                            ),
                                            SubText(
                                                "${_.jobsInterviewModel!.applicant!.phoneNumber}"
                                                    .toUpperCase(),
                                                size: 12),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ])
                                    : SizedBox(),

                                _.showMore != true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 20,
                                      ),
                                SubText("Employment Details",
                                    size: 20, color: AppColors.green),
                                // SubText("Employment Details",
                                //     fontWeight: FontWeight.bold, size: 18),
                                SizedBox(height: 15),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SubText(
                                      "YEARS OF EXPERIENCE",
                                      color: Colors.grey,
                                      size: 14,
                                    ),
                                    SubText(
                                        "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.yearOfExperience}",
                                        size: 12),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SubText("Company Details",
                                    size: 15, color: AppColors.green),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails !=
                                            null &&
                                        _.showMore == true
                                    ? SizedBox()
                                    : SizedBox(height: 15),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails !=
                                            null &&
                                        _.showMore == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _
                                                          .jobsInterviewModel!
                                                          .applicant!
                                                          .jobSeekerDetails!
                                                          .companyDetails ==
                                                      null ||
                                                  _.showMore == true
                                              ? SizedBox()
                                              : SubText(
                                                  "Job Title:".toUpperCase(),
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                          _
                                                          .jobsInterviewModel!
                                                          .applicant!
                                                          .jobSeekerDetails!
                                                          .companyDetails ==
                                                      null &&
                                                  _.showMore != true
                                              ? SizedBox()
                                              : SubText(
                                                  _
                                                      .jobsInterviewModel!
                                                      .applicant!
                                                      .jobSeekerDetails!
                                                      .companyDetails![0]
                                                      .designation!
                                                      .toUpperCase(),
                                                  size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null &&
                                        _.showMore == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "Current Company:".toUpperCase(),
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          SubText(
                                              _
                                                  .jobsInterviewModel!
                                                  .applicant!
                                                  .jobSeekerDetails!
                                                  .companyDetails![0]
                                                  .company!
                                                  .toUpperCase(),
                                              size: 12),
                                        ],
                                      ),

                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "WORKING SINCE:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          SubText(
                                              _
                                                  .jobsInterviewModel!
                                                  .applicant!
                                                  .jobSeekerDetails!
                                                  .companyDetails![0]
                                                  .workingSince!
                                                  .split(" ")[0],
                                              size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "STATE:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          SubText(
                                              _
                                                  .jobsInterviewModel!
                                                  .applicant!
                                                  .jobSeekerDetails!
                                                  .companyDetails![0]
                                                  .state!,
                                              size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "CITY:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          SubText(
                                              "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.companyDetails![0].location}",
                                              size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "JOB DUTIES:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          SubText(
                                              _
                                                  .jobsInterviewModel!
                                                  .applicant!
                                                  .jobSeekerDetails!
                                                  .companyDetails![0]
                                                  .skills!,
                                              size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMore == true
                                    ? SizedBox()
                                    : CustomButton(
                                        textColor: AppColors.green,
                                        title: "MORE COMPANIES",
                                        btnColor: Colors.white,
                                        onTap: () {
                                          _.showMore = true;
                                          _.update();
                                        },
                                      ),

                                _.showMore
                                    ? Column(
                                        children: List.generate(
                                            _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails!
                                                .length, (index) {
                                          return Column(
                                            children: [
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "Job Title:".toUpperCase(),
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      _
                                                          .jobsInterviewModel!
                                                          .applicant!
                                                          .jobSeekerDetails!
                                                          .companyDetails![
                                                              index]
                                                          .designation!
                                                          .toUpperCase(),
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "Current Company:"
                                                        .toUpperCase(),
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      _
                                                          .jobsInterviewModel!
                                                          .applicant!
                                                          .jobSeekerDetails!
                                                          .companyDetails![
                                                              index]
                                                          .company!
                                                          .toUpperCase(),
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "WORKING SINCE:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      _
                                                          .jobsInterviewModel!
                                                          .applicant!
                                                          .jobSeekerDetails!
                                                          .companyDetails![
                                                              index]
                                                          .workingSince!
                                                          .split(" ")[0],
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "STATE:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      _
                                                          .jobsInterviewModel!
                                                          .applicant!
                                                          .jobSeekerDetails!
                                                          .companyDetails![
                                                              index]
                                                          .state!,
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "CITY:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.companyDetails![index].location}",
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "JOB DUTIES:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      _
                                                          .jobsInterviewModel!
                                                          .applicant!
                                                          .jobSeekerDetails!
                                                          .companyDetails![
                                                              index]
                                                          .skills!,
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              )
                                            ],
                                          );
                                        }),
                                      )
                                    : SizedBox(),
                                /*_.jobsInterviewModel.applicant.jobSeekerDetails
                                                .references ==
                                            null ||
                                        _.jobsInterviewModel.applicant
                                            .jobSeekerDetails.references.isEmpty
                                    ? SizedBox()
                                    : SizedBox(), */

                                SizedBox(
                                  height: 10,
                                ),
                                _.jobsInterviewModel!.applicant!
                                        .jobSeekerDetails!.references!.isEmpty
                                    ? SizedBox()
                                    : SubText(
                                        "References",
                                        color: AppColors.green,
                                        size: 15,
                                      ),
                                _.jobsInterviewModel!.applicant!
                                        .jobSeekerDetails!.references!.isEmpty
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 15,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length ==
                                            0 ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "COMPANY NAME:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          SubText(
                                              "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![0].companyName}",
                                              size: 12),
                                        ],
                                      ),
                                _.showMoreRef == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length ==
                                            0 ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "REFERRAL PERSON NAME:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          _
                                                      .jobsInterviewModel!
                                                      .applicant!
                                                      .jobSeekerDetails!
                                                      .references!
                                                      .length ==
                                                  0
                                              ? SubText("None")
                                              : SubText(
                                                  "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![0].referralPersonName}",
                                                  size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length ==
                                            0 ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length ==
                                            0 ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "PHONE NO:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          SubText(
                                              "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![0].phoneNo}",
                                              size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length ==
                                            0 ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length ==
                                            0 ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "EMAIL:",
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          _
                                                      .jobsInterviewModel!
                                                      .applicant!
                                                      .jobSeekerDetails!
                                                      .references!
                                                      .length ==
                                                  0
                                              ? SubText("None")
                                              : SubText(
                                                  "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![0].email}",
                                                  size: 12),
                                        ],
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .companyDetails ==
                                            null ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length ==
                                            0 ||
                                        _.showMoreRef == true
                                    ? SizedBox()
                                    : CustomButton(
                                        textColor: AppColors.green,
                                        title: "MORE REFERENCES",
                                        btnColor: Colors.white,
                                        onTap: () {
                                          _.showMoreRef = true;
                                          _.update();
                                        },
                                      ),

                                _.showMoreRef != true
                                    ? SizedBox()
                                    : Column(
                                        children: List.generate(
                                            _
                                                .jobsInterviewModel!
                                                .applicant!
                                                .jobSeekerDetails!
                                                .references!
                                                .length, (index) {
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "COMPANY NAME:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![index].companyName}",
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "REFERRAL PERSON NAME:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![index].referralPersonName}",
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "PHONE NO:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![index].phoneNo}",
                                                      size: 12),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SubText(
                                                    "EMAIL:",
                                                    color: Colors.grey,
                                                    size: 14,
                                                  ),
                                                  SubText(
                                                      "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.references![index].email}",
                                                      size: 12),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              )
                                            ],
                                          );
                                        }),
                                      ),

                                /*Expanded(
                                child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SubText(
                                          "References",
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        SizedBox(height: 15),

                                        Expanded(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                SubText(
                                                  "NAME OF PERSON:",
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                SubText(
                                                  _.jobsInterviewModel
                                                      .applicant
                                                      .jobSeekerDetails
                                                      ?.references[0]
                                                      .referralPersonName,
                                                  size: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(child:Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubText(
                                              "COMPANY NAME:",
                                              color: Colors.grey,
                                              size: 14,
                                            ),
                                            SubText(
                                             _.jobsInterviewModel
                                                  .applicant
                                                  .jobSeekerDetails
                                                  ?.references[0]
                                                  .companyName,
                                              size: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SubText(
                                                "PHONE NUMBER:",
                                                color: Colors.grey,
                                                size: 14,
                                              ),
                                              SubText(
                                               _.jobsInterviewModel
                                                    .applicant
                                                    .jobSeekerDetails
                                                    ?.references[0]
                                                    .phoneNo,
                                                size: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SubText(
                                                "EMAIL:",
                                                color: Colors.grey,
                                                size: 14,
                                              ),
                                              SubText(
                                                _.jobsInterviewModel
                                                    .applicant
                                                    .jobSeekerDetails
                                                    ?.references[0]
                                                    .email,
                                                size: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CustomButton(
                                          textColor: AppColors.green,
                                          title: "MORE COMPANIES",
                                          btnColor: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                              ),*/
                                SizedBox(height: 10),
                                SubText(
                                  "Education Details",
                                  color: AppColors.green,
                                  size: 15,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _
                                            .jobsInterviewModel!
                                            .applicant!
                                            .jobSeekerDetails!
                                            .highestQualification !=
                                        null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "HIGHEST QUALIFICATION",
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SubText(
                                            "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.highestQualification}",
                                            size: 12,
                                          ),
                                        ],
                                      )
                                    : SizedBox(),

                                SizedBox(height: 10),

                                _
                                            .jobsInterviewModel!
                                            .applicant!
                                            .jobSeekerDetails!
                                            .educationDetails !=
                                        null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "MAJOR:",
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SubText(
                                              "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.educationDetails!.majorDegree}",
                                              size: 12),
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                                _
                                            .jobsInterviewModel!
                                            .applicant!
                                            .jobSeekerDetails!
                                            .educationDetails !=
                                        null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "DEGREE:",
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SubText(
                                              "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.educationDetails?.specialization}",
                                              size: 12),
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                                _
                                            .jobsInterviewModel!
                                            .applicant!
                                            .jobSeekerDetails!
                                            .educationDetails !=
                                        null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "UNIVERSITY:",
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SubText(
                                              "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.educationDetails!.university}",
                                              size: 12),
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                                _
                                            .jobsInterviewModel!
                                            .applicant!
                                            .jobSeekerDetails!
                                            .educationDetails !=
                                        null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SubText(
                                            "YEAR OF GRADUATION:",
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SubText(
                                              "${_.jobsInterviewModel!.applicant!.jobSeekerDetails!.educationDetails!.graduation}",
                                              size: 12),
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 20,
                                ),

                                Row(
                                  children: [
                                    SubText(
                                      "Schedule an Interview",
                                      size: 16,
                                      color: AppColors.green,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                SubText(
                                  "SELECT DATE",
                                  size: 12,
                                ),
                                InkWell(
                                  onTap: () {
                                    _.selectInterviewDate(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    margin: EdgeInsets.only(top: 0),
                                    width: double.maxFinite,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.7)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SubText(
                                          _.interviewDate == null
                                              ? "Select Date"
                                              : DateFormat("MM-dd-y")
                                                  .format(_.interviewDate!)
                                                  .toString(),
                                          color: Colors.grey,
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                SubText(
                                  "SELECT TIME SLOT",
                                  size: 12,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  width: double.maxFinite,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            AppColors.black.withOpacity(0.7)),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _.selectedSlot,
                                    underline: SizedBox(),
                                    items: _.updatedSlot
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SubText(value, size: 12.0),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      _.selectedSlot = val;
                                      _.update();
                                    },
                                    hint: SubText(
                                        _.selectedSlot ?? "Select Time Slot",
                                        size: 12.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                SubText(
                                  "INTERVIEW TYPE",
                                  size: 12,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  width: double.maxFinite,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            AppColors.black.withOpacity(0.7)),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _.selectedInterviewType,
                                    underline: SizedBox(),
                                    items: _.interviewTypeList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SubText(value, size: 12.0),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      _.selectedInterviewType = val!;
                                      _.update();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomButton(
                                  onTap: () {
                                    if (_.interviewDate != null &&
                                        _.selectedSlot != null) {
                                      print(jsonEncode({
                                        "id":
                                            "${_.jobsInterviewModel!.applicantId}:${_.jobsModel!.id}",
                                        "date": DateFormat('MM-dd-y')
                                            .format(_.interviewDate!)
                                            .toString(),
                                        "schedule_time": _.selectedSlot,
                                        "schedule_type": _.selectedInterviewType
                                            .toLowerCase()
                                      }));
                                      //
                                      _.scheduleInterview(context, {
                                        "job_id": "${_.jobsModel!.id}",
                                        "applicant_id":
                                            "${_.jobsInterviewModel!.applicantId}",
                                        "date": DateFormat('MM-dd-y')
                                            .format(_.interviewDate!)
                                            .toString(),
                                        "schedule_time": _.selectedSlot,
                                        "schedule_type": _.selectedInterviewType
                                            .toLowerCase()
                                      });
                                    } else {
                                      showToast(
                                          msg: "Please Select Date & Time",
                                          backgroundColor: Colors.red);
                                    }
                                  },
                                  btnColor: AppColors.green,
                                  textColor: AppColors.white,
                                  title: "SAVE SCHEDULE",
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SubText(
                                      "Applicant's Preferred Availability",
                                      color: AppColors.green,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                _.jobSeekerAvailability.data == null
                                    ? SizedBox()
                                    : Column(
                                        children: List.generate(
                                          _.jobSeekerAvailability.data!.length,
                                          (index) => Column(
                                            children: [
                                              Card(
                                                elevation: 3.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: index.isOdd
                                                          ? Colors.white
                                                          : AppColors.bgGreen,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            SubText(
                                                              "Start",
                                                              color: AppColors
                                                                  .green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              size: 17,
                                                            ),
                                                            SubText(
                                                              "End",
                                                              color: AppColors
                                                                  .green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              size: 17,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            SubText(
                                                              _
                                                                  .jobSeekerAvailability
                                                                  .data![index]
                                                                  .startTime
                                                                  .toString(),
                                                              size: 17,
                                                            ),
                                                            SubText("-"),
                                                            SubText(
                                                              _
                                                                  .jobSeekerAvailability
                                                                  .data![index]
                                                                  .endTime
                                                                  .toString(),
                                                              size: 17,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children:
                                                                List.generate(
                                                              _
                                                                  .jobSeekerAvailability
                                                                  .data![index]
                                                                  .days!
                                                                  .length,
                                                              (index2) =>
                                                                  Center(
                                                                child: SubText(
                                                                  _
                                                                      .jobSeekerAvailability
                                                                      .data![
                                                                          index]
                                                                      .days![
                                                                          index2]
                                                                      .name!
                                                                      .substring(
                                                                          0, 3)
                                                                      .capitalizeFirst!,
                                                                  color:
                                                                      AppColors
                                                                          .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  size: 13,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: List.generate(
                                                              _
                                                                  .jobSeekerAvailability
                                                                  .data![index]
                                                                  .days!
                                                                  .length,
                                                              (index2) => Checkbox(
                                                                  value: _
                                                                      .jobSeekerAvailability
                                                                      .data![
                                                                          index]
                                                                      .days![
                                                                          index2]
                                                                      .jobSeekerDetails!
                                                                      .isNotEmpty,
                                                                  onChanged:
                                                                      (val) {})

                                                              /*  Container(
                                                          height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                                color: _.jobSeekerAvailability.data[index].days[index2].jobSeekerDetails.isNotEmpty?AppColors.green:Colors.red,
                                                              border:Border.all()

                                                            ),
                                                          child: Center(child: Icon(_.jobSeekerAvailability.data[index].days[index2].jobSeekerDetails.isNotEmpty?Icons.check:Icons.clear,size:17,color: Colors.white,)),
                                                        ),*/
                                                              ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                /*      _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Card(
                                        elevation: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SubText(
                                                    "Monday",
                                                    size: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  _
                                                              .jobsInterviewModel
                                                              .applicant
                                                              .jobSeekerDetails
                                                              .availability
                                                              .monday[0]
                                                              .from ==
                                                          "00:00"
                                                      ? SubText(
                                                          "Day Off",
                                                          size: 15,
                                                          color:
                                                              Colors.grey[400],
                                                        )
                                                      : SubText(
                                                          "Working Day",
                                                          size: 15,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    _
                                                        .jobsInterviewModel
                                                        .applicant
                                                        .jobSeekerDetails
                                                        .availability
                                                        .monday
                                                        .length, (index) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].fromTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].to} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].toTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            )

                                                            //Text("${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from}")
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Card(
                                        elevation: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SubText(
                                                    "Tuesday",
                                                    size: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  _
                                                              .jobsInterviewModel
                                                              .applicant
                                                              .jobSeekerDetails
                                                              .availability
                                                              .tuesday[0]
                                                              .from ==
                                                          "00:00"
                                                      ? SubText(
                                                          "Day Off",
                                                          size: 15,
                                                          color:
                                                              Colors.grey[400],
                                                        )
                                                      : SubText(
                                                          "Working Day",
                                                          size: 15,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    _
                                                        .jobsInterviewModel
                                                        .applicant
                                                        .jobSeekerDetails
                                                        .availability
                                                        .tuesday
                                                        .length, (index) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[index].from} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[index].fromTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[index].to} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[index].toTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            )

                                                            //Text("${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from}")
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Card(
                                        elevation: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SubText(
                                                    "Wednesday",
                                                    size: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  _
                                                              .jobsInterviewModel
                                                              .applicant
                                                              .jobSeekerDetails
                                                              .availability
                                                              .wednesday[0]
                                                              .from ==
                                                          "00:00"
                                                      ? SubText(
                                                          "Day Off",
                                                          size: 15,
                                                          color:
                                                              Colors.grey[400],
                                                        )
                                                      : SubText(
                                                          "Working Day",
                                                          size: 15,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    _
                                                        .jobsInterviewModel
                                                        .applicant
                                                        .jobSeekerDetails
                                                        .availability
                                                        .wednesday
                                                        .length, (index) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[index].from} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[index].fromTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[index].to} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[index].toTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            )

                                                            //Text("${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from}")
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Card(
                                        elevation: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SubText(
                                                    "Thursday",
                                                    size: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  _
                                                              .jobsInterviewModel
                                                              .applicant
                                                              .jobSeekerDetails
                                                              .availability
                                                              .thursday[0]
                                                              .from ==
                                                          "00:00"
                                                      ? SubText(
                                                          "Day Off",
                                                          size: 15,
                                                          color:
                                                              Colors.grey[400],
                                                        )
                                                      : SubText(
                                                          "Working Day",
                                                          size: 15,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    _
                                                        .jobsInterviewModel
                                                        .applicant
                                                        .jobSeekerDetails
                                                        .availability
                                                        .thursday
                                                        .length, (index) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[index].from} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[index].fromTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[index].to} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[index].toTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            )

                                                            //Text("${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from}")
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Card(
                                        elevation: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SubText(
                                                    "Friday",
                                                    size: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  _
                                                              .jobsInterviewModel
                                                              .applicant
                                                              .jobSeekerDetails
                                                              .availability
                                                              .friday[0]
                                                              .from ==
                                                          "00:00"
                                                      ? SubText(
                                                          "Day Off",
                                                          size: 15,
                                                          color:
                                                              Colors.grey[400],
                                                        )
                                                      : SubText(
                                                          "Working Day",
                                                          size: 15,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    _
                                                        .jobsInterviewModel
                                                        .applicant
                                                        .jobSeekerDetails
                                                        .availability
                                                        .friday
                                                        .length, (index) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[index].from} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[index].fromTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[index].to} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[index].toTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            )

                                                            //Text("${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from}")
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Card(
                                        elevation: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SubText(
                                                    "Saturday",
                                                    size: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  _
                                                              .jobsInterviewModel
                                                              .applicant
                                                              .jobSeekerDetails
                                                              .availability
                                                              .saturday[0]
                                                              .from ==
                                                          "00:00"
                                                      ? SubText(
                                                          "Day Off",
                                                          size: 15,
                                                          color:
                                                              Colors.grey[400],
                                                        )
                                                      : SubText(
                                                          "Working Day",
                                                          size: 15,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    _
                                                        .jobsInterviewModel
                                                        .applicant
                                                        .jobSeekerDetails
                                                        .availability
                                                        .saturday
                                                        .length, (index) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[index].from} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[index].fromTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[index].to} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[index].toTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            )

                                                            //Text("${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from}")
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Card(
                                        elevation: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SubText(
                                                    "Sunday",
                                                    size: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  _
                                                              .jobsInterviewModel
                                                              .applicant
                                                              .jobSeekerDetails
                                                              .availability
                                                              .sunday[0]
                                                              .from ==
                                                          "00:00"
                                                      ? SubText(
                                                          "Day Off",
                                                          size: 15,
                                                          color:
                                                              Colors.grey[400],
                                                        )
                                                      : SubText(
                                                          "Working Day",
                                                          size: 15,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    _
                                                        .jobsInterviewModel
                                                        .applicant
                                                        .jobSeekerDetails
                                                        .availability
                                                        .sunday
                                                        .length, (index) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[index].from} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[index].fromTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Row(
                                                                children: [
                                                                  SubText(
                                                                    "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[index].to} ${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[index].toTime.toString().split(".")[1]}",
                                                                    size: 20,
                                                                    color:
                                                                        Colors.grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            )

                                                            //Text("${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[index].from}")
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),*/

                                /*  _.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability ==
                                        null
                                    ? SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SubText(
                                            "Manage Availability",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SubText(
                                            "Monday",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          Text(_.jobsInterviewModel.applicant.jobSeekerDetails
                                            .availability.monday),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .monday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .monday ==
                                                      "00:00"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: SubText("Off Day",
                                                      color: Colors.grey,
                                                      colorOpacity: 0.4,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      size: 14),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: SubText(
                                                    "Working Day",
                                                    color: Colors.grey,
                                                    colorOpacity: 0.4,
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .monday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .monday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[0]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[0]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .monday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .monday[1] ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .monday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[1]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[1]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.monday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SubText(
                                            "Tuesday",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .tuesday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .tuesday ==
                                                      "00:00"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: SubText("Off Day",
                                                      color: Colors.grey,
                                                      colorOpacity: 0.4,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      size: 14),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: SubText(
                                                    "Working Day",
                                                    color: Colors.grey,
                                                    colorOpacity: 0.4,
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .tuesday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .tuesday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[0]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[0]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .tuesday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .tuesday[1] ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .tuesday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[1]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[1]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.tuesday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SubText(
                                            "Wednesday",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .wednesday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .wednesday ==
                                                      "00:00"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: SubText("Off Day",
                                                      color: Colors.grey,
                                                      colorOpacity: 0.4,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      size: 14),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: SubText(
                                                    "Working Day",
                                                    color: Colors.grey,
                                                    colorOpacity: 0.4,
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .wednesday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .wednesday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[0]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[0]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .wednesday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .wednesday[1] ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .wednesday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[1]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[1]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.wednesday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SubText(
                                            "Thursday",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .thursday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .thursday ==
                                                      "00:00"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: SubText("Off Day",
                                                      color: Colors.grey,
                                                      colorOpacity: 0.4,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      size: 14),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: SubText(
                                                    "Working Day",
                                                    color: Colors.grey,
                                                    colorOpacity: 0.4,
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .thursday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .thursday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[0]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[0]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .thursday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .thursday[1] ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .thursday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[1]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[1]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.thursday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SubText(
                                            "Friday",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .friday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .friday ==
                                                      "00:00"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: SubText("Off Day",
                                                      color: Colors.grey,
                                                      colorOpacity: 0.4,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      size: 14),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: SubText(
                                                    "Working Day",
                                                    color: Colors.grey,
                                                    colorOpacity: 0.4,
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .friday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .friday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[0]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[0]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .friday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .friday[1] ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .friday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[1]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[1]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.friday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SubText(
                                            "Saturday",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .saturday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .saturday ==
                                                      "00:00"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: SubText("Off Day",
                                                      color: Colors.grey,
                                                      colorOpacity: 0.4,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      size: 14),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: SubText(
                                                    "Working Day",
                                                    color: Colors.grey,
                                                    colorOpacity: 0.4,
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .saturday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .saturday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[0]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[0]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .saturday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .saturday[1] ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .saturday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[1]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[1]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.saturday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SubText(
                                            "Sunday",
                                            color: AppColors.green,
                                            size: 18,
                                          ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .sunday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .sunday ==
                                                      "00:00"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: SubText("Off Day",
                                                      color: Colors.grey,
                                                      colorOpacity: 0.4,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      size: 14),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: SubText(
                                                    "Working Day",
                                                    color: Colors.grey,
                                                    colorOpacity: 0.4,
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .sunday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .sunday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[0]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[0]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .sunday ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .sunday[1] ==
                                                      null ||
                                                  _
                                                          .jobsInterviewModel
                                                          .applicant
                                                          .jobSeekerDetails
                                                          .availability
                                                          .sunday ==
                                                      "00:00"
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SubText(
                                                            "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[1]["from"]} ",
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[1]["from_time"]}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[0]["to"]} ",
                                                              size: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SubText(
                                                              "${_.jobsInterviewModel.applicant.jobSeekerDetails.availability.sunday[0]["to_time"]}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),

                                SizedBox(
                                  height: 20,
                                ),*/
                              ],
                            ),
                    ),
                  )));
  }
}
