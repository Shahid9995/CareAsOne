import 'dart:convert';
import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/docs.dart';
import 'package:careAsOne/model/employees.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EmpSharedDocPage extends StatefulWidget {
  final EmpDocsController controller;

  EmpSharedDocPage(this.controller);

  @override
  _EmpSharedDocPageState createState() => _EmpSharedDocPageState();
}

Dio _dio = new Dio();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
String _progress = "-";
final android = AndroidInitializationSettings('@mipmap/ic_launcher');
var iOSInitialize = const DarwinInitializationSettings();
final initSettings = InitializationSettings(android:android, iOS:iOSInitialize);

class _EmpSharedDocPageState extends State<EmpSharedDocPage> {
  @override
  void initState() {
    // TODO: implement initState
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
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      Navigator.pop(context);
      flutterLocalNotificationsPlugin.initialize(initSettings,
          onDidReceiveBackgroundNotificationResponse:  _onSelectNotification(savePath));

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
    if (isPermissionStatusGranted) {} else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: widget.controller.shareDocsList == null
            ? Center(child: MainHeading("Critical Server Error"))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.controller.empService.employeesList == null
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: double.maxFinite,
              height: 40.0,
              decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey.withOpacity(0.7)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Applicant",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            )
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: double.maxFinite,
              height: 40.0,
              decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey.withOpacity(0.7)),
              ),
              child: DropdownButton<Employees>(
                // value: selectedLoc == "" || selectedLoc == null  ?" ":selectedLoc,
                elevation: 16,
                iconEnabledColor: AppColors.green,
                iconDisabledColor: Colors.grey,
                isExpanded: true,
                underline: Container(
                  height: 0,
                ),
                onChanged: (Employees? newValue) {

                  widget.controller.dropDown = newValue!.name!;
                  widget.controller.applicantId =
                      newValue.id.toString();
                  widget.controller.update();

                  if (widget.controller.dropDown ==
                      "Select Applicant") {
                    widget.controller.applicantId = "";
                    widget.controller.update();
                  } else {
                    widget.controller.applicantId =
                        newValue.id.toString();
                    widget.controller.update();
                  }
                },
                hint: widget.controller.dropDown == "" ||
                    widget.controller.dropDown == null
                    ? Text(
                  "Select Applicant",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: AppColors.green),
                )
                    : Text(widget.controller.dropDown,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: AppColors.green)),
                items: widget.controller.empService.employeesList!
                    .map<DropdownMenuItem<Employees>>((dynamic value) {
                  return DropdownMenuItem<Employees>(
                    value: value ??" ",
                    child: Text(value!.name!),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 25.0),
            SizedBox(height: 5.0),
            widget.controller.shareDocsList.length == 0
                ? Center(
              child: SubText(
                "",
                size: 17,
                color: Colors.grey[400],
              ),
            )
                : Column(
              children: List.generate(
                  widget.controller.shareDocsList.length, (index) {
                String name = widget.controller.shareDocsList[index]
                    .employeeDoc![0].firstName!;
                return widget.controller.dropDown == name
                    ? DocumentCard(
                  isReceivedDoc: true,
                  docs:
                  widget.controller.shareDocsList[index],
                  isCheck: (val) {
                    widget.controller.shareDocsList[index]
                        .isSelected = val!;
                    if (val == true) {
                      widget.controller.sharedDocId.add(widget
                          .controller
                          .shareDocsList[index]
                          .id);
                    } else {
                      widget.controller.sharedDocId.remove(
                          widget.controller
                              .shareDocsList[index].id);
                    }
                    widget.controller.update();
                    widget.controller.shareDocsList[index]
                        .isSelected = val;
                    widget.controller.update();
                  },
                  date: widget.controller.shareDocsList[index].updatedAt!.split("T")[0],
                  onDelete: () {
                    widget.controller.deleteSharedDocument(
                        context,
                        widget.controller.shareDocsList[index]
                            .id);
                  },

                  onView: () async {
                    String url =
                        "${BaseApi.domainName}${widget.controller.shareDocsList[index].extension}";
                    var nameFile = url.substring(
                        url.lastIndexOf("/") + 1);

                    _download(url, nameFile);
                  },
                  docType: widget.controller
                    .shareDocsList[index].extension,
                )
                    : widget.controller.dropDown == ""
                    ? DocumentCard(
                  isReceivedDoc: true,
                  docs: widget
                      .controller.shareDocsList[index],
                  isCheck: (val) {
                    widget.controller.shareDocsList[index]
                        .isSelected = val!;
                    if (val == true) {
                      widget.controller.sharedDocId.add(
                          widget.controller
                              .shareDocsList[index].id);
                    } else {
                      widget.controller.sharedDocId
                          .remove(widget.controller
                          .shareDocsList[index].id);
                    }
                    widget.controller.update();
                    widget.controller.shareDocsList[index]
                        .isSelected = val;
                    widget.controller.update();
                  },
                  date: widget.controller.shareDocsList[index].createdAt!.split("T")[0],
                  onDelete: () {
                    widget.controller
                        .deleteSharedDocument(
                        context,
                        widget.controller
                            .shareDocsList[index].id);
                  },
                  docType: widget.controller
                      .shareDocsList[index].extension,
                  onView: () async {
                    String url =
                        "${BaseApi.domainName}${widget.controller
                        .shareDocsList[index].extension}";
                    var nameFile = url.substring(
                        url.lastIndexOf("/") + 1);

                    _download(url, nameFile);
                  },
                )
                    : SizedBox();
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
