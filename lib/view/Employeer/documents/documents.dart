import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/controller/Employeer/docs.dart';
import 'package:careAsOne/view/Employeer/documents/emp_Shared_doc.dart';
import 'package:careAsOne/view/Employeer/documents/upload_emp.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmpDocumentsPage extends StatelessWidget {
  const EmpDocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmpDocsController>(
        init: EmpDocsController(),
        builder: (_) {
          return DefaultTabController(
            length: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, top: 30.0),
                  width: double.maxFinite,
                  color: AppColors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainHeading('Documents'),
                      SizedBox(height: 15.0),
                      Container(
                        child: TabBar(
                       isScrollable: true,
                          indicatorWeight: 3.0,
                          indicatorColor: AppColors.green,
                          labelColor: AppColors.green,
                          unselectedLabelColor: AppColors.black,
                          labelStyle: TextStyle(
                              fontSize: 14.0,),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 5.0),
                          tabs: [
                            Tab(text: 'DOCUMENTS'),
                            Tab(text: 'SHARED DOCUMENTS'),
                           // Tab(text: 'SIGNATURE'),
                          ],
                        ),
                      ),
                      Container(
                        height: height(context) / 1.422,
                        child: TabBarView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3.5),
                              child: EmpUploadDocPage(_),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3.5),
                              child: EmpSharedDocPage(_),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
