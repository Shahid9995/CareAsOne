import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/view/job_seeker/jobs_detail.dart';
import 'package:careAsOne/view/search/filter_controller.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../widget/button.dart';
import '../widget/text.dart';

class FilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
      init: FilterController(),
      builder: (_) => _.isLoading
          ? Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.green)),
              ),
            )
          : Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: AppColors.white,
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      size: 16.0, color: AppColors.black),
                ),
                title: SubText('Filters'),
                actions: [
                  InkWell(
                    onTap: () {
                      _.nursingCheckbox = false;
                      _.practicalNurse = false;
                      _.directSupport = false;
                      _.homeHealthAid = false;
                      _.caregiver = false;
                      _.medicalTech = false;
                      _.regNurse = false;
                      _.partTimeCheck = false;
                      _.fullTimeCheck = false;
                      _.fullPartCheck = false;
                      _.noExperienceCheck = false;
                      _.lessThanOneCheck = false;
                      _.oneThreeCheck = false;
                      _.threeFiveCheck = false;
                      _.fivePlusCheck = false;
                      _.update();
                      _.getAllJobDataClear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child:
                          Center(child: SubText('CLEAR FILTERS', size: 12.0)),
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: Color(0xFFF0F0FF)),
                        ),
                        child: Column(
                          children: [
                            ExpansionTile(
                              iconColor: Colors.black,
                              collapsedBackgroundColor: AppColors.white,
                              // backgroundColor: Colors.white,
                              collapsedIconColor: Colors.black,
                              tilePadding: EdgeInsets.only(left: 20),
                              childrenPadding: EdgeInsets.only(left: 30),
                              onExpansionChanged: (v) {},
                              title: Text("JOB POSITION"),
                              children: [
                                Container(
                                  // height: Get.height * 1.8,
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 20.0),
                                  margin: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _.nursingCheckbox,
                                            onChanged: (value) {
                                              _.nursingCheckbox =
                                                  !_.nursingCheckbox;

                                              if (_.nursingCheckbox == true) {
                                                _.positions =
                                                    "&positions[0]=Certified Nursing Assistant";
                                                _.update();
                                              } else {
                                                _.positions = "";
                                                _.update();
                                              }
                                              _.update();
                                            },
                                          ),
                                          SubText(
                                              'Certified Nursing Assistant'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _.practicalNurse,
                                            onChanged: (value) {
                                              _.practicalNurse =
                                                  !_.practicalNurse;
                                              if (_.practicalNurse == true) {
                                                _.position1 =
                                                    "&positions[1]=Licensed Practical Nurse";
                                                _.update();
                                              } else {
                                                _.position1 = "";
                                                _.update();
                                              }
                                              _.update();
                                            },
                                          ),
                                          SubText('Licensed Practical Nurse'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _.directSupport,
                                            onChanged: (value) {
                                              _.directSupport =
                                                  !_.directSupport;

                                              if (_.directSupport == true) {
                                                _.position2 =
                                                    "&positions[2]=Direct Support Professional";
                                                _.update();
                                              } else {
                                                _.position2 = "";
                                                _.update();
                                              }

                                              _.update();
                                            },
                                          ),
                                          Text('Direct Support Professional'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _.homeHealthAid,
                                            onChanged: (value) {
                                              _.homeHealthAid =
                                                  !_.homeHealthAid;

                                              if (_.homeHealthAid == true) {
                                                _.position3 =
                                                    "&positions[3]=Home Health Aid";
                                                _.update();
                                              } else {
                                                _.position3 = "";
                                                _.update();
                                              }
                                              _.update();
                                            },
                                          ),
                                          Text('Home Health Aid'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _.caregiver,
                                            onChanged: (value) {
                                              _.caregiver = !_.caregiver;

                                              if (_.caregiver == true) {
                                                _.position4 =
                                                    "&positions[4]=Caregiver";
                                                _.update();
                                              } else {
                                                _.position4 = "";
                                                _.update();
                                              }
                                              _.update();
                                            },
                                          ),
                                          Text('Caregiver'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _.medicalTech,
                                            onChanged: (value) {
                                              _.medicalTech = !_.medicalTech;
                                              if (_.medicalTech == true) {
                                                _.position5 =
                                                    "&positions[5]=Medical Technician";
                                                _.update();
                                              } else {
                                                _.position5 = "";
                                                _.update();
                                              }

                                              _.update();
                                            },
                                          ),
                                          Text('Medical Technician'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _.regNurse,
                                            onChanged: (value) {
                                              _.regNurse = !_.regNurse;
                                              if (_.regNurse == true) {
                                                _.position6 =
                                                    "&positions[6]=Registered Nurse";
                                                _.update();
                                              } else {
                                                _.position6 = "";
                                                _.update();
                                              }
                                              _.update();
                                            },
                                          ),
                                          Text('Registered Nurse'),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              iconColor: Colors.black,
                              collapsedBackgroundColor: AppColors.white,
                              // backgroundColor: Colors.white,
                              collapsedIconColor: Colors.black,
                              tilePadding: EdgeInsets.only(left: 20),
                              childrenPadding: EdgeInsets.only(left: 30),
                              onExpansionChanged: (v) {},
                              title: Text("SCHEDULE"),
                              children: [
                                Container(
                                  // height: Get.height * 1.8,
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 20.0),
                                  margin: EdgeInsets.all(15),
                                  child: Column(children: <Widget>[
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.partTimeCheck,
                                          onChanged: (value) {
                                            _.partTimeCheck = !_.partTimeCheck;

                                            if (_.partTimeCheck == true) {
                                              _.partTime =
                                                  "&schedules[0]=part-time";
                                              _.update();
                                            } else {
                                              _.partTime = "";
                                              _.update();
                                            }
                                            _.update();
                                          },
                                        ),
                                        SubText('Part Time'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.fullTimeCheck,
                                          onChanged: (value) {
                                            _.fullTimeCheck = !_.fullTimeCheck;
                                            if (_.fullTimeCheck == true) {
                                              _.fullTime =
                                                  "&schedules[1]=full-time";
                                              _.update();
                                            } else {
                                              _.fullTime = "";
                                              _.update();
                                            }
                                            _.update();
                                          },
                                        ),
                                        SubText('Full Time'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.fullPartCheck,
                                          onChanged: (value) {
                                            _.fullPartCheck = !_.fullPartCheck;

                                            if (_.fullPartCheck == true) {
                                              _.fullPart =
                                                  "&schedules[2]=Full-and-Part-Time";
                                              _.update();
                                            } else {
                                              _.fullPart = "";
                                              _.update();
                                            }

                                            _.update();
                                          },
                                        ),
                                        Text('Full Time and Part Time'),
                                      ],
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              iconColor: Colors.black,
                              collapsedBackgroundColor: AppColors.white,
                              // backgroundColor: Colors.white,
                              collapsedIconColor: Colors.black,
                              tilePadding: EdgeInsets.only(left: 20),
                              childrenPadding: EdgeInsets.only(left: 30),
                              onExpansionChanged: (v) {},
                              title: Text("EXPERIENCE"),
                              children: [
                                Container(
                                  // height: Get.height * 1.8,
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 20.0),
                                  margin: EdgeInsets.all(15),
                                  child: Column(children: <Widget>[
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.noExperienceCheck,
                                          onChanged: (value) {
                                            _.noExperienceCheck =
                                                !_.noExperienceCheck;

                                            if (_.noExperienceCheck == true) {
                                              _.noExperience =
                                                  "&experiences[0]=No Experience";
                                              _.update();
                                            } else {
                                              _.noExperience = "";
                                              _.update();
                                            }
                                            _.update();
                                          },
                                        ),
                                        SubText('No Experience'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.lessThanOneCheck,
                                          onChanged: (value) {
                                            _.lessThanOneCheck =
                                                !_.lessThanOneCheck;
                                            if (_.lessThanOneCheck == true) {
                                              _.lessThanOne =
                                                  "&experiences[1]=< 1 Year";
                                              _.update();
                                            } else {
                                              _.lessThanOne = "";
                                              _.update();
                                            }
                                            _.update();
                                          },
                                        ),
                                        SubText('< 1 Year'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.oneThreeCheck,
                                          onChanged: (value) {
                                            _.oneThreeCheck = !_.oneThreeCheck;

                                            if (_.oneThreeCheck == true) {
                                              _.oneThree =
                                                  "&experiences[2]=1-3 Years";
                                              _.update();
                                            } else {
                                              _.oneThree = "";
                                              _.update();
                                            }

                                            _.update();
                                          },
                                        ),
                                        Text('1-3 Years'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.threeFiveCheck,
                                          onChanged: (value) {
                                            _.threeFiveCheck =
                                                !_.threeFiveCheck;

                                            if (_.threeFiveCheck == true) {
                                              _.threeFive =
                                                  "&experiences[3]=3-5 Years";
                                              _.update();
                                            } else {
                                              _.threeFive = "";
                                              _.update();
                                            }

                                            _.update();
                                          },
                                        ),
                                        Text('3-5 Years'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _.fivePlusCheck,
                                          onChanged: (value) {
                                            _.fivePlusCheck = !_.fivePlusCheck;

                                            if (_.fivePlusCheck == true) {
                                              var newVal = "&experiences[4]=5%2B Years";
                                              _.fivePlus =newVal;

                                              _.update();
                                            } else {
                                              _.fivePlus = "";
                                              _.update();
                                            }

                                            _.update();
                                          },
                                        ),
                                        Text('5+ Years'),
                                      ],
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            CustomButton(
                              onTap: () {
                                _.getAllJobDataOnce();
                              },
                              title: 'SHOW',
                              btnColor: AppColors.green,
                              textColor: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _.allJobsList.length!=0?Center(
                        child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                if (_.currentPage > 1) {
                                  _.currentPage--;
                                  _.getAllJobDataOnce();
                                }
                              },
                              child: Container(
                                color: AppColors.green,
                                height:35,width: 50,
                                child: Icon(
                                  Icons.navigate_before,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${_.currentPage}",
                                style: TextStyle(
                                    color: AppColors.green, fontSize: 25),
                              ),
                            ),
                            _.allJobsList.length!=0?
                            InkWell(
                              onTap: (){
                                _.currentPage++;
                                _.getAllJobDataOnce();
                              },
                              child: Container(
                                color: AppColors.green,
                                height: 35, width: 50,
                                child:  Icon(Icons.navigate_next, color: Colors.white,),
                              ),
                            ):SizedBox()
                          ],
                        ),
                      ):SizedBox(),
                      _.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.green,
                              ),
                            )
                          : _.allJobsList.length!=0?Column(
                              children:
                                  List.generate(_.allJobsList.length, (index) {
                                return PostCard(
                                  onTap: (){
                                    Get.to(()=>JobsDetails(),arguments: ["${_.allJobsList[index].id}","${_.allJobsList[index].postedDate}","${ _.allJobsList[index].applied == true ? "Applied" : "Apply Now"}"]);
                                  },
                                  imageUrl:_.allJobsList[index].user!
                                      .companyProfile!.logo ==
                                      null
                                      ? 'https://www.gravatar.com/avatar/159dca37d8cbb410c9075424bd6276b7?d=mm&s=250'
                                      :
                                      '${BaseApi.domainName}${_.allJobsList[index].user!.companyProfile!.logo}',
                                  heading: _.allJobsList[index].title,
                                  subHeading: _.allJobsList[index].user!
                                      .companyProfile!.name,
                                  description:
                                      '${_.parseHtmlString(_.allJobsList[index].description!)}',
                                  location:
                                      '${_.allJobsList[index].city}|${_.allJobsList[index].state}',
                                  experience:
                                      '${_.allJobsList[index].experience}',
                                  salary: "\$ ${_.allJobsList[index].salary}",
                                  jobType: _.allJobsList[index].schedule,
                                  titleButton:
                                      _.allJobsList[index].applied == true
                                          ? "Applied"
                                          : "Apply Now",
                                  date:
                                      _.allJobsList[index].createdAt.toString().split(" ")[0],
                                  onApply: () {
                                    if(_.allJobsList[index].applied==true){
                                      showToast(msg:"You have already applied on this job");
                                    }else{
                                      _.applyJobPopUp(context,_.allJobsList[index].id!);
                                      //_.applyOnJob(context,_.allJobsList[index].id);
                                    }

                                  },
                                );
                              }),
                            ):Center(child: SubText("No jobs found",size: 17,color: Colors.grey[400],)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
