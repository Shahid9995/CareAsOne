import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/model/all_employers.dart';
import 'package:careAsOne/model/employees.dart';
import 'package:careAsOne/model/jobs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Response;

import 'button.dart';
import 'image.dart';
import 'misc.dart';
import 'text.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {Key? key,
      this.titleButton,
      this.date,
      this.heading,
      this.subHeading,
      this.location,
      this.description,
      this.imageUrl,
      this.onApply,
      this.jobType,
      this.experience,
      this.onTap,
      this.salary})
      : super(key: key);

  final String? heading;
  final String? subHeading;
  final String? location;
  final String? description;
  final String? imageUrl;
  final void Function()? onApply;
  final String? jobType;
  final String? experience;
  final String? salary;
  final String? titleButton;
  final String? date;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    //JobsModel jobsModel;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RectangularCachedImage(
                    height: 40.0,
                    fit: BoxFit.fitHeight,
                    imageUrl: imageUrl!,
                  ),
                  SubText('$date', size: 12.0, colorOpacity: 0.5),
                ],
              ),
              SizedBox(height: 10.0),
              InkWell(onTap: onTap, child: Heading('$heading')),
              SizedBox(height: 7.5),
              IconText(
                text: '$subHeading',
                icon: FontAwesomeIcons.building,
              ),
              SizedBox(height: 5.0),
              IconText(
                text: '$location',
                icon: Icons.location_pin,
              ),
              SizedBox(height: 10.0),
Container(height:150,child: Scrollbar(child: SingleChildScrollView(child: SubText('$description')))),
              // Html(data: description),
          // SubText('$description'),
              SizedBox(height: 15.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  // elevation: 0,
                  onPressed: onApply,
                  child: Text('$titleButton',style: TextStyle(color:AppColors.white),),
                  // textColor: AppColors.white,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        "$titleButton" == "Apply Now"
                            ? AppColors.green
                            : Colors.orange,
                          )),
                  // color: "$titleButton" == "Apply Now"
                  //     ? AppColors.green
                  //     : Colors.orange,
                ),
              ),
              SizedBox(height: 10.0),
              GetBuilder<PostCardController>(
                init: PostCardController(),
                builder: (_) => Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: _.getTags(jobType!, experience!, salary!),
                ),
              ),
              // SizedBox(height: 10.0),
            ],
          ),
        ),
        Divider(height: 0, color: AppColors.black.withOpacity(0.25)),
      ],
    );
  }
}

class PostCardController extends GetxController {
  List<JobsModel>? jobs;
  List<JobsModel>? responseData;

  List<Widget> getTags(String jobType, String experience, String salary) {
    List<String> tags;
    if (salary != "\$ null") {
      tags = ['$jobType', '$experience', '$salary'];
    } else {
      tags = ['$jobType', '$experience'];
    }

    List<Widget> widgetList = [];
    for (int i = 0; i < tags.length; i++) {
      widgetList.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          color: AppColors.bgGreen,
          child: SubText(tags[i], size: 12.0),
        ),
      );
    }
    return widgetList;
  }
}

