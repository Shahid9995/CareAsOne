import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/docs.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class EmpSignatureDocPage extends StatefulWidget {
  final EmpDocsController controller;

  EmpSignatureDocPage(this.controller);

  @override
  _EmpSignatureDocPageState createState() => _EmpSignatureDocPageState();
}

class _EmpSignatureDocPageState extends State<EmpSignatureDocPage> {
  ReceivePort _port = ReceivePort();

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: widget.controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.green)),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  CustomTransparentButton(
                    onTap: () {
                      Get.toNamed(AppRoute.addTemplateRoute);
                    },
                    icon: Icons.add,
                    title: 'ADD NEW TEMPLATE',
                  ),
                  SizedBox(height: 25.0),
                  SizedBox(height: 5.0),
                  Column(
                    children: List.generate(
                        widget.controller.signatureDocsList.length, (index) {
                      return SignatureCard(
                        // onDelete: (){},
                        onDownload: () async {
                          var androidPath;
                          try {
                            androidPath =
                                await AndroidPathProvider.downloadsPath;
                          } catch (e) {
                            final directory =
                                await getExternalStorageDirectory();
                            androidPath = directory?.path;
                          }
                          var newPath = Directory(androidPath);
                          bool hasExisted = await newPath.exists();
                          if (!hasExisted) {
                            newPath.create();
                          }
                          String url =
                              '${widget.controller.signatureDocsList[index].file}';
                        },

                        isSignatureDoc: true,
                        title: widget
                            .controller.signatureDocsList[index].templateName,
                        status:
                            widget.controller.signatureDocsList[index].status,
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }


}
