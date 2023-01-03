import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/manage_availability.dart';
import 'package:careAsOne/controller/JobSeeker/upload_resume.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class UploadResumePage extends StatefulWidget {
  @override
  _UploadResumePageState createState() => _UploadResumePageState();
}

bool isCoverReceived = false;
bool isResumeReceived = false;
bool isCertificateReceived = false;
bool isRegistryReceived = false;
String? coverName;
String? resumeName;
String? certificateName;
String? registryName;
File? resume;
File? coverLetter;
File? certification;
File? registry;
bool downloading = true;
String downloadingStr = "No data";
File? f;
ReceivePort _port = ReceivePort();
final imgUrl = "";

final String _fileUrl = "http://lot.services/blog/files/DSCF0277.jpg";
final String _fileName = "DSCF027.pdf";
final Dio _dio = Dio();

String _progress = "-";
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
final android = AndroidInitializationSettings('@mipmap/ic_launcher');
var iOSInitialize = const DarwinInitializationSettings();
final initSettings = InitializationSettings(android:android, iOS:iOSInitialize);
var dio;
class _UploadResumePageState extends State<UploadResumePage> {
  @override
 initState() {
    _requestPermissions(Permission.storage);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    initSettings;

    super.initState();
  }
 _onSelectNotification(filePath)  {
OpenFile.open(filePath);
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id',
        'channel name',

        priority: Priority.high,
        importance: Importance.max
    );
    const iOS = DarwinNotificationDetails();
    final platform = NotificationDetails(android:android, iOS:iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin!.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
        platform,
        payload: json
    );
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getApplicationDocumentsDirectory();
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions(Permission permission) async {

      final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> _startDownload(String savePath,String downloadUrl) async {
    showToast(msg: "Download started ...");
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(
          downloadUrl,
          savePath,
          onReceiveProgress: _onReceiveProgress
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;

    } catch (ex) {
      result['error'] = ex.toString();
    } finally {

      flutterLocalNotificationsPlugin!.initialize(initSettings,onDidReceiveBackgroundNotificationResponse: _onSelectNotification(savePath));
      Get.back();
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
   var status = await Permission.storage.status;
    if (status.isGranted) {
final savePath = '$dir'+'$name';
    await _startDownload(savePath,downloadUrl);
    } else {
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    var dio = Dio();
    return GetBuilder<UploadResumeController>(
      init: UploadResumeController(),
      builder: (_) => SingleChildScrollView(
        child: _.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.green,
                ),
              )
            : Container(
                // height: Get.height * 1.8,
                width: width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                margin: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0),
                      MainHeading(
                        'Upload Resume',
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Uploaded Documents',
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _.resumeData != null ||
                              _.coverLetterData != null ||
                              _.certificationData != null ||
                              _.registryData != null
                          ? Container(
                              width: width,
                              height: 40,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              color: AppColors.green,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),

                      _.resumeData != null
                          ? Container(
                              width: width,
                              height: 40,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _.seekerProfileModel != null
                                      ? SubText(
                                          '${_.seekerProfileModel!.firstName}_Resume')
                                      : SizedBox(),
                                  _.resumeData != null
                                      ? Image(
                                          image: AssetImage(
                                              _.resumeData!.contains(".doc")
                                                      ||_.resumeData!.contains(".docx")
                                                  ? 'assets/images/docx.png'
                                                  : 'assets/images/pdf.png'))
                                      : SizedBox(),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            String url =
                                                "${BaseApi.domainName}${_.resumeData}";
                                            var nameFile=url.substring(url.lastIndexOf("/")+1);

                                            _download(url, nameFile);
                                          },
                                          icon: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.grey)),
                                      IconButton(
                                          onPressed: () {
                                            _.showSelectionDialog(
                                                context, "resume");
                                          },
                                          icon: Icon(Icons.delete_outline,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _.coverLetterData != null
                          ? Container(
                              width: width,
                              height: 40,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SubText(
                                      '${_.seekerProfileModel!.firstName}_Cover'),
                                  Image(
                                      image:
                                          AssetImage(   _.coverLetterData!.contains(".doc")
                                              ||_.coverLetterData!.contains(".docx")
                                              ? 'assets/images/docx.png'
                                              : 'assets/images/pdf.png')),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {

                                            String url =
                                                '${BaseApi.domainName}${_.coverLetterData}';
                                            var nameFile=url.substring(url.lastIndexOf("/")+1);

                                            _download(url, nameFile);
                                          },

                                          icon: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.grey)),
                                      IconButton(
                                          onPressed: () {
                                            _.showSelectionDialog(
                                                context, "cover_letter");
                                          },
                                          icon: Icon(Icons.delete_outline,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _.certificationData != null
                          ? Container(
                              width: width,
                              height: 40,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SubText(
                                      '${_.seekerProfileModel!.firstName}_Certification'),
                                  //SubText('${_.certificationData.split("/")[2]}'),
                                  Image(
                                      image: AssetImage((_.certificationData!
                                              .split("/")[2]
                                              .contains(".jpg")||_.certificationData!
                                          .split("/")[2]
                                          .contains(".jpeg"))
                                          ? 'assets/images/imageicon.jpg'
                                          : 'assets/images/pdf.png')),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            String url =
                                                "${BaseApi.domainName}${_.certificationData}";

                                            var nameFile=url.substring(url.lastIndexOf("/")+1);

                                            _download(url, nameFile);

                                          },
                                          icon: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.grey)),
                                      IconButton(
                                          onPressed: () {
                                            _.showSelectionDialog(
                                                context, "certifications");
                                          },
                                          icon: Icon(Icons.delete_outline,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _.registryData != null
                          ? Container(
                              width: width,
                              height: 40,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SubText(
                                      '${_.seekerProfileModel!.firstName}_Registry'),
                                  Image(
                                      image: AssetImage((_.registryData!
                                              .split("/")[2]
                                              .contains(".jpg")||_.registryData!
                                          .split("/")[2]
                                          .contains(".jpeg"))
                                          ? 'assets/images/imageicon.jpg'
                                          : 'assets/images/pdf.png')),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            String url =
                                                "${BaseApi.domainName}${_.registryData}";

                                            var nameFile=url.substring(url.lastIndexOf("/")+1);

                                            _download(url, nameFile);
                                          },
                                          icon: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.grey)),
                                      IconButton(
                                          onPressed: () {
                                            _.showSelectionDialog(
                                                context, "registry");
                                          },
                                          icon: Icon(Icons.delete_outline,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),


                      SizedBox(height: 5.0),


                      UploadDocumentCard(
                        tilte: "Resume",
                        docName: (resumeName == null) ? 'file' : resumeName,
                        isReceivedDoc: false,
                        format: 'docx,pdf', isSignatureDoc: false,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      if (isResumeReceived)
                        CustomButton(
                          onTap: () {
                            setState(() {
                              resumeName = null;
                              isResumeReceived = false;
                            });
                          },
                          title: "DELETE",
                          btnColor: AppColors.white,
                          textColor: AppColors.green,
                        ),
                      SizedBox(height: 20.0),
                      isResumeReceived
                          ? SizedBox(
                              height: 10,
                            )
                          : CustomButton(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  resume = File(result.files.single.path!);

                                  final extension =
                                      p.extension(result.files.single.path!);
                                  if (extension == '.pdf'||extension=='.docx') {
                                    resumeName = resume!.path.split('/').last;

                                    _.update();
                                    showToast(msg: "File Selected");

                                    isResumeReceived = true;
                                  } else {
                                    showToast(msg: 'File type does not match.');
                                    isResumeReceived = false;
                                  }
                                } else {
                                  showToast(msg: "File not Selected");
                                  isResumeReceived = false;
                                }
                              },
                              title: 'BROWSE FILE',
                            ),
                      UploadDocumentCard(
                        tilte: "Upload Cover Letter",
                        docName: (coverName == null) ? 'file' : coverName,
                        isReceivedDoc: false,
                        format: 'docx,pdf', isSignatureDoc: false,
                      ),

                      if (isCoverReceived)
                        CustomButton(
                          onTap: () {
                            setState(() {
                              coverName = null;
                              isCoverReceived = false;
                            });
                          },
                          title: "DELETE",
                          btnColor: AppColors.white,
                          textColor: AppColors.green,
                        ),
                      SizedBox(height: 20.0),
                      /*         isReceivedDoc
                      ? SizedBox()
                      :*/
                      isCoverReceived
                          ? SizedBox(
                              height: 10,
                            )
                          : CustomButton(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  coverLetter = File(result.files.single.path!);
                                  final extension =
                                      p.extension(result.files.single.path!);
                                  if (extension == '.pdf'||extension=='.docx') {
                                    coverName =
                                        coverLetter!.path.split('/').last;

                                    _.update();
                                    showToast(msg: "File Selected");

                                    isCoverReceived = true;
                                  } else {
                                    showToast(msg: 'File type does not match.');
                                    isCoverReceived = false;
                                  }
                                } else {
                                  showToast(msg: "File not Selected");
                                  isCoverReceived = false;
                                }
                              },
                              title: 'BROWSE FILE',
                            ),
                      UploadDocumentCard(
                        tilte: "Upload Certification Document",
                        docName: (certificateName == null)
                            ? 'file'
                            : certificateName,
                        isReceivedDoc: false,
                        format: 'pdf,jpg,jpeg', isSignatureDoc: false,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      if (isCertificateReceived)
                        CustomButton(
                          onTap: () {
                            setState(() {
                              certificateName = null;
                              isCertificateReceived = false;
                            });
                          },
                          title: "DELETE",
                          btnColor: AppColors.white,
                          textColor: AppColors.green,
                        ),
                      SizedBox(height: 20.0),
                      /*         isReceivedDoc
                      ? SizedBox()
                      :*/
                      isCertificateReceived
                          ? SizedBox(
                              height: 10,
                            )
                          : CustomButton(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  certification =
                                      File(result.files.single.path!);
                                  final extension =
                                      p.extension(result.files.single.path!);
                                  if (extension == '.pdf' ||
                                      extension == '.jpg' ||
                                      extension == ".jpeg") {
                                    certificateName =
                                        certification!.path.split('/').last;

                                    _.update();
                                    showToast(msg: "File Selected");

                                    isCertificateReceived = true;
                                  } else {
                                    showToast(msg: 'File type does not match.');
                                    isCertificateReceived = false;
                                  }
                                } else {
                                  showToast(msg: "File not Selected");
                                  isCertificateReceived = false;
                                }
                              },
                              title: 'BROWSE FILE',
                            ),
                      UploadDocumentCard(
                        tilte: "Upload Registry Documents",
                        docName: (registryName == null) ? 'file' : registryName,
                        isReceivedDoc: false,
                        format: 'pdf,jpg,jpeg', isSignatureDoc: false,
                      ),

                      if (isRegistryReceived)
                        CustomButton(
                          onTap: () {
                            setState(() {
                              registryName = null;
                              isRegistryReceived = false;
                            });
                          },
                          title: "DELETE",
                          btnColor: AppColors.white,
                          textColor: AppColors.green,
                        ),
                      SizedBox(height: 20.0),
                      /*         isReceivedDoc
                      ? SizedBox()
                      :*/
                      isRegistryReceived
                          ? SizedBox(
                              height: 10,
                            )
                          : CustomButton(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  registry = File(result.files.single.path!);
                                  final extension =
                                      p.extension(result.files.single.path!);
                                  if (extension == '.pdf' ||
                                      extension == '.jpg' ||
                                      extension == ".jpeg") {
                                    registryName =
                                        registry!.path.split('/').last;

                                    _.update();
                                    showToast(msg: "File Selected");

                                    isRegistryReceived = true;
                                  } else {
                                    showToast(msg: 'File type does not match.');
                                    isRegistryReceived = false;
                                  }
                                } else {
                                  showToast(msg: "File not Selected");
                                  isRegistryReceived = false;
                                }
                              },
                              title: 'BROWSE FILE',
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 15),
                        child: isCoverReceived ||
                                isResumeReceived ||
                                isCertificateReceived ||
                                isRegistryReceived
                            ? CustomButton(
                                onTap: () {
                                  showDialog(
                                    barrierColor: Colors.black87,
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        // title: Align(alignment: Alignment.topRight,child: IconButton(icon:Icon(Icons.close),onPressed: (){Get.back();},),),
                                        content: new Text(
                                          "Are you sure you want to Upload?",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        actions: <Widget>[
                                          // usually buttons at the bottom of the dialog
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              new MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: AppColors.green,
                                                        width: 1,
                                                        style:
                                                            BorderStyle.solid)),
                                                child: new Text(
                                                  "NO",
                                                  style: TextStyle(
                                                      color: AppColors.green),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              ),
                                              new MaterialButton(
                                                color: AppColors.green,
                                                child: new Text(
                                                  "YES",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  _.uploadResume(
                                                      context,
                                                      resume,
                                                      coverLetter,
                                                      certification,
                                                      registry,
                                                      isCoverReceived,
                                                      isResumeReceived,
                                                      isCertificateReceived,
                                                      isRegistryReceived);

                                                  setState(() {
                                                    resumeName = "file";
                                                    coverName = "file";
                                                    certificateName = "file";
                                                    registryName = "file";
                                                    isCoverReceived = false;
                                                    isResumeReceived = false;
                                                    isCertificateReceived =
                                                        false;
                                                    isRegistryReceived = false;
                                                    Get.toNamed("/homeMaster");
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                title: 'SAVE',
                                textColor: AppColors.white,
                                btnColor: AppColors.green,
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

}

class AvailabilityClass extends StatelessWidget {
  const AvailabilityClass({
    this.controller,
    this.dayTitle,
    this.onTap,
    required this.checkValue,
    Key? key,
  });

  final ManageAvailabilityController? controller;
  final String? dayTitle;
  final void Function(bool?)? onTap;
  final bool checkValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(value: checkValue, onChanged: onTap),
                Text(
                  dayTitle.toString(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: checkValue ? AppColors.green : Colors.grey),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  checkValue ? "Working Day" : "Day Off",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.withOpacity(0.4)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  // width: width/3,
                  height: 40.0,

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black.withOpacity(0.2)),
                  ),
                  child: DropdownButton<String>(
                    // isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: "09:00 AM",
                    underline: SizedBox(),
                    items: <String>['09:00 AM', '010:00 AM']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SubText(
                          value,
                          size: 12.0,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      // _.dropdownValue = val;
                      controller!.update();
                    },
                  ),
                ),
                Text("-"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  // width: width/3,
                  height: 40.0,

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black.withOpacity(0.2)),
                  ),
                  child: DropdownButton<String>(
                    // isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: "09:00 AM",
                    underline: SizedBox(),
                    items: <String>['09:00 AM', '010:00 AM']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SubText(
                          value,
                          size: 12.0,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      // _.dropdownValue = val;
                      controller!.update();
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.grey,
                    ))
              ],
            ),
            SizedBox(height: 10),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: AppColors.green,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
