import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/jobseeker_doc_controller.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceivedDocPage extends StatefulWidget {
  final JobSeekerDocsController receivedDocController;

  ReceivedDocPage(this.receivedDocController);

  @override
  _ReceivedDocPageState createState() => _ReceivedDocPageState();
}

final Dio _dio = Dio();
String _progress = "-";
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
final android = AndroidInitializationSettings('@mipmap/ic_launcher');
var iOSInitialize = const DarwinInitializationSettings();
final initSettings = InitializationSettings(android: android,iOS: iOSInitialize);

class _ReceivedDocPageState extends State<ReceivedDocPage> {
  @override
   initState() {
    _requestPermissions(Permission.storage);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    super.initState();
  }

  _onSelectNotification(savePath) async {
    OpenFile.open(savePath);
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name',
        priority: Priority.high, importance: Importance.max);
    const iOS = DarwinNotificationDetails();
    final platform = NotificationDetails(android:android, iOS:iOS);
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
    showToast(msg: "Download started ...");
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
      //
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      Get.back();
      flutterLocalNotificationsPlugin.initialize(initSettings,onDidReceiveBackgroundNotificationResponse:
           _onSelectNotification(savePath));
      await _showNotification(result);
      OpenFile.open(savePath);
      result.clear();
    }
  }

  Future<void> _download(String downloadUrl, String name) async {
    CircularLoader().showAlert(context);
    var dir;
    if (Platform.isAndroid) {
      dir = '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      dir = (await getTemporaryDirectory()).path;
    }
    // final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted =
        await _requestPermissions(Permission.storage);
    final savePath = '$dir' + '$name';
    await _startDownload(savePath, downloadUrl);
    if (isPermissionStatusGranted) {
    } else {
      // handle the scenario when user declines the permissions
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: widget.receivedDocController.isLoading
            ? Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.green)),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: AppColors.green,
                      ),
                      onPressed: () {},
                    ),
                    onChange: (val) {
                      widget.receivedDocController.recDocName = val!;
                      widget.receivedDocController.update();
                      widget.receivedDocController.searchedDocList = [];
                      for (int i = 0;
                          i <
                              widget.receivedDocController.receiveddocsList
                                  .length;
                          i++) {
                        if (widget
                            .receivedDocController.receiveddocsList[i].name!
                            .contains(
                                widget.receivedDocController.recDocName)) {
                          widget.receivedDocController.searchedDocList.add(
                              widget.receivedDocController.receiveddocsList[i]);
                          widget.receivedDocController.update();
                        }
                      }
                    },
                    validators: FormBuilderValidators.compose([]),
                  ),
                  SizedBox(height: 25.0),
