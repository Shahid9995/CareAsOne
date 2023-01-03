import 'package:careAsOne/model/training)video.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlayPostVideoController extends GetxController {
  final String url;
  VideoPlayerController? controller;

  TargetPlatform? platform;
  ChewieController? chewieController;

  TrainingVideos? videoData;

  PlayPostVideoController(this.url);

  @override
  void onInit() async {

    if (Get.arguments != null) {
      videoData = Get.arguments["videoData"];
    }
    await initializePlayer();
    super.onInit();
  }
  Future<void> initializePlayer() async {
    controller = VideoPlayerController.network(
        '$url');
    controller!.initialize();
    createChewieController();
  }
  void createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: controller!,
      autoPlay: false,
      looping: true,
    );
  }

  @override
  void onClose() {
    controller!.dispose();
    chewieController!.dispose();
    super.onClose();
  }
}
