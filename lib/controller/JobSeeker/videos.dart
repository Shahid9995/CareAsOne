import 'dart:io';
import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/videos_jobkeeper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosController extends GetxController {
  String dropdownValue = 'NEWEST';
  String dropdownValue2 = 'OLDEST';
  List id = [];
  bool allVideos = false;

  var token;
  File? file;
  var image;
  final picker = ImagePicker();
  final storage = GetStorage();

  bool isLoading = false;
  bool isUploading = false;
  List<Videos> videoList = [];
var oldestList = [];
  List<Videos> videoResponse = [];
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
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

  Future<List<Videos>> getVideoList(token) async {
    isLoading = true;
    videoList = [];
    videoResponse = [];
    update();
    try {
      Response? response = await BaseApi.get(
          url: 'job-seeker/traing-videos', params: {"api_token": token});
      if (response!.statusCode == 200) {
        if (response.data["data"]["videos"] != null) {
          response.data["data"]["videos"].forEach((ele) {
            videoResponse.add(Videos.fromJson(ele));
          });

          videoList = videoResponse;
          videoList.forEach((element) {
            String? videoId = YoutubePlayer.convertUrlToId(
                BaseApi.domainName + element.originalName!);
          });
          isLoading = false;
          update();
        }
      }
    } on DioError  catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
    return videoList;
  }
}
