import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/homepage.dart';
import 'package:careAsOne/view/Employeer/home_container.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmpHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    // final landscape = Get.por;
    return GetBuilder<EmpHomeController>(
        init: EmpHomeController(),
        builder: (_) => Scaffold(
              backgroundColor: AppColors.bgGreen,
              key: _.scaffoldKeyEmployer,
              body: _.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.green)),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 30.0),
                          width: double.maxFinite,
                          color: AppColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainHeading('Dashboard'),
                              SizedBox(height: 35.0),
                              MainHeading(
                                'Hi, ${_.empProfileModel!.firstName!.capitalizeFirst}',
                                size: 30,
                              ),
                              SizedBox(height: 20.0),
                              SubText(
                                "We are glad to see you again!",
                                color: Colors.grey.withOpacity(0.5),
                                size: 18,
                              ),
                              HomeContainer(
                                  width: width,
                                  height: height,
                                  btnText: "View All Applicants",
                                  text: "Total Applicants",
                                  count: _.empDashboardModel != null
                                      ? _.empDashboardModel!.totalApplicants
                                          .toString()
                                      : "0",
                                  cntxt: context,
                                  onTap: () {
                                    _.homeMaster.navigateToPage(4);
                                  },
                                  image: "employee.png"),
                              HomeContainer(
                                  width: width,
                                  height: height,
                                  btnText: "View More",
                                  text: "Applicants Hired",
                                  count: _.empDashboardModel != null
                                      ? _.empDashboardModel!.totalHire.toString()
                                      : "0",
                                  onTap: () {
                                    _.homeMaster.navigateToPage(2);
                                  },
                                  cntxt: context,
                                  image: "sticky.png"),
                              HomeContainer(
                                  width: width,
                                  height: height,
                                  btnText: "Details",
                                  text: "Active Subscription",
                                  count: _.empDashboardModel != null
                                      ? _.empDashboardModel!.result!.plan
                                      : "No Plan",
                                  cntxt: context,
                                  onTap: () {
                                    _.homeMaster.navigateToPage(6);
                                    // Get.to(SubscriptionDetails());
                                  },
                                  image: "subscription.png"),
                            ],
                          ),
                        ),
                      ),
                    ),
            ));
  }
}
