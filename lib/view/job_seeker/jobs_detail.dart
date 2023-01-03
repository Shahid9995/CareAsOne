import 'package:cached_network_image/cached_network_image.dart';
import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/jobs_details_controller.dart';
import 'package:careAsOne/view/messages/messages.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/misc.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class JobsDetails extends StatelessWidget {
  const JobsDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobsDetailsController>(
      init: JobsDetailsController(),
      builder: (_) => Scaffold(
        backgroundColor: AppColors.bgGreen,
        appBar: AppBar(
          elevation: 5.0,
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          title:Container( height: 40,width: 40,
              child: Image.asset('assets/images/playstore.png', fit: BoxFit.fitWidth)),
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
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.exit_to_app_rounded,color: AppColors.green,),

              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          height: double.infinity,
          child: _.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.green,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:"${_.logo[0].logo}"=="null"||"${_.logo[0].logo}"==""||_.logo.isEmpty?"https://www.gravatar.com/avatar/159dca37d8cbb410c9075424bd6276b7?d=mm&s=250":
                                    "${BaseApi.domainName}${_.logo[0].logo}"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MainHeading("${_.jobDetail!.title!.capitalize}"),
                        SizedBox(
                          height: 20,
                        ),


                       _.jobDetail!.company==null?SizedBox(): IconText(
                          text: '${_.jobDetail!.company!.name!.capitalizeFirst}',
                          icon: FontAwesomeIcons.building,
                        ),
                            SizedBox(height: 10,),
                            IconText(
                              text: '${_.jobDetail!.city}|${_.jobDetail!.state}',
                              icon: Icons.location_pin,
                            ),


                        SizedBox(height: 10.0),
                        SubText(
                          "\$ ${_.jobDetail!.salary}",
                          color: AppColors.green,
                        ),
                 
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            if(_.data[2]=="Applied"){
                             showToast(msg: "You have already applied to this job");
                            }else{
                              _.applyJobPopUp(context, _.jobDetail!.id!);

                            }

                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            color:  _.data[2]=="Applied"?Colors.orange:AppColors.green,
                            child: Text(
                              "${_.data[2]=="Applied"?"Applied":"Apply Now"}"
                              ,
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[500]!)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      SubText("SCHEDULE",
                                          color: Colors.grey[500]),
                                      SubText(
                                        "${_.jobDetail!.schedule!.toUpperCase()}",
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[500]!)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      SubText("JOB TYPE",
                                          color: Colors.grey[500]),
                                      SubText(
                                        "${_.jobDetail!.jobType!.toUpperCase()}",
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[500]!)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      SubText("EXPERIENCE",
                                          color: Colors.grey[500]),
                                      SubText(
                                        "${_.jobDetail!.experience!.toUpperCase()}",
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[500]!)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      SubText("OFFER SALARY",
                                          color: Colors.grey[500]),
                                      SubText(
                                        "\$${_.jobDetail!.salary}",
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[500]!)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      SubText("POST DATE",
                                          color: Colors.grey[500]),
                                      SubText(
                                        "${_.jobDetail!.postedDate!.toString().split(" ")[0].toUpperCase()}",
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SubText(
                          "JOB SKILLS",
                          color: AppColors.green,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          color: AppColors.bgGreen,
                          child: _.keywordList.length == 0
                              ? Text("None")
                              : Text('${_.keywordList[0]}'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SubText(
                          "OVERVIEW",
                          color: AppColors.green,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SubText("${_.parseHtmlString(_.jobDetail!.description!)}"),
                        SizedBox(
                          height: 20,
                        ),
                        Heading("Qualifications and Skills:"),
                        SizedBox(
                          height: 10,
                        ),
                        _.keywordList.length == 0
                            ? Text("None")
                            : Column(
                                children: List.generate(_.keywordList.length,
                                    (index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "• ",
                                            style: TextStyle(
                                                color: AppColors.green),
                                          ),
                                          Text('${_.keywordList[index]}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  );
                                }),
                              )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