class AppliedJobCard extends StatelessWidget {
  const AppliedJobCard(
      {Key? key,
      this.heading,
      this.location,
      this.salary,
      this.onView,
      this.time,
      this.status,
      this.onTap})
      : super(key: key);
  final String? heading;
  final String? location;
  final String? time;
  final String? status;
  final void Function()? onTap;
  final String? salary;
  final void Function()? onView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Heading('$heading')),
              InkWell(
                onTap: onView,
                child: SubText('VIEW', size: 12.0, color: AppColors.green),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          AppliedJobDetail(
            title: 'Location',
            value: '$location',
          ),
          '$salary' != '\$ null'
              ? AppliedJobDetail(
                  title: 'Salary',
                  value: '$salary',
                  valueColor: AppColors.green,
                )
              : SizedBox(),
          AppliedJobDetail(
            title: 'Applied on',
            value: '$time',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 65.0,
                  child: SubText('Status:'.toUpperCase(), size: 10.0)),
              SizedBox(width: 5.0),
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Color(0xFFF0F0EF),
                child: SubText('$status'),
              )
            ],
          ),
          SizedBox(height: 20.0),
          status == "Hired"
              ? SizedBox()
              : CustomButton(
                  onTap: onTap,
                  title: 'DELETE',
                ),
        ],
      ),
    );
  }
}
class PostJobCard extends StatelessWidget {
  const PostJobCard(
      {Key? key,
      this.jobTitle,
      this.onApplicantView,
      this.city,
      this.date,
      this.status,
      this.onEye,
      this.onEdit,
      this.onDelete,
      this.canSee = false})
      : super(key: key);
  final String? jobTitle;
  final String? city;
  final String? date;
  final String? status;
  final void Function()? onEye;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final void Function()? onApplicantView;
  final bool canSee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('Title', size: 12.0, color: AppColors.black)),
              Heading('$jobTitle'),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('City', size: 12.0, color: AppColors.black)),
              SubText("$city"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('Posted Date',
                      size: 12.0, color: AppColors.black)),
              SubText("$date"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('Status', size: 12.0, color: AppColors.black)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: status == "Active"
                      ? AppColors.bgGreen
                      : Colors.grey.withOpacity(0.3),
                  child: SubText("$status")),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      SubText('Actions', size: 12.0, color: AppColors.black)),
              Row(
                children: [



                  InkWell(
                    onTap: onEye,
                    child:  Card(elevation: 2,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: AppColors.bgGreen,
                      child: Text("Review Applicants",style: TextStyle(fontSize: 12),),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  /*     IconButton(
                      onPressed: ,
                      icon: Icon(
                          canSee
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye_rounded,
                          color: Colors.grey)),*/
                  InkWell(
                    onTap: onEdit,
                    child: Card(elevation: 2,
                    child:
                    Container(
                      padding: EdgeInsets.all(5),

                      color: AppColors.bgGreen,
                      child:  Text("Edit",style: TextStyle(fontSize: 12),),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
     /*             InkWell(
                    onTap: onDelete,
                    child: Card(elevation: 2,
                      child:
                      Container(
                        padding: EdgeInsets.all(5),
                        color: AppColors.bgGreen,
                        child: Text("Delete",style: TextStyle(fontSize: 12),),
                        ),
                      )
                  )*/


                ],
              )
            ],
          ),
          /* InkWell(
              onTap: onApplicantView,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: SubText(
                    "View Applicant",
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  )))*/
        ],
      ),
    );
  }
}

class JobApplicantCard extends StatelessWidget {
  const JobApplicantCard(
      {Key? key,
      this.jobTitle,
      this.onHire,
      this.onReject,
      this.experence,
      this.date,
      this.status,
      this.onEye,
      this.onCalender,
      this.onMail,
      this.canSee = false})
      : super(key: key);
  final String? jobTitle;
  final String? experence;
  final String? date;
  final String? status;
  final void Function()? onEye;
  final void Function()? onCalender;
  final void Function()? onMail;
  final void Function()? onHire;
  final void Function()? onReject;
  final bool canSee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      SubText('Applicant', size: 12.0, color: AppColors.black)),
              Heading('$jobTitle'),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('Experience:',
                      size: 12.0, color: AppColors.black)),
              SubText("$experence"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('Applied On',
                      size: 12.0, color: AppColors.black)),
              SubText("$date"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('Status', size: 12.0, color: AppColors.black)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: status!.toLowerCase() == "hired"
                      ? AppColors.bgGreen
                      : status!.toLowerCase() == "rejected"
                          ? Colors.red
                          : Colors.grey.withOpacity(0.3),
                  child: SubText(
                    "$status",
                    color: status!.toLowerCase() == "hired"
                        ? AppColors.green
                        : status!.toLowerCase() == "rejected"
                            ? Colors.white
                            : Colors.black,
                  )),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      SubText('Actions', size: 12.0, color: AppColors.black)),
              Row(
                children: [
                  Card(elevation: 2,
                    child: InkWell(
                      onTap: onEye,child:Container(
                      padding: EdgeInsets.all(5),
                      color: AppColors.bgGreen,

                      child: Text("Application",style: TextStyle(fontSize: 12),),
                    ),
                    ),
                  ),
             SizedBox(width: 5,),
             /*     IconButton(
                      onPressed: ,
                      icon: Icon(
                          canSee
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye_rounded,
                          color: Colors.grey)),*/
                  InkWell(
                    onTap: onCalender,
                    child: Card(elevation: 2,
                    child:
                    Container(
                    padding: EdgeInsets.all(5),

                    color: AppColors.bgGreen,
                    child: Text("Schedule",style: TextStyle(fontSize: 12),),
                    ),
                  ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                      onTap: onMail,
                      child:Card(elevation: 2,
                    child:
                    Container(
                    padding: EdgeInsets.all(5),
                    color: AppColors.bgGreen,
                    child: Text("Message",style: TextStyle(fontSize: 12),),
                  ),
                  )
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          status!.toLowerCase() != "pending"
              ? SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: onHire,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: SubText(
                              "Hire".toUpperCase(),
                              color: AppColors.green,
                              fontWeight: FontWeight.bold,
                              size: 16,
                            ))),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: onReject,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: SubText(
                              "Reject".toUpperCase(),
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              size: 16,
                            ))),
                  ],
                )
        ],
      ),
    );
  }
}

