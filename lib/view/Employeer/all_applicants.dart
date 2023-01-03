import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/all_applicants.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllApplicants extends StatefulWidget {
  @override
  _AllApplicantsState createState() => _AllApplicantsState();
}
class _AllApplicantsState extends State<AllApplicants> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllApplicantsController>(
      init: AllApplicantsController(),
      builder: (_) =>
          _.isLoading
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
                          MainHeading('Manage Jobs'),
                          SizedBox(height: 35.0),
                          SizedBox(height: 20.0),
                          CustomTransparentButton(
                            icon: Icons.add,
                            title: "POST JOB",
                            textColor: AppColors.green,
                            onTap: () {
                              if (_.userJobService.jobsModel.length <
                                  _.empProfileModel!.allowedJobLimit!) {
                                if(_.companyProfile!.name!=null){
                                  Get.toNamed(AppRoute.postJobRoute);
                                }else{
                                  showToast(msg:"Please complete your company details first",backgroundColor: Colors.red);
                                }

                              } else {
                                showToast(msg: "Maximum Job Limit Reached");
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          _.userJobService.jobsModel == null ||
                                  _.userJobService.jobsModel.isEmpty
                              ? SubText(
                                  "No Jobs Found",
                                  size: 18,
                                  color: Colors.grey[300],
                                )
                              : Column(
                                  children: List.generate(
                                      _.userJobService.jobsModel.length,
                                      (index) {
                                    return PostJobCard(
                                        jobTitle: _.userJobService
                                            .jobsModel[index].title,
                                        city: _.userJobService.jobsModel[index]
                                            .city,
                                        date:
                                            "${_.userJobService.jobsModel[index].postedDate}"
                                                .split(" ")[0],
                                        status: _
                                            .userJobService
                                            .jobsModel[index]
                                            .status!.capitalizeFirst
                                            ,
                                        onEye: () {
                                          Get.toNamed(
                                              AppRoute.jobApplicantRoute,
                                              arguments: {
                                                "jobModel": _.userJobService
                                                    .jobsModel[index]
                                              });
                                        },
                                        onEdit: () {
                                          Get.toNamed(AppRoute.postJobRoute,
                                              arguments: {
                                                "postModel": _.userJobService
                                                    .jobsModel[index],
                                              });
                                        },
                                        onDelete: () async {
                                          await _.showSelectionDialog(
                                              context,
                                              _.userJobService.jobsModel[index]
                                                  .id);
                                        },
                                        canSee: true);
                                  }),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
      // )
    );
  }
}
