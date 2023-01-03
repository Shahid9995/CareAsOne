import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/Employeer/play_video.dart';
import 'package:careAsOne/view/messages/messages.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

class PlayVideo extends StatelessWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final fKey = new GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayVideoController>(
        init: PlayVideoController(),
        builder: (_) => Scaffold(
              key: scaffoldKey,
              backgroundColor: AppColors.bgGreen,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: AppColors.white,
                automaticallyImplyLeading: false,
                title:
                    Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth),
                actions: [
                  UnReadMsgIconButton(
                    onTap: () {
                      Get.to(() => MessagesPage());
                    },
                    msgNumber: 0,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: IconButton(icon: Icon(Icons.menu,color: AppColors.green,),onPressed: (){Get.back();},),
                    ),
                  ),
                ],
              ),

              body: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Row(
                      children: [
                        InkWell(
                          child: Row(children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                            ),
                            SubText(
                              "Back",
                              size: 16,
                            ),
                          ]),
                          onTap: () {
                            Get.back();
                          },
                        ),
                        SizedBox(
                          width: width(context) / 6,
                        ),
                        MainHeading('Training Videos'),
                      ],
                    ),
                  ),
                  Container(
                    height: height(context) / 3,
                    width: width(context),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)),
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 30),
                    child: Center(
                        child: Chewie(
                      controller: _.chewieController!,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: MainHeading(
                      "${_.videoData!.localName}",
                      color: AppColors.green,
                    )),
                  ),
                ],
              ),
            ));
  }
}
