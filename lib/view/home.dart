import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/view/messages/messages.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("======Homepage============");
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (_) =>
            Scaffold(
              key: _.scaffoldKeyJobSeeker,
              backgroundColor: AppColors.bgGreen,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: AppColors.white,
                title: Container(
                    height: 40,
                    width: 40,
                    child: Image.asset('assets/images/playstore.png',
                        fit: BoxFit.fitWidth)),
                actions: [
                  StreamBuilder(
                      stream: _.getCounter(Duration(seconds: 15)),
                      builder: (context, stream) {
                        return UnReadMsgIconButton(
                          onTap: () {
                            if ((_.data!.userRecord!.dob != null &&
                                _.data!.userEducationRecord!.companyDetails != null &&
                                _.data!.userEmploymentDetail!.educationDetails != null) || _.data!.userEducationRecord!.resume != null) {
                              if(true) {
                              // if(_.availabilityValidation!=null) {
                                Get.to(() => MessagesPage());
                              }else{
                                showCustomToast(
                                    msg:
                                    "Please complete your availability to access messages.",
                                    context: context);
                              }
                            } else {
                              showCustomToast(
                                  msg:
                                  "Please complete your profile  or upload resume to access messages.",
                                  context: context);
                            }
                          },
                          msgNumber: _.receivedMessageCount,
                        );
                      }),
                  InkWell(
                    onTap: () {
                      //  if(_.scaffoldKey.currentState.isDrawerOpen){
                      // _.scaffoldKey.currentState.openEndDrawer();
                      // }else{
                      _.scaffoldKeyJobSeeker.currentState!.openEndDrawer();
                      // }
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15.0),
                        child: Icon(
                          Icons.menu,
                          color: AppColors.green,
                        )),
                  ),
                ],
              ),
              body: _.isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.green,
                ),
              )
                  : SingleChildScrollView(
                child: _.pages[_.currentPage],
              ),
              endDrawer: Container(
                height: height,
                width: 2 * width / 3,
                color: Colors.green,
                child: Drawer(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    color: AppColors.green,
                    child: ListView(
                      children: [
                        // Stack(
                        //   children: [
                        //     // UserAccountsDrawerHeader(
                        //     //   margin: const EdgeInsets.all(0),
                        //     //   currentAccountPicture: InkWell(
                        //     //     onTap: () {
                        //     //       // controller.showSelectionDialog(context);
                        //     //     },
                        //     //     child: CachedNetworkImage(
                        //     //       imageUrl: 'https://miro.medium.com/max/785/0*Ggt-XwliwAO6QURi.jpg',
                        //     //       imageBuilder: (context, imageProvider) => Container(
                        //     //         width: 120,
                        //     //         height: 120,
                        //     //         decoration: BoxDecoration(
                        //     //           shape: BoxShape.circle,
                        //     //           image: DecorationImage(
                        //     //             image: imageProvider,
                        //     //             fit: BoxFit.cover,
                        //     //           ),
                        //     //         ),
                        //     //       ),
                        //     //       placeholder: (context, url) => CircularProgressIndicator(
                        //     //         backgroundColor: AppColors.green,
                        //     //         valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        //     //       ),
                        //     //       errorWidget: (context, url, error) => CircleAvatar(
                        //     //         radius: 50,
                        //     //         backgroundColor: AppColors.green,
                        //     //         child: Icon(
                        //     //           Icons.person,
                        //     //           size: 48,
                        //     //           color: AppColors.black,
                        //     //         ),
                        //     //       ),
                        //     //     ),
                        //     //   ),
                        //     //   decoration: BoxDecoration(color: AppColors.black),
                        //     //   accountName: Heading(
                        //     //   _.myProfile.profileModel == null?"User Name":   _.myProfile.profileModel.userNicename==null?_.myProfile.profileModel.displayName: _.myProfile.profileModel.userNicename.capitalize,
                        //     //     height: 1.0,
                        //     //     color: AppColors.white,
                        //     //     weight: FontWeight.w700,
                        //     //   ),
                        //     //   accountEmail: Heading(
                        //     //     _.myProfile.profileModel == null ?"user@mail.com":
                        //     //     '${_.myProfile.profileModel.userEmail}',
                        //     //     size: 12,
                        //     //     height: 1.0,
                        //     //     color: AppColors.white,
                        //     //   ),
                        //     // ),
                        //     Positioned(
                        //       top: 15.0,
                        //       right: 5.0,
                        //       child: IconButton(
                        //         onPressed: () {
                        //           Get.toNamed('/editProfile');
                        //         },
                        //         icon: Column(
                        //           children: [
                        //             FaIcon(FontAwesomeIcons.edit, size: 13.0, color: AppColors.white),
                        //             Heading('Edit', size: 10.0, color: AppColors.white),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DrawerTileButton(
                                title: 'Search Jobs',
                                onPressed: () {
                                  //     Get.find<HomeController>().getEmployerMessageData(_.token);
                                  if ((_.data!.userRecord!.dob != null &&
                                      _.data!.userEducationRecord!
                                          .companyDetails !=
                                          null &&
                                      _.data!.userEmploymentDetail!
                                          .educationDetails !=
                                          null) ||
                                      _.data!.userEducationRecord!.resume !=
                                          null) {
                                    Get.find<HomeController>()
                                        .getAppliedJobsList(_.token);

    if(true) {
    // if(_.availabilityValidation!=null) {
      _.navigateToPage(0);
      _.getAllStickyNotes(_.token);
      _.update();
    }else{
      showCustomToast(
          msg:
          "Please complete your availability to access search jobs.",
          context:context);
    }
                                  } else {
                                    showCustomToast(msg: "Please complete your profile or upload resume to search jobs.", context:context);}
                                },
                                image: _.currentPage == 0
                                    ? "searchg.png"
                                    : "search.png",
                                seleted: _.currentPage == 0 ? true : false,
                              ),
                              DrawerTileButton(
                                title: 'Applied Jobs ',
                                jobsApplied: "${_.responseData.length}",
                                onPressed: () {
                                  //     Get.find<HomeController>().getEmployerMessageData(_.token);
                                  if ((_.data!.userRecord!.dob != null &&
                                      _.data!.userEducationRecord!
                                          .companyDetails !=
                                          null &&
                                      _.data!.userEmploymentDetail!
                                          .educationDetails !=
                                          null) ||
                                      _.data!.userEducationRecord!.resume !=
                                          null) {
                                    Get.find<HomeController>()
                                        .getAppliedJobsList(_.token);
                                    if(true) {
                                    // if(_.availabilityValidation!=null) {
                                      _.navigateToPage(1);
                                      _.getAllStickyNotes(_.token);
                                      _.update();
                                    }else{
                                      showCustomToast(
                                          msg:
                                          "Please complete your availability to access applied jobs.",
                                          context:context);
                                    }
                                  } else {
                                    showCustomToast(msg: "Please complete your profile  or upload resume to access applied jobs.", context:context);
                                  }
                                },
                                image: _.currentPage == 1
                                    ? "jobsg.png"
                                    : "jobs.png",
                                seleted: _.currentPage == 1 ? true : false,
                              ),
                              DrawerTileButton(
                                title: 'Join Interview',
                                onPressed: () {
                                  //      Get.find<HomeController>().getEmployerMessageData(_.token);
                                  if ((_.data!.userRecord!.dob != null &&
                                      _.data!.userEducationRecord!
                                          .companyDetails !=
                                          null &&
                                      _.data!.userEmploymentDetail!
                                          .educationDetails !=
                                          null) ||
                                      _.data!.userEducationRecord!.resume !=
                                          null) {
                                    Get.find<HomeController>()
                                        .getAppliedJobsList(_.token);
                                    if(true) {
                                    // if(_.availabilityValidation!=null) {
                                      _.navigateToPage(2);
                                      _.getAllStickyNotes(_.token);
                                      _.update();
                                    }else{
                                      showCustomToast(
                                          msg:
                                          "Please complete your availability to access access interview.",
                                          context:context);
                                    }

                                  } else {
                                    showCustomToast(
                                        msg:
                                        "Please complete your profile  or upload resume to access interview.",
                                        context:context);
                                  }
                                },
                                image: _.currentPage == 2
                                    ? "videog.png"
                                    : "video.png",
                                seleted: _.currentPage == 2 ? true : false,
                              ),
                              DrawerTileButton(
                                title: 'Videos',
                                onPressed: () {
                                  //         Get.find<HomeController>().getEmployerMessageData(_.token);
                                  if ((_.data!.userRecord!.dob != null &&
                                      _.data!.userEducationRecord!
                                          .companyDetails !=
                                          null &&
                                      _.data!.userEmploymentDetail!
                                          .educationDetails !=
                                          null) ||
                                      _.data!.userEducationRecord!.resume !=
                                          null) {
                                    Get.find<HomeController>()
                                        .getAppliedJobsList(_.token);
                                    if(true){
                                    // if(_.availabilityValidation!=null) {
                                      _.navigateToPage(3);
                                      _.getAllStickyNotes(_.token);
                                      _.update();
                                    }else{
                                      showCustomToast(
                                          msg:
                                          "Please complete your availability to access access videos.",
                                          context:context);
                                    }

                                  } else {
                                    showCustomToast(
                                        msg:
                                        "Please complete your profile  or upload resume to access videos.",
                                        context:context);
                                  }
                                },
                                image: _.currentPage == 3
                                    ? "videosg.png"
                                    : "videos.png",
                                seleted: _.currentPage == 3 ? true : false,
                              ),
                              DrawerTileButton(
                                title: 'Documents',
                                onPressed: () {
                                  //        Get.find<HomeController>().getEmployerMessageData(_.token);
                                  if ((_.data!.userRecord!.dob != null &&
                                      _.data!.userEducationRecord!
                                          .companyDetails !=
                                          null &&
                                      _.data!.userEmploymentDetail!
                                          .educationDetails !=
                                          null) ||
                                      _.data!.userEducationRecord!.resume !=
                                          null) {
                                    Get.find<HomeController>()
                                        .getAppliedJobsList(_.token);
                                    if(true) {
                                    // if(_.availabilityValidation!=null) {
                                      _.navigateToPage(4);
                                      _.getAllStickyNotes(_.token);
                                      _.update();
                                    }else{
                                      showCustomToast(
                                          msg:
                                          "Please complete your availability to access access documents.",
                                          context:context);
                                    }

                                  } else {
                                    showCustomToast(msg: "Please complete your profile  or upload resume to access documents.", context:context);
                                  }
                                },
                                image: _.currentPage == 4
                                    ? "docsg.png"
                                    : "docs.png",
                                seleted: _.currentPage == 4 ? true : false,
                              ),
                              DrawerTileButton(
                                title: 'News Feed',
                                onPressed: () {
                                  //        Get.find<HomeController>().getEmployerMessageData(_.token);
                                  if ((_.data!.userRecord!.dob != null &&
                                      _.data!.userEducationRecord!.companyDetails != null &&
                                      _.data!.userEmploymentDetail!.educationDetails != null) ||
                                      _.data!.userEducationRecord!.resume != null) {Get.find<HomeController>().getAppliedJobsList(_.token);
                                    if(true) {
                                    // if(_.availabilityValidation!=null) {
                                    //   Get.offAll(()=>NewsFeed());
                                      _.navigateToPage(8);
                                    //   _.getAllStickyNotes(_.token);
                                    //   _.update();
                                    }else{
                                      showCustomToast(
                                          msg:
                                          "Please complete your availability to access access documents.",
                                          context:context);
                                    }
                                  } else {
                                    showCustomToast(
                                        msg: "Please complete your profile  or upload resume to access News Feed.", context:context);
                                  }
                                },
                                image: _.currentPage == 8
                                    ? "newsgreen.png"
                                    : "newsWhite.png",
                                seleted: _.currentPage == 8 ? true : false,
                              ),
                              ExpansionTile(
                                iconColor: Colors.white,
                                collapsedBackgroundColor: AppColors.green,
                                // backgroundColor: Colors.white,
                                collapsedIconColor: Colors.white,
                                tilePadding: EdgeInsets.only(left: 20),
                                childrenPadding: EdgeInsets.only(left: 30),
                                onExpansionChanged: (v) {},

                                title: Row(
                                  children: [
                                    Image.asset(
                                        "assets/employeer/drawer/person.png"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Jobseeker Profile",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                children: <Widget>[
                                  ListTile(
                                    // selectedTileColor: Colors.white,

                                    title: InkWell(
                                      onTap: () {
                                        //           Get.find<HomeController>().getEmployerMessageData(_.token);
                                        Get.find<HomeController>()
                                            .getAppliedJobsList(_.token);
                                        _.navigateToPage(5);
                                        _.getAllStickyNotes(_.token);
                                        _.update();
                                      },
                                      child: Text(
                                        "Profile Settings",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color:
                                            Colors.white.withOpacity(0.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  // ListTile(
                                  //   title: InkWell(
                                  //     onTap: () {
                                  //       //            Get.find<HomeController>().getEmployerMessageData(_.token);
                                  //       if ((_.data!.userRecord!.dob != null &&
                                  //           _.data!.userEducationRecord!
                                  //               .companyDetails !=
                                  //               null &&
                                  //           _.data!.userEmploymentDetail!
                                  //               .educationDetails !=
                                  //               null) ||
                                  //           _.data!.userEducationRecord!.resume !=
                                  //               null) {
                                  //         Get.find<HomeController>()
                                  //             .getAppliedJobsList(_.token);
                                  //         _.navigateToPage(6);
                                  //         _.getAllStickyNotes(_.token);
                                  //         _.update();
                                  //       } else {
                                  //         showCustomToast(
                                  //             msg:
                                  //             "Please complete your profile  or upload resume to access availability.",
                                  //             context:context);
                                  //       }
                                  //     },
                                  //     child: Text(
                                  //       "Availability",
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.w500,
                                  //           color:
                                  //           Colors.white.withOpacity(0.8),
                                  //           fontSize: 16),
                                  //     ),
                                  //   ),
                                  // ),
                                  ListTile(
                                    title: InkWell(
                                      onTap: () {
                                        //              Get.find<HomeController>().getEmployerMessageData(_.token);
                                        _.navigateToPage(7);
                                        // Get.to(()=>SignatureSeeker());
                                      },
                                      child: Text(
                                        "Upload Resume",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color:
                                            Colors.white.withOpacity(0.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: InkWell(
                                      onTap: () {
                                        _.authService.logOut();
                                      },
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color:
                                            Colors.white.withOpacity(0.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // DrawerTileButton(
                              //   title: 'Employee Info',
                              //   onPressed: () {
                              //     _.navigateToPage(7);
                              //   },
                              //   image:  _.currentPage == 7?"persong.png":"person.png",
                              //   seleted: _.currentPage == 7?true:false,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton:Container(
                width: 130.0,
                height: 40.0,
                decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(0, 3))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        _.addColorDialog(context);


                        },
                      child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(
                              Icons.add_comment_outlined,
                              color: AppColors.green,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuButton(
                  onSelected: (selected){
                    print(selected);

                  },
                        onCanceled: (){
                    print("canceled");
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: AppColors.green,
                          ),
                        ),
                        itemBuilder: (context) {
                          return _.stickyNote.isEmpty
                              ? List.generate(1, (index) => PopupMenuItem(
                              child: Container(
                                height: 200, width: 300, child: Center(
                                child: Text("No note found",
                                  style: TextStyle(color: Colors.grey),),),)))
                              : List.generate(_.stickyNote.length, (index) {
                            return PopupMenuItem(


                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight: 100),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: _.stickyNote[index].color ==
                                                "#00c292" ? AppColors
                                                .successColor : _
                                                .stickyNote[index].color ==
                                                "#fb3a3a" ? AppColors
                                                .dangerColor : _
                                                .stickyNote[index].color ==
                                                "#02bec9"
                                                ? AppColors.oceanBlue
                                                : _.stickyNote[index].color ==
                                                "#fec107" ? AppColors
                                                .warningColor : AppColors
                                                .purpleColor,
                                            borderRadius: BorderRadius.circular(
                                                5),
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey,
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1))
                                            ]
                                        ),

                                        width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0,
                                              bottom: 15.0,
                                              right: 0.0,
                                              left: 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 230,
                                                    child: Text(
_.stickyNote[index].note.toString(),
                                                      maxLines: 6,
                                                      style: TextStyle(
                                                          decorationStyle: TextDecorationStyle
                                                              .dashed,

                                                          color: Colors.white),
                                                    ),
                                                  ),

                                                ],
                                              ),


                                              SizedBox(height: 10,),
                                              Divider(color: Colors.white,
                                                thickness: 1,),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Container(

                                                    child: Text(

                                                          _.stickyNote[index]
                                                              .diffTime.toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    onTap:(){
                            _.editColorDialog(context:context,note:_.stickyNote[index].note.toString(),color:_.stickyNote[index].color.toString(), id: _.stickyNote[index].id.toString());
                            },
                                                    child: Icon(Icons.edit,
                                                      color: Colors.white,
                                                      size: 20,),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(right: 8.0),
                                                    child: InkWell(
                                                      onTap:(){
                              Get.defaultDialog(
                                title: "",
                                middleText:"Do you really want to delete?",
                                confirm: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(AppColors.green)),
                                    onPressed: () {
                                      Get.back();
_.deleteNote(_.token, _.stickyNote[index].id.toString());
                                    },
                                    child: Text("Delete"))
                              );
                            },
                                                      child: Icon(Icons.delete,
                                                        color: Colors.white,
                                                        size: 20,),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ));
                          });
                        }),
                  ],
                ),
              ),
            ));
  }
  String timeAgo(DateTime fatchedDate) {
    DateTime currentDate = DateTime.now();

    var different = currentDate.difference(fatchedDate);

    if (different.inDays > 365) {
      return "${(different.inDays / 365).floor()} ${(different.inDays / 365)
          .floor() == 1 ? "year" : "years"} ago";
    }
    if (different.inDays > 30) {
      return "${(different.inDays / 30).floor()} ${(different.inDays / 30)
          .floor() == 1 ? "month" : "months"} ago";
    }
    if (different.inDays > 7) {
      return "${(different.inDays / 7).floor()} ${(different.inDays / 7)
          .floor() == 1 ? "week" : "weeks"} ago";
    }
    if (different.inDays > 0) {
      return "${different.inDays} ${different.inDays == 1
          ? "day"
          : "days"} ago";
    }
    if (different.inHours > 0) {
      return "${different.inHours} ${different.inHours == 1
          ? "hour"
          : "hours"} ago";
    }
    if (different.inMinutes > 0) {
      return "${different.inMinutes} ${different.inMinutes == 1
          ? "minute"
          : "minutes"} ago";
    }
    if (different.inMinutes == 0) return 'Just Now';

    return fatchedDate.toString();
  }




/*


 */
}
