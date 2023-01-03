import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/videos.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return GetBuilder<VideosController>(
        init: VideosController(),
        builder: (_) => SingleChildScrollView(
                child: Container(
              // height: Get.height * 1.8,
              width: width,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainHeading('Videos'),
                  SizedBox(height: 15.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.maxFinite,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.black.withOpacity(0.7)),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _.dropdownValue,
                      underline: SizedBox(),
                      items: <String>['NEWEST', 'OLDEST']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SubText(value, size: 12.0),
                        );
                      }).toList(),
                      onChanged: (val) {
                        _.dropdownValue = val!;
                        _.update();


                        if(_.dropdownValue=="OLDEST"){
                          _.oldestList=[];

                          //_.oldestList.reversed;
                          _.update();
                        }else{
                          _.oldestList=[];
                          _.update();
                        }
                      },
                    ),
                  ),
                  // VideoCard(),
                  // VideoCard(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0),
                        _.videoList.isEmpty
                            ? Center(child: Heading("No Videos"))
                            : _.oldestList.length==0?GridView.builder(
                                shrinkWrap: true,
                                itemCount: _.videoList.length,
                                reverse: _.dropdownValue=="OLDEST"?true:false,
                                physics: ScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: !(context).isLandscape
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.5)
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5),
                                        crossAxisCount:
                                            !(context).isLandscape ? 2 : 3),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoute.playVideoJobSeekerRoute,
                                          arguments: {
                                            "videoData": _.videoList[index]
                                          });
                                    },
                                    child:
                                    FutureBuilder<ThumbnailResult>(
                                      future: genThumbnail("${BaseApi.domainName}${_.videoList[index].originalName}"),// specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratioquality: 75,)),
                                      builder: (BuildContext context, AsyncSnapshot snapshot){
                                        if(snapshot.hasData){
                                          final _image=snapshot.data.image;
                                          return SeekerVideoCard(
                                            length: _.videoList.length,
                                            url: _image,
                                            title: _.videoList[index].localName,
                                            date: _.videoList[index].updatedAt!.split(" ")[0],

                                          );/*Column(children: [
                                          Container(
                                            color: Colors.grey,
                                            height: 1.0,
                                          ),
                                          _image,
                                        ],);*/
                                        }else{
                                          return Center(child: CircularProgressIndicator(color: AppColors.green,),);
                                        }
                                      },
                                    ),
                                  );
                                },
                              ):GridView.builder(
                          shrinkWrap: true,
                          itemCount: _.oldestList.length,
                          physics: ScrollPhysics(),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: !(context).isLandscape
                                  ? MediaQuery.of(context)
                                  .size
                                  .width /
                                  (MediaQuery.of(context)
                                      .size
                                      .height /
                                      1.5)
                                  : MediaQuery.of(context)
                                  .size
                                  .height /
                                  (MediaQuery.of(context)
                                      .size
                                      .width /
                                      1.5),
                              crossAxisCount:
                              !(context).isLandscape ? 2 : 3),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed(
                                    AppRoute.playVideoJobSeekerRoute,
                                    arguments: {
                                      "videoData": _.oldestList[index]
                                    });
                              },
                              child: FutureBuilder<ThumbnailResult>(
                                future: genThumbnail("${BaseApi.domainName}${_.oldestList[index].originalName}"),// specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratioquality: 75,)),
                                builder: (BuildContext context, AsyncSnapshot snapshot){
                                  if(snapshot.hasData){
                                    final _image=snapshot.data.image;
                                    return VideoCard(
                                      length: _.oldestList.length,
                                      url: _image,
                                      title: _.oldestList[index].localName,
                                      date: _.oldestList[index].createdAt,
                                      isCheck: _.oldestList[index].isCheck,
                                      onChanged: (value) {
                                        _.oldestList[index].isCheck =
                                            value;
                                        if (_.oldestList[index].isCheck ==
                                            true) {
                                          _.id.add(_.oldestList[index].id);
                                        } else {
                                          _.id.remove(
                                              _.oldestList[index].id);
                                        }
                                        _.update();
                                      },
                                    );
                                  }else{
                                    return Center(child: CircularProgressIndicator(color: AppColors.green,));
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
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
  Uint8List? bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if ((await getTemporaryDirectory()).path != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video:url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 120,
        maxWidth: 120,

        quality: 1);

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

