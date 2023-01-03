import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/JobSeeker/jobseeker_doc_controller.dart';
import 'package:careAsOne/view/documents/received.dart';
import 'package:careAsOne/view/documents/upload.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    print("==========DocumentsPage===============");
    return GetBuilder<JobSeekerDocsController>(
        init: JobSeekerDocsController(),
        builder: (_) => SingleChildScrollView(
              child: Container(
                  width: width,
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                  margin: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainHeading('Documents'),
                          SizedBox(height: 15.0),
                          Center(
                            child: TabBar(
                              isScrollable: true,
                              indicatorWeight: 3.0,
                              indicatorColor: AppColors.green,
                              labelColor: AppColors.green,
                              unselectedLabelColor: AppColors.black,
                              labelStyle: TextStyle(fontSize: 12.0),
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              tabs: [
                                Tab(text: 'UPLOAD DOCUMENTS'),
                                Tab(text: 'RECEIVED DOCUMENTS'),
                              ],
                            ),
                          ),
                          Container(
                            height: height(context) * 0.65,
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.5),
                                  child: UploadDocPage(_),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.5),
                                  child: ReceivedDocPage(_),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ));
  }
}
