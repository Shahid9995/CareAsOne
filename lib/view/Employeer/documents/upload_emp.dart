import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/docs.dart';
import 'package:careAsOne/controller/Employeer/share_employer.dart';
import 'package:careAsOne/view/documents/add.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
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

class EmpUploadDocPage extends StatefulWidget {
  final EmpDocsController controller;

  EmpUploadDocPage(this.controller);

  @override
  _EmpUploadDocPageState createState() => _EmpUploadDocPageState();
}

Dio _dio = new Dio();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
String _progress = "-";
final android = AndroidInitializationSettings('@mipmap/ic_launcher');
var iOSInitialize = const DarwinInitializationSettings();
final initSettings = InitializationSettings(android:android, iOS:iOSInitialize);

class _EmpUploadDocPageState extends State<EmpUploadDocPage> {
  @override
  void initState() {
    _requestPermissions(Permission.storage);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    super.initState();
  }

  _onSelectNotification(savePath) {
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
    CircularLoader().showAlert(context);
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
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: widget.controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.green)),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(
                    controller: widget.controller.controller,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: AppColors.green,
                      ),
                      onPressed: () {
                        widget.controller.searchedList = [];
                      },
                    ),
                    onChange: (val) {
                      widget.controller.docName = val!;
                      widget.controller.update();
                      widget.controller.searchedList = [];
                      for (int i = 0;
                          i < widget.controller.docsList.length;
                          i++) {
                        if (widget.controller.docsList[i].name!
                            .contains(widget.controller.docName)) {
                          widget.controller.searchedList
                              .add(widget.controller.docsList[i]);
                          widget.controller.update();
                        }
                      }
                    },
                    validators: FormBuilderValidators.compose([]),
                  ),
                  SizedBox(height: 30.0),
                  CustomButton(
                    onTap: () {
                      Get.to(() => AddDocPage());
                    },
                    title: 'ADD NEW',
                  ),
                  SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: Checkbox(
                                value: widget.controller.allDocs,
                                onChanged: (val) {
                                  widget.controller.id = [];
                                  widget.controller.allDocs = val!;
                                  widget.controller.docsList.forEach((element) {
                                    element.isSelected = val;
                                    if (element.isSelected == true) {
                                      widget.controller.id.add(element.id);
                                    } else {
                                      widget.controller.id = [];
                                    }
                                  });
                                  widget.controller.update();
                                }),
                          ),
                          SizedBox(width: 5.0),
                          SubText('All', size: 12.0),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.controller.id.length != 0) {
                            widget.controller.showSelectionDialog(
                                context, widget.controller.id);
                          } else {
                            showToast(msg: 'Please Select Document');
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline,
                                size: 20.0,
                                color: AppColors.black.withOpacity(0.5)),
                            SizedBox(width: 2.5),
                            SubText('DELETE', size: 12.0, colorOpacity: 0.9),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.controller.id.length != 0) {
                            Get.to(() => ShareEmpDocPage(
                                docList: widget.controller.id,
                                type: "document"));
                          } else {
                            showToast(msg: 'Please Select Document');
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.share,
                                size: 20.0,
                                color: AppColors.black.withOpacity(0.5)),
                            SizedBox(width: 2.5),
                            SubText('SHARE WITH EMPLOYEES',
                                size: 12.0, colorOpacity: 0.9),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),

                  widget.controller.searchedList.length == 0
                      ? Column(
                          children: List.generate(
                              widget.controller.docsList.length, (index) {
                            return DocumentCard(
                                docs: widget.controller.docsList[index],
                                isCheck: (val) {
                                  widget.controller.docsList[index].isSelected =
                                      val!;
                                  if (val == true) {
                                    widget.controller.id.add(
                                        widget.controller.docsList[index].id);
                                  } else {
                                    widget.controller.id.remove(
                                        widget.controller.docsList[index].id);
                                  }
                                  widget.controller.update();
                                  widget.controller.docsList[index].isSelected =
                                      val;
                                  widget.controller.update();
                                },
                                docType:
                                    widget.controller.docsList[index].extension,
                                date:widget.controller.docsList[index].createdAt!.split("T")[0],
                                onView: () async {
                                  await _handleCameraAndMic(Permission.storage);
                                  String url =
                                      "${BaseApi.domainName}${widget.controller.docsList[index].extension}";

                                  var nameFile =
                                      url.substring(url.lastIndexOf("/") + 1);

                                  _download(url, nameFile);
                                },

                                onDelete: () {
                                  widget.controller.id.add(
                                      widget.controller.docsList[index].id);
                                  widget.controller.showSelectionDialog(context,
                                      [widget.controller.docsList[index].id]);
                                });
                          }),
                        )
                      : Column(
                          children: List.generate(
                              widget.controller.searchedList.length, (index) {
                            return DocumentCard(
                                docs: widget.controller.searchedList[index],
                                docType:
                                    "${widget.controller.searchedList[index].extension}",
                                isCheck: (val) {
                                  widget.controller.searchedList[index]
                                      .isSelected = val!;
                                  if (val == true) {
                                    widget.controller.id.add(widget
                                        .controller.searchedList[index].id);
                                  } else {
                                    widget.controller.id.remove(widget
                                        .controller.searchedList[index].id);
                                  }
                                  widget.controller.update();
                                  widget.controller.searchedList[index]
                                      .isSelected = val;
                                  widget.controller.update();
                                },
                                date:widget.controller.searchedList[index].createdAt!.split("T")[0],
                                onView: () async {
                                  await _handleCameraAndMic(Permission.storage);
                                  String url =
                                      "${BaseApi.domainName}${widget.controller.searchedList[index].extension}";

                                  var nameFile =
                                      url.substring(url.lastIndexOf("/") + 1);

                                  _download(url, nameFile);
                                },
                                onDelete: () {
                                  widget.controller.id.add(
                                      widget.controller.searchedList[index].id);
                                  widget.controller.showSelectionDialog(
                                      context, [
                                    widget.controller.searchedList[index].id
                                  ]);
                                });
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
