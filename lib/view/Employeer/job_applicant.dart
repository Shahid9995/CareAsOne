
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/job_applicant.dart';
import 'package:careAsOne/view/Employeer/chat_page_employer.dart';
import 'package:careAsOne/view/Employeer/employer_message.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobApplicants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobApplicantsController>(
        init: JobApplicantsController(),
        builder: (_) => Scaffold(
            backgroundColor: AppColors.bgGreen,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              automaticallyImplyLeading: false,
              title:Container( height: 40,width: 40,
                  child: Image.asset('assets/images/playstore.png', fit: BoxFit.fitWidth)),
              actions: [
                UnReadMsgIconButton(
                  onTap: () {
                    Get.to(() => EmployerMessage());
                  },
                  msgNumber: 0,
                ),
                InkWell(
                  onTap: () {
                    //  if(_.scaffoldKey.currentState.isDrawerOpen){
                    //  scaffoldKeyApplicant.currentState.openEndDrawer();
                    Get.back();
                    // }else{
                    //   _.scaffoldKey.currentState.openDrawer();
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                 child: IconButton(icon: Icon(Icons.exit_to_app_rounded,color: AppColors.green,),onPressed: (){Get.back();},),
                  ),
                ),
              ],
            ),

            body: Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              margin: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: _.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.green)),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios,
                                        size: 16,
                                      ),
                                      Text("Back"),
                                    ],
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              MainHeading(
                                'Applicant Details',
                                size: 22,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          SubText("Job Details",
                              size: 20, color: AppColors.green),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubText(
                                "Title:",
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                _.jobsModel!.title!,
                                size: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubText(
                                "City:",
                                color: Colors.grey,
                                size: 14,
                              ),
                              Flexible(
                                child: SubText(
                                  _.jobsModel!.city!,
                                  overflow: TextOverflow.fade,
                                  size: 14,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubText(
                                "State:",
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                _.jobsModel!.state!,
                                size: 14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubText(
                                "Zip Code:",
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                _.jobsModel!.zipCode!,
                                size: 14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubText(
                                "Salary:",
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                '\$${_.jobsModel!.salary}',
                                size: 14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubText(
                                "Minimum Experience:",
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                _.jobsModel!.experience!,
                                size: 14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubText(
                                "Schedule:",
                                color: Colors.grey,
                                size: 14,
                              ),
                              SubText(
                                _.jobsModel!.schedule!,
                                size: 14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SubText(
                            "Job Description:",
                            color: Colors.grey,
                            size: 14,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SubText(
                            _.jobsModel!.description!,
                            size: 14,
                          ),
                          SizedBox(height: 20.0),
                        Divider(),
                          SubText("Applicants",
                              size: 20, color: AppColors.green),
                          _.jobsApplicantModel == null ||
                                  _.jobsApplicantModel!.isEmpty
                              ? Center(
                                  child: SubText(
                                    "No Applicants Found",
                                    size: 18,
                                    color: Colors.grey[300],
                                  ),
                                )
                              : Column(
                                  children: List.generate(
                                      _.jobsApplicantModel!.length, (index) {
                                    return _.filterStatus == null ||
                                            _.filterStatus == "" &&
                                                _.filterExp == null ||
                                            _.filterExp == ""
                                        ? Column(
                                          children: [
                                            JobApplicantCard(
                                                jobTitle: "${_
                                                    .jobsApplicantModel![index]
                                                    .applicant!
                                                    .firstName} ${_
                                                    .jobsApplicantModel![index]
                                                    .applicant!
                                                    .lastName}",
                                                experence: _
                                                    .jobsApplicantModel![index]
                                                    .applicant!
                                                    .jobSeekerDetails!=null?_
                                                    .jobsApplicantModel![index]
                                                    .applicant!
                                                    .jobSeekerDetails!
                                                    .yearOfExperience:"0",
                                                date: "${_.jobsApplicantModel![index].appliedOn}"
                                                    .split(" ")[0],
                                                status: _.jobsApplicantModel![index]
                                                    .status!.capitalizeFirst,
                                                onReject: () {
                                                  _.rejectApplicant(
                                                      context,
                                                      _.jobsApplicantModel![index]
                                                          .applicantId,
                                                      param: {
                                                        "job_id": _.jobsModel!.id!,
                                                        "applicant_id": _
                                                            .jobsApplicantModel![
                                                                index]
                                                            .applicantId
                                                      });
                                                },
                                                onHire: () {
                                                  _.hireApplicant(
                                                      context,
                                                      _.jobsApplicantModel![index]
                                                          .applicantId,
                                                      param: {
                                                        "job_id": _.jobsModel!.id,
                                                        "applicant_id": _
                                                            .jobsApplicantModel![
                                                                index]
                                                            .applicantId
                                                      });
                                                },
                                                onEye: () {
                                                  Get.toNamed(
                                                      AppRoute
                                                          .viewApplicantDetailRoute,
                                                      arguments: {
                                                        "applicantModel":
                                                            _.jobsApplicantModel![
                                                                index],
                                                        "jobModel": _.jobsModel,
                                                      });
                                                },
                                                onCalender: () {
                                                  _.viewSchedule(context, param: {
                                                    "jobId": _.jobsModel!.id!,
                                                    "applicantId": _
                                                        .jobsApplicantModel![index]
                                                        .applicantId,
                                                    "api_token": _.token,
                                                  });
                                                },
                                                onMail: () async {
                                                  Get.to(()=>ChatEmployerPage(),arguments: [
                                                    "${_.jobsApplicantModel![index].applicant!.firstName}",
                                                    "${_.jobsApplicantModel![index].applicant!.lastName}",
                                                    "${_.jobsApplicantModel![index].applicant!.profileImage}",
                                                    "${_.jobsApplicantModel![index].applicantId}",
                                                  "${_.jobsApplicantModel![index].id}",
                                                    "${_.jobsApplicantModel![index].status}",
                                                    "${_.jobsApplicantModel![index].applicant!.status}",
                                                    "${_.jobsApplicantModel![index].applicant!.deviceToken}"]);
                                                },
                                                canSee: true),
                                            Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
                                          ],
                                        )
                                        : _.filterStatus == null ||
                                                _.filterStatus == "" &&
                                                    _.filterExp ==
                                                        _
                                                            .jobsApplicantModel![
                                                                index]
                                                            .applicant!
                                                            .jobSeekerDetails!
                                                            .yearOfExperience
                                            ? JobApplicantCard(
                                                jobTitle: _
                                                    .jobsApplicantModel![index]
                                                    .applicant!
                                                    .firstName,
                                                experence: _
                                                    .jobsApplicantModel![index]
                                                    .applicant!
                                                    .jobSeekerDetails!
                                                    .yearOfExperience,
                                                date: "${_.jobsApplicantModel![index].appliedOn}"
                                                    .split(" ")[0],
                                                status: _
                                                    .jobsApplicantModel![index]
                                                    .status!.capitalizeFirst,
                                                onReject: () {
                                                  _.rejectApplicant(
                                                      context,
                                                      _
                                                          .jobsApplicantModel![
                                                              index]
                                                          .applicantId,
                                                      param: {
                                                        "job_id":
                                                            _.jobsModel!.id!,
                                                        "applicant_id": _
                                                            .jobsApplicantModel![
                                                                index]
                                                            .applicantId
                                                      });
                                                },
                                                onHire: () {
                                                  _.hireApplicant(
                                                      context,
                                                      _
                                                          .jobsApplicantModel![
                                                              index]
                                                          .applicantId,
                                                      param: {
                                                        "job_id":
                                                            _.jobsModel!.id,
                                                        "applicant_id": _
                                                            .jobsApplicantModel![
                                                                index]
                                                            .applicantId,
                                                      });
                                                },
                                                onEye: () {
                                                  Get.toNamed(
                                                      AppRoute
                                                          .viewApplicantDetailRoute,
                                                      arguments: {
                                                        "applicantModel":
                                                            _.jobsApplicantModel![
                                                                index],
                                                        "jobModel": _.jobsModel,
                                                      });
                                                },
                                                onCalender: () {
                                                  _.viewSchedule(context,
                                                      param: {
                                                        "jobId": _.jobsModel!.id!,
                                                        "applicantId": _
                                                            .jobsApplicantModel![
                                                                index]
                                                            .applicantId,
                                                        "api_token": _.token,
                                                      });
                                                },
                                                onMail: () async {

                                                },
                                                canSee: true)
                                            : _.filterStatus == _.jobsApplicantModel![index].status && _.filterExp == null ||
                                                    _.filterExp == ""
                                                ? JobApplicantCard(
                                                    jobTitle: _.jobsApplicantModel![index].applicant!.firstName,
                                                    experence: _.jobsApplicantModel![index].applicant!.jobSeekerDetails!.yearOfExperience,
                                                    date: "${_.jobsApplicantModel![index].appliedOn}".split(" ")[0],
                                                    status: _.jobsApplicantModel![index].status,
                                                    onReject: () {
                                                      _.rejectApplicant(
                                                          context,
                                                          _
                                                              .jobsApplicantModel![
                                                                  index]
                                                              .applicantId,
                                                          param: {
                                                            "job_id":
                                                                _.jobsModel!.id!,
                                                            "applicant_id": _
                                                                .jobsApplicantModel![
                                                                    index]
                                                                .applicantId
                                                          });
                                                    },
                                                    onHire: () {
                                                      _.hireApplicant(
                                                          context,
                                                          _
                                                              .jobsApplicantModel![
                                                                  index]
                                                              .applicantId,
                                                          param: {
                                                            "job_id":
                                                                _.jobsModel!.id!,
                                                            "applicant_id": _
                                                                .jobsApplicantModel![
                                                                    index]
                                                                .applicantId
                                                          });
                                                    },
                                                    onEye: () {
                                                      Get.toNamed(
                                                          AppRoute
                                                              .viewApplicantDetailRoute,
                                                          arguments: {
                                                            "applicantModel":
                                                                _.jobsApplicantModel![
                                                                    index],
                                                            "jobModel":
                                                                _.jobsModel,
                                                          });
                                                    },
                                                    onCalender: () {
                                                      _.viewSchedule(context,
                                                          param: {
                                                            "jobId":
                                                                _.jobsModel!.id!,
                                                            "applicantId": _
                                                                .jobsApplicantModel![
                                                                    index]
                                                                .applicantId,
                                                            "api_token":
                                                                _.token,
                                                          });
                                                    },
                                                    onMail: () async {
                                                    },
                                                    canSee: true)
                                                : _.filterStatus == _.jobsApplicantModel![index].status && _.filterExp == _.jobsApplicantModel![index].applicant!.jobSeekerDetails!.yearOfExperience
                                                    ? JobApplicantCard(
                                                        jobTitle: _.jobsApplicantModel![index].applicant!.firstName,
                                                        experence: _.jobsApplicantModel![index].applicant!.jobSeekerDetails!.yearOfExperience,
                                                        date: "${_.jobsApplicantModel![index].appliedOn}".split(" ")[0],
                                                        status: _.jobsApplicantModel![index].status,
                                                        onReject: () {
                                                          _.rejectApplicant(
                                                              context,
                                                              _
                                                                  .jobsApplicantModel![
                                                                      index]
                                                                  .applicantId,
                                                              param: {
                                                                "job_id": _
                                                                    .jobsModel!
                                                                    .id,
                                                                "applicant_id": _
                                                                    .jobsApplicantModel![
                                                                        index]
                                                                    .applicantId
                                                              });
                                                        },
                                                        onHire: () {
                                                          _.hireApplicant(
                                                              context,
                                                              _
                                                                  .jobsApplicantModel![
                                                                      index]
                                                                  .applicantId,
                                                              param: {
                                                                "job_id": _
                                                                    .jobsModel!
                                                                    .id,
                                                                "applicant_id": _
                                                                    .jobsApplicantModel![
                                                                        index]
                                                                    .applicantId
                                                              });
                                                        },
                                                        onEye: () {
                                                          Get.toNamed(
                                                              AppRoute
                                                                  .viewApplicantDetailRoute,
                                                              arguments: {
                                                                "applicantModel":
                                                                    _.jobsApplicantModel![
                                                                        index],
                                                                "jobModel":
                                                                    _.jobsModel,
                                                              });
                                                        },
                                                        onCalender: () {
                                                          _.viewSchedule(
                                                              context,
                                                              param: {
                                                                "jobId": _
                                                                    .jobsModel!
                                                                    .id,
                                                                "applicantId": _
                                                                    .jobsApplicantModel![
                                                                        index]
                                                                    .applicantId,
                                                                "api_token":
                                                                    _.token,
                                                              });
                                                        },
                                                        onMail: () async {
                                                          //  await _.showSelectionDialog(context, _.jobsModel[index].id);
                                                        },
                                                        canSee: true)
                                                    : SizedBox();
                                  }),
                                )
                        ],
                      ),
              ),
            )));
  }
}
