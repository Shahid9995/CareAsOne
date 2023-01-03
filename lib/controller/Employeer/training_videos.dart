import 'dart:convert';
import 'dart:io';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/model/training)video.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingVideoController extends GetxController {
  String dropdownValue = 'DATE';
  String dropdownValue2 = 'RECENT';
  List idList = [];
  bool allVideos = false;

  var token;
  File? file;
  var image;
  final picker = ImagePicker();
  final storage = GetStorage();

  bool isLoading = false;
  bool isUploading = false;
  List<TrainingVideos> trainingVideoList = [];
  List<TrainingVideos> trainingVideoResponse = [];
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  final homeMaster = Get.find<HomeMasterController>();

  final List<YoutubePlayerController> videoControllers = []
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();

  @override
  void onInit() async {
    token = storage.read("authToken");
    isLoading = true;
    update();
    await getVideoList(token);
    isLoading = false;
    update();

    update();
    super.onInit();
  }

  Future openGallery(
    BuildContext context,
  ) async {

    PickedFile? pickedFile = await ImagePicker.platform.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      file = File(pickedFile.path);
      final extension = p.extension(pickedFile.path);
      if(extension==".mp4") {
        if (file!.lengthSync() <= 20971520) {
          showSelectionDialog(context, "upload");
        } else {
          showToast(
              msg: "Max. video size need to be 20 mb",
              backgroundColor: Colors.red);
        }
      }else{
        showToast(msg:"please select video file");
      }
      update();
    } else {
    }
  }

  Future<List<TrainingVideos>> getVideoList(token) async {
    isLoading = true;
    trainingVideoList = [];
    trainingVideoResponse = [];
    update();
try {
  Response? response = await BaseApi.get(
      url: 'employer/training', params: {"api_token": token});
  if (response!.data['data'] != null) {
    if (response.statusCode == 200) {
      if (response.data["data"] != null) {
        response.data["data"].forEach((ele) {
          trainingVideoResponse.add(TrainingVideos.fromJson(ele));
        });

        trainingVideoList = trainingVideoResponse;
        trainingVideoList.forEach((element) {
          String? videoId = YoutubePlayer.convertUrlToId(
              BaseApi.domainName + element.originalName!);
        });
        isLoading = false;
        update();
      }
    }
    isLoading = false;
    update();
  }
} on DioError  catch (ex) {
  if(ex.type == DioErrorType.connectTimeout){
    showToast(msg: "Time out");
  }else {
    showToast(msg: "ERROR");
  }
}
    return trainingVideoList;
  }

  Future<void> uploadVideo(BuildContext context,
      {Map<String, dynamic>? params}) async {
    isLoading = true;
    isUploading = true;

    update();
    String fileName = file!.path
        .split('/')
        .last;
    final extension = p.extension(file!.path);

    FormData formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        file!.path,
        filename: fileName,
      ),
    });
    Get.back();
    Map<String, dynamic> responseBody;
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${BaseApi
                  .domainName}api/employer/training/videos?api_token=$token'));
      request.files.add(await http.MultipartFile.fromPath('video', file!.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        showToast(msg: 'Successfully uploaded');
        await getVideoList(token);
        update();
        isLoading = false;
        isUploading = false;
        update();
      } else {
      }
    }catch(e){
      showToast(msg: "ERROR");
    }
  }
  deleteVideos() async{
    isLoading = true;
    update();
    var response=await http.post(
      Uri.parse('${BaseApi.domainName}api/employer/training/videos-delete?api_token=$token'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept':'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'id': idList,
      }),
    );
    if(response.statusCode==200){
      showToast(msg: 'Video deleted successfully');
      update();
      await getVideoList(token);

      update();
      Get.back();
      isLoading = false;
      update();
    }
  }

  Future showSelectionDialog(BuildContext context, type) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
              // title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        type == "delete"
                            ? "Do you want to Delete Video?"
                            : "Do you want to Upload?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: AppColors.green),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: Colors.grey,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: AppColors.green,
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if (type == "delete") {
                                deleteVideos();
                                Navigator.pop(context);
                              } else {
                                uploadVideo(context);
                                Navigator.pop(context);
                              }

                              // await deleteDocument(context, idList);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