/*                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.maxFinite,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.black.withOpacity(0.7)),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: "RECENT",
                      underline: SizedBox(),
                      items: <String>['RECENT', 'OLDEST']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SubText(value, size: 12.0),
                        );
                      }).toList(),
                      onChanged: (val) {
                        //  dropdownValue = val;
                        // _.update();
                      },
                    ),
                  ),*/
                  SizedBox(height: 25.0),
                  //  Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         SizedBox(
                  //           width: 20.0,
                  //           height: 20.0,
                  //           child: Checkbox(value: false, onChanged: (val) {}),
                  //         ),
                  //         SizedBox(width: 5.0),
                  //         SubText('All', size: 12.0),
                  //       ],
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return AlertDialog(
                  //               content: Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 children: [
                  //                   IconButton(
                  //                     onPressed: () {
                  //                       Get.back();
                  //                     },
                  //                     icon: Icon(Icons.close,
                  //                         size: 28.0, color: AppColors.black),
                  //                   ),
                  //                   SizedBox(height: 30.0),
                  //                   Container(
                  //                     padding: const EdgeInsets.all(15.0),
                  //                     decoration: BoxDecoration(
                  //                         border:
                  //                             Border.all(color: Color(0xFFF0F0EF))),
                  //                     child: Column(
                  //                       children: [
                  //                         SubText(
                  //                             'Are you sure you want to delete this documents?',
                  //                             size: 16.0,
                  //                             colorOpacity: 0.7),
                  //                         SizedBox(height: 30.0),
                  //                         SubText('2 ITEMS',
                  //                             size: 12.0, color: AppColors.green),
                  //                         SizedBox(height: 30.0),
                  //                         Row(
                  //                           children: [
                  //                             Expanded(
                  //                               child: CustomButton(
                  //                                 onTap: () {},
                  //                                 title: 'YES',
                  //                               ),
                  //                             ),
                  //                             SizedBox(width: 10.0),
                  //                             Expanded(
                  //                               child: CustomButton(
                  //                                 onTap: () {},
                  //                                 title: 'NO',
                  //                                 btnColor: AppColors.green,
                  //                                 textColor: AppColors.white,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             );
                  //           },
                  //         );
                  //       },
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Icon(Icons.delete_outline,
                  //               size: 20.0,
                  //               color: AppColors.black.withOpacity(0.5)),
                  //           SizedBox(width: 2.5),
                  //           SubText('DELETE', size: 12.0, colorOpacity: 0.9),
                  //         ],
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         Get.to(() => ShareDocPage());
                  //       },
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Icon(Icons.share,
                  //               size: 20.0,
                  //               color: AppColors.black.withOpacity(0.5)),
                  //           SizedBox(width: 2.5),
                  //           SubText('SHARE WITH EMPLOYER',
                  //               size: 12.0, colorOpacity: 0.9),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 5.0),
                  // SubText('No data available in table', size: 16.0, fontFamily: 'Freight'),

                  /* DocumentCard(isReceivedDoc: true),
                DocumentCard(isReceivedDoc: true),
                DocumentCard(isReceivedDoc: true),*/
                  //DocumentCard(isReceivedDoc: true,),
                  Container(
                    width: double.infinity,
                    height: 40,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    color: AppColors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubText(
                          "TITLE",
                          color: Colors.white,
                        ),
                        SubText(
                          'DOCUMENT',
                          color: Colors.white,
                        ),
                        SubText(
                          'ACTIONS',
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.receivedDocController.searchedDocList.length == 0
                      ? Column(
                          children: List.generate(
                              widget.receivedDocController.receiveddocsList
                                  .length, (index) {
                            return Container(
                                width: double.infinity,
                                height: 40,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SubText(
                                          "${widget.receivedDocController.receiveddocsList[index].name!.split("_")[1]}"),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: widget
                                                    .receivedDocController
                                                    .receiveddocsList[index]
                                                    .name !=
                                                null
                                            ? Image(
                                                image: AssetImage(widget
                                                        .receivedDocController
                                                        .receiveddocsList[index]
                                                        .extension!
                                                        .split("/")[2]
                                                        .contains(".pdf")
                                                    ? 'assets/images/pdf.png'
                                                    : 'assets/images/docx.png'))
                                            : SizedBox(),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await _handleCameraAndMic(
                                                Permission.storage);
                                            String url =
                                                "${BaseApi.domainName}${widget.receivedDocController.receiveddocsList[index].extension}";
                                            var nameFile = url.substring(
                                                url.lastIndexOf("/") + 1);

                                            _download(url, nameFile);
                                          },
                                          icon: Icon(
                                            Icons.arrow_downward_sharp,
                                            color: Colors.grey[400],
                                          ))
                                    ]));

                          }),
                        )
                      : Column(
                          children: List.generate(
                              widget.receivedDocController.searchedDocList
                                  .length, (index) {
                            return Container(
                                width: double.infinity,
                                height: 40,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SubText(
                                          "${widget.receivedDocController.searchedDocList[index].name!.split("_")[1]}"),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: widget
                                                    .receivedDocController
                                                    .searchedDocList[index]
                                                    .extension !=
                                                null
                                            ? Image(
                                                image: AssetImage(widget
                                                        .receivedDocController
                                                        .searchedDocList[index]
                                                        .extension!
                                                        .split("/")[2]
                                                        .contains(".pdf")
                                                    ? 'assets/images/pdf.png'
                                                    : 'assets/images/docx.png'))
                                            : SizedBox(),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await _handleCameraAndMic(
                                                Permission.storage);
                                            String url =
                                                "${BaseApi.domainName}${widget.receivedDocController.searchedDocList[index].extension}";
                                            var nameFile = url.substring(
                                                url.lastIndexOf("/") + 1);

                                            _download(url, nameFile);
                                          },
                                          icon: Icon(
                                            Icons.arrow_downward_sharp,
                                            color: Colors.grey[400],
                                          ))
                                    ]));
                          }),
                        ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }
}
