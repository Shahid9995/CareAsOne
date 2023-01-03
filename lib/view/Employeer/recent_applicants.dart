import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/recent_applicants.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentApplicantsPage extends StatelessWidget {
  const RecentApplicantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecentApplicantsController>(
        init: RecentApplicantsController(),
        builder: (_) {
          return Scaffold(
              key: _.scaffoldKey,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: AppColors.white,
                automaticallyImplyLeading: false,
                title:
                Container( height: 40,width: 40,
                    child: Image.asset('assets/images/playstore.png', fit: BoxFit.fitWidth)),
                actions: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(
                          Icons.exit_to_app_sharp,
                          color: AppColors.green,
                        )),
                  ),
                ],
              ),
              body: _.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          backgroundColor: AppColors.green,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.green)),
                    )
                  : Container(
                      width: double.infinity,
                      color: AppColors.bgGreen,
                      height: double.infinity,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            _.recentApplicants == null
                                ? Center(
                                    child: SubText(
                                      "No Applicants found",
                                      size: 18,
                                      color: Colors.grey[300],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: MainHeading("Recent Applicants"),
                                      ),
                                      Column(
                                        children: List.generate(
                                            _.recentApplicants!.length, (index) {
                                          return Container(
                                            // margin: EdgeInsets.all(10),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                elevation: 5,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SubText(
                                                            "Applicant:",
                                                            size: 15,
                                                          ),
                                                          SizedBox(height: 10),
                                                          SubText(
                                                            "Email:",
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          SubText(
                                                            "Applied On:",
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          SubText(
                                                            "Status:",
                                                            size: 15,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          SubText(
                                                            "${_.recentApplicants![index].name}",
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          SubText(
                                                            "${_.recentApplicants![index].email}",
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          SubText(
                                                            "${_.recentApplicants![index].appliedOn}",
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          SubText(
                                                            "${_.recentApplicants![index].status}",
                                                            size: 15,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ));
        });
  }
}