class EmployeeDetailCard extends StatelessWidget {
  const EmployeeDetailCard(
      {Key? key,
      this.jobTitle,
        this.isAllowDoc,
      this.select = false,
      this.isSelect,
      this.docLink,
      this.name,
      this.salary,
      this.email,
      this.status,
      this.onEye,
      this.onEdit,
      this.onDelete,
      this.canSee = false})
      : super(key: key);
  final String? jobTitle;
  final String? name;
  final String? email;
  final String? isAllowDoc;
  final String? salary;
  final String? docLink;
  final String? status;
  final void Function()? onEye;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final void Function(bool?)? isSelect;
  final bool canSee;
  final bool select;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(height: 15.0),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      SubText('SELECT:', size: 12.0, color: AppColors.black)),
              SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: Checkbox(value: select, onChanged: isSelect),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      SubText('EMPLOYEE:', size: 12.0, color: AppColors.black)),
              Heading('$name'),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('JOB TITLE:',
                      size: 12.0, color: AppColors.black)),
              Heading('$jobTitle'),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('EMAIL', size: 12.0, color: AppColors.black)),
              SubText("$email"),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('SALARY', size: 12.0, color: AppColors.black)),
              SubText("$salary"),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          isAllowDoc=="yes"?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      SubText('DOCUMENTS', size: 12.0, color: AppColors.black)),
              InkWell(
                onTap: onEye,
                child: Row(
                  children: [
                    Icon(
                        canSee
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye_rounded,
                        color: Colors.grey),
                    SizedBox(
                      width: 5,
                    ),
                    SubText("View Documents",
                        color: AppColors.green, fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ],
          ):SizedBox(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      SubText('ACTIONS', size: 12.0, color: AppColors.black)),
              Row(
                children: [


                  InkWell(
                      onTap: onEdit,
                      child: Card(elevation: 2,
                        child:
                        Container(
                          padding: EdgeInsets.all(5),
                          color: AppColors.bgGreen,
                          child: Text("Edit",style: TextStyle(fontSize: 12),),
                        ),
                      )
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                      onTap: onDelete,
                      child: Card(elevation: 2,
                        child:
                        Container(
                          padding: EdgeInsets.all(5),
                          color: AppColors.bgGreen,
                          child: Text("Delete",style: TextStyle(fontSize: 12),),
                        ),
                      )
                  ),
           /*       IconButton(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit, color: Colors.grey)),
                  IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_outline, color: Colors.grey)),*/
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class VideoInterviewCard extends StatelessWidget {
  const VideoInterviewCard({required this.name,required this.date,required this.videoLink});

  final String? date;
  final String? name;
  final void Function()? videoLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('APPLICANT NAME:',
                      size: 12.0, color: AppColors.black)),
              Heading(
                "$name",
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SubText('INTERVIEW DATE:',
                      size: 12.0, color: AppColors.black)),
              SubText('$date', size: 16.0, color: Colors.grey),
            ],
          ),
          SizedBox(height: 30.0),
          InkWell(
            onTap: videoLink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: SubText('VIDEO INTERVIEW:',
                        size: 12.0, color: AppColors.black)),
                Row(
                  children: [
                    Icon(
                      Icons.video_camera_back_outlined,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SubText(
                      'Start Meeting',
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final dynamic url;
  final String? title;
  final String? date;
  final int? length;
  final bool? isCheck;
  final void Function(bool?)? onChanged;

  const VideoCard(
      {Key? key,
      this.url,
      this.length,
      this.title,
      this.date,
      this.onChanged,
      this.isCheck = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            // alignment: AlignmentDirectional.center,
            children: [
              url != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      width: width(context) / 2.15,
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(),
                        child: url,
                      )
                      // Image.network(url)
                      ,
                    )
                  : Container(),
              Opacity(
                opacity: 0.45,
                child: Container(
                  width: width(context) / 2.15,
                  color: Colors.black,
                ),
              ),
              Checkbox(value: isCheck, onChanged: onChanged),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.play_arrow_rounded,
                      size: 28.0, color: AppColors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Container(
            width: width(context) / 2.15,
            child: SubText('$title',
                // '$url',
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: 5.0),
          Container(
            width: width(context) / 2.15,
            child: SubText('$date',
                size: 10.0,
                maxLines: 1,
                colorOpacity: 0.5,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class SeekerVideoCard extends StatelessWidget {
  final dynamic url;
  final String? title;
  final String? date;
  final int? length;

  const SeekerVideoCard({
    Key? key,
    this.url,
    this.length,
    this.title,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            // alignment: AlignmentDirectional.center,
            children: [
              url != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      width: width(context) / 2.15,
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(),
                        child: url,
                      ),
                    )
                  : Container(),
              Opacity(
                opacity: 0.45,
                child: Container(
                  width: width(context) / 2.15,
                  color: Colors.black,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.play_arrow_rounded,
                      size: 28.0, color: AppColors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Container(
            width: width(context) / 2.15,
            child: SubText('$title',
                // '$url',
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: 5.0),
          Container(
            width: width(context) / 2.15,
            child: SubText('$date',
                size: 10.0,
                maxLines: 1,
                colorOpacity: 0.5,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final bool isReceivedDoc;
  final bool isSignatureDoc;
  final dynamic docs;
  final void Function(bool?)? isCheck;
  final void Function()? onDelete;
  final void Function()? onView;
  final String? docType;
  final String? date;

  DocumentCard(
      {Key? key,
      this.isReceivedDoc = false,
      this.isSignatureDoc = false,
      this.onView,
      this.isCheck,
      this.onDelete,
        this.date,
      this.docType,
      this.docs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isReceivedDoc
                  ? SizedBox()
                  : SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: Checkbox(
                        value: docs.isSelected,
                        onChanged: isCheck,
                      )),
              SizedBox(width: 5.0),
              Expanded(child: Heading('${docs.name}'))
            ],
          ),
          SizedBox(height: 15.0),
          Row(
            children: [
              SubText('DOCUMENT:', size: 10.0),
              SizedBox(width: 5.0),
              SizedBox(
                  height: 20.0,
                  child: Image.asset(docType!.contains(".pdf")
                      ? 'assets/images/pdf.png'
                      : "assets/images/docx.png")),
            ],
          ),
          SizedBox(height: 7.5),
          Row(
            children: [
              SubText('Date:', size: 10.0),
              SizedBox(width: 5.0),
         Text("$date",style: TextStyle(fontSize: 10),)
            ],
          ),
          SizedBox(height: 7.5),
          Row(
            children: [
              SubText('TYPE:', size: 10.0),
              SizedBox(width: 5.0),
              Expanded(
                child: SubText('${docs.type.toString().capitalizeFirst}',
                    size: 12.0, color: AppColors.black, colorOpacity: 0.7),
              ),
              IconButton(
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.grey[400],
                ),
                onPressed: onView,
              )
            ],
          ),
          // if (isReceivedDoc || isSignatureDoc)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 7.5),
          //     child: Row(
          //       children: [
          //         SubText('DATE:', size: 10.0),
          //         SizedBox(width: 5.0),
          //         Expanded(
          //           child: SubText('$docs.date',
          //               size: 12.0, color: AppColors.black, colorOpacity: 0.7),
          //         ),
          //       ],
          //     ),
          //   ),
          SizedBox(height: 10.0),
          if (isSignatureDoc)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SubText('STATUS:', size: 10.0),
                SizedBox(width: 5.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: AppColors.green,
                  child: SubText('Approved', color: AppColors.white),
                )
              ],
            ),
          if (isReceivedDoc)
            Padding(
              padding: const EdgeInsets.only(top: 7.5),
              child: Row(
                children: [
                  SubText('SENDER:', size: 10.0),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: SubText(
                        '${docs.employeeDoc[0].firstName} ${docs.employeeDoc[0].lastName}',
                        size: 12.0,
                        color: AppColors.black,
                        colorOpacity: 0.7),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20.0),
          CustomButton(
            onTap: onDelete,
            title: 'DELETE',
          ),
        ],
      ),
    );
  }
}

class SignatureCard extends StatelessWidget {
  final bool? isReceivedDoc;
  final bool isSignatureDoc;
  final String? title;
  final String? status;
  final void Function()? onDownload;

  SignatureCard(
      {Key? key,
    this.isReceivedDoc,
      required this.isSignatureDoc,
      this.status,
      this.onDownload,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SubText("TEMPLATE NAME:", size: 12),
              SizedBox(
                width: width(context) / 15,
              ),
              Heading('$title'),
            ],
          ),
          // SizedBox(height: 15.0),
          // Row(
          //   children: [
          //     SubText('DOCUMENT:', size: 10.0),
          //     SizedBox(width: 5.0),
          //     SizedBox(height: 20.0, child: Image.asset('assets/images/pdf.png')),
          //   ],
          // ),
          // SizedBox(height: 7.5),
          // Row(
          //   children: [
          //     SubText('TYPE:', size: 10.0),
          //     SizedBox(width: 5.0),
          //     Expanded(
          //       child: SubText('Document', size: 12.0, color: AppColors.black, colorOpacity: 0.7),
          //     ),
          //   ],
          // ),
          // if (isReceivedDoc || isSignatureDoc)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 7.5),
          //     child: Row(
          //       children: [
          //         SubText('DATE:', size: 10.0),
          //         SizedBox(width: 5.0),
          //         Expanded(
          //           child: SubText('04/05/2021',
          //               size: 12.0, color: AppColors.black, colorOpacity: 0.7),
          //         ),
          //       ],
          //     ),
          //   ),
          SizedBox(height: 10.0),
          if (isSignatureDoc)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SubText('STATUS:', size: 10.0),
                SizedBox(width: width(context) / 7),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: AppColors.green.withOpacity(0.1),
                  child: SubText(status.toString(), color: AppColors.green),
                )
              ],
            ),
          // if (isReceivedDoc)
          Padding(
            padding: const EdgeInsets.only(top: 7.5),
            child: Row(
              children: [
                SubText('ACTIONS:', size: 10.0),
                SizedBox(width: width(context) / 10),
                InkWell(
                  onTap: onDownload,
                  child: Row(
                    children: [
                      Icon(Icons.download, color: Colors.grey),
                      SubText(
                        "DOWNLOAD",
                        color: AppColors.green,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: InkWell(
                onTap: () {},
                child: SubText(
                  "REQUEST SIGNATURE",
                  color: AppColors.green,
                )),
          ),
          SizedBox(height: 20.0),
          // isSignatureDoc
          //     ? SizedBox()
          //     : CustomButton(
          //         onTap: onDelete,
          //         title: 'DELETE',
          //       ),
        ],
      ),
    );
  }
}

class UploadDocumentCard extends StatelessWidget {
  final bool isReceivedDoc;
  final bool isSignatureDoc;
  final String? tilte;
  final String? docName;
  final String? format;

  UploadDocumentCard(
      {Key? key,
      required this.isReceivedDoc,
      required this.isSignatureDoc,
      this.tilte,
      this.docName,
      this.format})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.3))),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 20.0, child: Image.asset('assets/images/file.png')),
                SizedBox(width: 5.0),
                Expanded(child: Heading(tilte.toString())),
                SizedBox(width: 10.0),
                /*SubText('(1 uploaded file)',
                    size: 10.0, color: Colors.grey.withOpacity(0.4)),*/
              ],
            ),
            SizedBox(height: 15.0),
            Container(
                width: width(context),
                height: 45,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                ),
                child: Text(docName.toString())),
            SizedBox(height: 7.5),
            Row(
              children: [
                SubText('Format:',
                    size: 12.0, color: AppColors.black, colorOpacity: 0.7),
                SizedBox(width: 5.0),
                Expanded(
                  child: SubText((format.toString()),
                      size: 12.0, color: AppColors.black, colorOpacity: 0.7),
                ),
              ],
            ),
            // if (isReceivedDoc || isSignatureDoc)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 7.5),
            //     child: Row(
            //       children: [
            //         SubText('DATE:', size: 10.0),
            //         SizedBox(width: 5.0),
            //         Expanded(
            //           child: SubText('04/05/2021',
            //               size: 12.0, color: AppColors.black, colorOpacity: 0.7),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class ShareDocumentCard extends StatelessWidget {
  const ShareDocumentCard({required this.onSelect,required this.employees});

  final void Function(bool?)? onSelect;
  final Employees employees;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child:
                    Checkbox(value: employees.isSelected, onChanged: onSelect),
              ),
              SizedBox(width: 5.0),
              Expanded(child: Heading('${employees.name}')),
            ],
          ),
          // SizedBox(height: 15.0),
          SizedBox(height: 15.0),
          Row(
            children: [
              SubText('Job Title:', size: 10.0),
              SizedBox(width: 5.0),
              Expanded(
                child: SubText('${employees.jobTitle}',
                    size: 12.0, color: AppColors.black, colorOpacity: 0.7),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SubText('EMAIL:', size: 10.0),
              SizedBox(width: 5.0),
              Expanded(
                child: SubText('${employees.email}',
                    size: 12.0, color: AppColors.black, colorOpacity: 0.7),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SubText('SALARY:', size: 10.0),
              SizedBox(width: 5.0),
              Expanded(
                child: SubText('${employees.salary}',
                    size: 12.0, color: AppColors.black, colorOpacity: 0.7),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SubText('Status:', size: 10.0),
              SizedBox(width: 5.0),
              Expanded(
                child: SubText(
                    '${employees.status == 1 ? "Enable" : "Disable"}',
                    size: 12.0,
                    color: AppColors.black,
                    colorOpacity: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SeekerShareCard extends StatelessWidget {
  const SeekerShareCard({required this.onSelect,required this.allEmployer});

  final void Function(bool?)? onSelect;
  final AllEmployer allEmployer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Divider(height: 0.0, thickness: 2.0, color: AppColors.green),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: Checkbox(
                    value: allEmployer.isSelected, onChanged: onSelect),
              ),
              SizedBox(width: 5.0),
              Expanded(child: Heading('${allEmployer.firstName}')),
            ],
          ),
          // SizedBox(height: 15.0),
          SizedBox(height: 15.0),
          Row(
            children: [
              SubText('Phone:', size: 10.0),
              SizedBox(width: 5.0),
              Expanded(
                child: SubText('${allEmployer.phoneNumber}',
                    size: 12.0, color: AppColors.black, colorOpacity: 0.7),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SubText('EMAIL:', size: 10.0),
              SizedBox(width: 5.0),
              Expanded(
                child: SubText('${allEmployer.email}',
                    size: 12.0, color: AppColors.black, colorOpacity: 0.7),
              ),
            ],
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isSender;

  String? message;
  String? time;

  ChatBubble(
      {
        required this.isSender,

      this.message,
      this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: isSender ? AppColors.bgGreen : AppColors.white,
        border: Border.all(
            color: isSender
                ? AppColors.bgGreen
                : AppColors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(isSender ? 20.0 : 0.0),
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(isSender ? 0.0 : 20.0),
        ),
      ),
      child: Column(
        children: [

           Row(
                children: [
                  Flexible(
                    child: SubText(
                      '$message',
                      colorOpacity: 0.8,
                    ),
                  ),

              ],
            ),
          SizedBox(height: 7.5),
          Align(
            alignment: Alignment.topRight,
            child: SubText('$time', colorOpacity: 0.5),
          ),
        ],
      ),
    );
  }
}
