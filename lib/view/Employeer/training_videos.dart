import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/Employeer/share_employer.dart';
import 'package:careAsOne/controller/Employeer/training_videos.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class TrainingVideo extends StatefulWidget {
  @override
  _TrainingVideoState createState() => _TrainingVideoState();
}

class _TrainingVideoState extends State<TrainingVideo> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingVideoController>(
      init: TrainingVideoController(),
      builder: (_) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
            width: double.maxFinite,
            color: AppColors.white,
            child: _.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.green)),
                        SizedBox(
                          height: 30,
                        ),
                        _.isUploading
                            ? SubText(
                                "Uploading",
                                color: AppColors.green,
                                size: 20,
                              )
                            : SizedBox(),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainHeading('Training Videos'),
                      SizedBox(height: 35.0),
                      SizedBox(height: 10.0),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTransparentButton(
                        btnColor: AppColors.white,
                        textColor: AppColors.green,
                        title: "ADD NEW",
                        icon: Icons.add,
                        onTap: () {
                          _.openGallery(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: Checkbox(
                                    value: _.allVideos,
                                    onChanged: (val) {
                                      _.idList=[];
                                      _.allVideos = val!;
                                      _.trainingVideoList.forEach((element) {
                                        element.isCheck = val;
                                        if (element.isCheck == true) {
                                          _.idList.add(element.id);
                                        } else {
                                          _.idList = [];
                                        }
                                      });
                                      _.update();
                                    }),
                              ),
                              SizedBox(width: 5.0),
                              SubText('All', size: 12.0),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (_.idList.length != 0) {
                                _.showSelectionDialog(context, "delete");
                              } else {
                                showToast(msg: 'Please Select Video');
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
                              // Get.toNamed(AppRoute.shareDocRoute,
                              //     arguments: {"controller": controller});
                              if (_.idList.length != 0) {
                                Get.to(() => ShareEmpDocPage(
                                      docList: _.idList,
                                      type: "video",
                                    ));
                              } else {
                                showToast(msg: 'Please Select Video');
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
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        color: AppColors.green,
                        height: 1,
                        width: width(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SubText('April, 2021',
                            //     size: 12.0, color: AppColors.green),
                            SizedBox(height: 10.0),
                            GridView.builder(
                              shrinkWrap: true,
                              itemCount: _.trainingVideoList.length,
                              physics: ScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: !(context).isLandscape
                                          ? MediaQuery.of(context).size.width /
                                              (MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  1.5)
                                          : MediaQuery.of(context).size.height /
                                              (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5),
                                      crossAxisCount:
                                          !(context).isLandscape ? 2 : 3),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoute.playVideoRoute,
                                        arguments: {"videoData": _.trainingVideoList[index]});
                                  },
                                  child:
                                  FutureBuilder<ThumbnailResult>(
                                    future: genThumbnail("${BaseApi.domainName}${_.trainingVideoList[index].originalName}"),// specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratioquality: 75,)),
                                    builder: (BuildContext context, AsyncSnapshot snapshot){
                                      if(snapshot.hasData){
                                        final _image=snapshot.data.image;
                                        return VideoCard(
                                          length: _.trainingVideoList.length,
                                          url: _image,
                                          title: _.trainingVideoList[index].localName,
                                          date: _.trainingVideoList[index].createdAt!
                                              .split(" ")[0],
                                          isCheck: _.trainingVideoList[index].isCheck,
                                          onChanged: (value) {
                                            _.trainingVideoList[index].isCheck =
                                                value!;
                                            if (_.trainingVideoList[index].isCheck ==
                                                true) {
                                              // _.idList=[];

                                              _.idList.add(_.trainingVideoList[index].id);
                                            } else {
                                              _.idList.remove(
                                                  _.trainingVideoList[index].id);
                                            }
                                            _.update();
                                          },
                                        );
                                      }else{
                                        return Center(child: CircularProgressIndicator(color: AppColors.green,),);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
      // )
    );
  }

thumbnail(url) async {
  return await VideoThumbnail.thumbnailFile(
    video: "$url",
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.WEBP,
    maxHeight:
        64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 75,
  );
}
}
class ThumbnailResult {
  final Image? image;
  final int? dataSize;
  final int? height;
  final int? width;
  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

Future<ThumbnailResult> genThumbnail(url) async {
  //WidgetsFlutterBinding.ensureInitialized();
  Uint8List? bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if ((await getTemporaryDirectory()).path != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video:url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 350,
        maxWidth: 350,
        quality: 100);
    final file = File(thumbnailPath!);
    bytes = file.readAsBytesSync();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
        video: url,

        imageFormat: ImageFormat.WEBP,
        maxHeight: 75,
        maxWidth: 60,
        quality: 50);
  }
  int _imageDataSize = bytes!.length;
  final _image = Image.memory(bytes);
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
  }));
  return completer.future;
}
class ThumbnailRequest {
  final String? video;
  final String? thumbnailPath;
  final ImageFormat? imageFormat;
  final int? maxHeight;
  final int? maxWidth;
  final int? timeMs;
  final int? quality;

  const ThumbnailRequest(
      {this.video,
        this.thumbnailPath,
        this.imageFormat,
        this.maxHeight,
        this.maxWidth,
        this.timeMs,
        this.quality});
}
