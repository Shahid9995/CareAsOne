import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/jobseeker_doc_controller.dart';
import 'package:careAsOne/view/documents/add_docs_jobseeker.dart';
import 'package:careAsOne/view/documents/share.dart';
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

class UploadDocPage extends StatefulWidget {
  final JobSeekerDocsController jobSeekerDocsController;

  UploadDocPage(this.jobSeekerDocsController);

  @override
  _UploadDocPageState createState() => _UploadDocPageState();
}

final Dio _dio = Dio();

String _progress = "-";

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
final android = AndroidInitializationSettings('@mipmap/ic_launcher');
var iOS = const DarwinInitializationSettings();
final initSettings = InitializationSettings(android:android, iOS:iOS);

class _UploadDocPageState extends State<UploadDocPage> {
  @override
  initState(){
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
      // flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      Get.back();
      flutterLocalNotificationsPlugin.initialize(initSettings,
          onDidReceiveBackgroundNotificationResponse: _onSelectNotification(savePath));

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
        child: widget.jobSeekerDocsController.isLoading
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
                      widget.jobSeekerDocsController.docName = val!;
                      widget.jobSeekerDocsController.update();
                      widget.jobSeekerDocsController.searchedList = [];
                      for (int i = 0;
                          i < widget.jobSeekerDocsController.docsList.length;
                          i++) {
                        if (widget.jobSeekerDocsController.docsList[i].name!
                            .contains(widget.jobSeekerDocsController.docName)) {
                          widget.jobSeekerDocsController.searchedList
                              .add(widget.jobSeekerDocsController.docsList[i]);
                          widget.jobSeekerDocsController.update();
                        }
                      }
                    },
                    validators: FormBuilderValidators.compose([]),
                  ),
                  SizedBox(height: 30.0),
                  CustomButton(
                    onTap: () {
                      Get.to(() => AddDocsJobSeeker());
                    },
                    title: 'ADD NEW',
                  ),
                  SizedBox(height: 25.0),
                  widget.jobSeekerDocsController.docsList.isEmpty
                      ? Text("")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: Checkbox(
                                      value: widget
                                          .jobSeekerDocsController.allDocs,
                                      onChanged: (val) {
                                        widget.jobSeekerDocsController.allDocs =
                                            val!;
                                        widget.jobSeekerDocsController.docsList
                                            .forEach((element) {
                                          element.isSelected = val;
                                          if (element.isSelected == true) {
                                            widget.jobSeekerDocsController.id
                                                .add(element.id);
                                          } else {
                                            widget.jobSeekerDocsController.id =
                                                [];
                                          }
                                        });
                                        widget.jobSeekerDocsController.update();
                                      }),
                                ),
                                SizedBox(width: 5.0),
                                SubText('All', size: 12.0),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.jobSeekerDocsController.id.length !=
                                    0) {
                                  widget.jobSeekerDocsController
                                      .showSelectionDialog(context,
                                          widget.jobSeekerDocsController.id);
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
                                  SubText('DELETE',
                                      size: 12.0, colorOpacity: 0.9),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.jobSeekerDocsController.id.length !=
                                    0) {
                                  Get.to(() => ShareDocPage(
                                      docList:
                                          widget.jobSeekerDocsController.id,
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
                                  SubText('SHARE WITH EMPLOYER',
                                      size: 12.0, colorOpacity: 0.9),
                                ],
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 5.0),
                  widget.jobSeekerDocsController.searchedList.length == 0
                      ? Column(
                          children: List.generate(
                              widget.jobSeekerDocsController.docsList.length,
                              (index) {
                            return DocumentCard(
                              docs: widget
                                  .jobSeekerDocsController.docsList[index],
                              isCheck: (val) {
                                widget.jobSeekerDocsController.docsList[index]
                                    .isSelected = val!;
                                if (val == true) {
                                  widget.jobSeekerDocsController.id.add(widget
                                      .jobSeekerDocsController
                                      .docsList[index]
                                      .id);
                                } else {
                                  widget.jobSeekerDocsController.id.remove(
                                      widget.jobSeekerDocsController
                                          .docsList[index].id);
                                }
                                widget.jobSeekerDocsController.update();
                                widget.jobSeekerDocsController.docsList[index]
                                    .isSelected = val;
                                widget.jobSeekerDocsController.update();
                              },
                              docType: widget.jobSeekerDocsController
                                  .docsList[index].extension,
                              onDelete: () {
                                widget.jobSeekerDocsController.id.add(widget
                                    .jobSeekerDocsController
                                    .docsList[index]
                                    .id);
                                widget.jobSeekerDocsController
                                    .showSelectionDialog(context, [
                                  widget.jobSeekerDocsController.docsList[index]
                                      .id
                                ]);
                              },
                              date: widget.jobSeekerDocsController.docsList[index].createdAt!.split("T")[0],
                              onView: () async {
                                await _handleCameraAndMic(Permission.storage);
                                String url =
                                    "${BaseApi.domainName}${widget.jobSeekerDocsController.docsList[index].extension}";
                                var nameFile =
                                    url.substring(url.lastIndexOf("/") + 1);

                                _download(url, nameFile);
                              },
                            );
                          }),
                        )
                      : Column(
                          children: List.generate(
                              widget.jobSeekerDocsController.searchedList
                                  .length, (index) {
                            return DocumentCard(
                              docs: widget
                                  .jobSeekerDocsController.searchedList[index],
                              isCheck: (val) {
                                widget.jobSeekerDocsController
                                    .searchedList[index].isSelected = val!;
                                if (val == true) {
                                  widget.jobSeekerDocsController.id.add(widget
                                      .jobSeekerDocsController
                                      .searchedList[index]
                                      .id);
                                } else {
                                  widget.jobSeekerDocsController.id.remove(
                                      widget.jobSeekerDocsController
                                          .searchedList[index].id);
                                }
                                widget.jobSeekerDocsController.update();
                                widget.jobSeekerDocsController
                                    .searchedList[index].isSelected = val;
                                widget.jobSeekerDocsController.update();
                              },
                              docType: widget.jobSeekerDocsController
                                  .searchedList[index].extension,
                              onDelete: () {
                                widget.jobSeekerDocsController.id.add(widget
                                    .jobSeekerDocsController
                                    .searchedList[index]
                                    .id);
                                widget.jobSeekerDocsController
                                    .showSelectionDialog(context, [
                                  widget.jobSeekerDocsController
                                      .searchedList[index].id
                                ]);
                              },
                              date: widget.jobSeekerDocsController.searchedList[index].createdAt!.split("T")[0],
                              onView: () async {
                                await _handleCameraAndMic(Permission.storage);
                                String url =
                                    "${BaseApi.domainName}${widget.jobSeekerDocsController.searchedList[index].extension}";
                                var nameFile =
                                    url.substring(url.lastIndexOf("/") + 1);

                                _download(url, nameFile);
                              },
                            );
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
