import 'dart:io';

import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/add_doc.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDocPage extends StatelessWidget {
  const AddDocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddDocsController>(
        init: AddDocsController(),
        builder: (_) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close, size: 28.0, color: AppColors.black),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MainHeading('Upload Files'),
                  SizedBox(height: 30.0),
                  DottedBorder(
                    color: AppColors.green,
                    dashPattern: [10, 6],
                    borderType: BorderType.Rect,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      width: double.maxFinite,
                      height: 200,
                      color: AppColors.bgGreen,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.green)),
                                )
                              : Column(
                                  children: [
                                    Container(
                                        height: 50.0,
                                        child: Image.asset(
                                            'assets/images/folder.png')),
                                    SubText('Select needed file', size: 16.0),
                                  ],
                                ),
                          _.file!=null
                              ? SizedBox(
                                  width: 110.0,
                                  child: CustomButton(
                                    title: "upload",
                                    btnColor: AppColors.green,
                                    textColor: Colors.white,
                                    onTap: () {
                                      _.uploadDocument(context, _.file!);
                                    },
                                  ),
                                )
                              : SizedBox(
                                  width: 110.0,
                                  child: CustomButton(
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles();

                                      if (result != null) {
                                        _.file = File(result.files.single.path!);
                                        if(_.file!.path.contains(".pdf")||_.file!.path.contains(".docx")){
                                          _.update();
                                          showToast(msg: "File Selected");
                                        }else{
                                          showToast(msg:"Document must be PDF or Docx");
                                        }

                                      } else {
                                        showToast(msg: "File not Selected");
                                      }
                                    },
                                    title: 'BROWSE FILE',
                                    btnColor: AppColors.bgGreen,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
