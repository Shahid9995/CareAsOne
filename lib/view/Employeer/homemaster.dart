import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/view/Employeer/employer_message.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMasterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GetBuilder<HomeMasterController>(
      init: HomeMasterController(),
      builder: (_) {

        return Scaffold(
          key: _.scaffoldKey,
          backgroundColor: AppColors.bgGreen,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: false,
            title: Container( height: 40,width: 40,
                child: Image.asset('assets/images/playstore.png', fit: BoxFit.fitWidth)),
            actions: [


          StreamBuilder(
          stream: _.getCounter(Duration(seconds: 15)),
          builder: (context,stream) {
            return UnReadMsgIconButton(
              onTap: () {
                print('Pressed..............................');

                if (
                _.plan != 'plans') {
                  Get.to(() => EmployerMessage());
                } else {
                  showToast(
                      msg: "Please Purchase a Package to Proceed", backgroundColor: Colors.red);
                }
              },
              msgNumber: _.receivedMessageCount,
            );

          }
              ),
              _.isLoading?SizedBox(): InkWell(
                onTap: () {
                  _.scaffoldKey.currentState!.openEndDrawer();
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

          body:  _.isLoading||_.pages==null?Center(child: CircularProgressIndicator(color: AppColors.green,),):_.pages[_.currentPage],

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


                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DrawerTileButton(
                            title: 'Dashboard',
                            onPressed: () {
                              //_.getEmployerMessageData(_.token);
                              if (
                                  _.plan != 'plans') {
                                _.navigateToPage(0);
                                _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(
                                    msg:
                                    "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image: _.currentPage == 0
                                ? "dashboardg.png"
                                : "dashboard.png",
                            seleted: _.currentPage == 0 ? true : false,
                          ),
                          DrawerTileButton(
                            title: 'Video Interviews',
                            onPressed: () {
                              if (_.plan != 'plans') {
                                _.navigateToPage(1);
                                _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(
                                    msg:
                                    "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image:
                                _.currentPage == 1 ? "videog.png" : "video.png",
                            seleted: _.currentPage == 1 ? true : false,
                          ),
                          DrawerTileButton(
                            title: 'Employees',
                            onPressed: () {
                              if (_.plan != 'plans') {
                                _.navigateToPage(2);
                                _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(
                                    msg:
                                    "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image:
                                _.currentPage == 2 ? "groupg.png" : "group.png",
                            seleted: _.currentPage == 2 ? true : false,
                          ),
                          _.empDashboardModel.result?.addOnDoc!=null&&
                              !(_.empDashboardModel.result!.addOnDoc!.contains("Training_Videos"))?DrawerTileButton(
                            title: 'Documents',
                            onPressed: () {
                              if (_.plan != 'plans') {
                                _.navigateToPage(3);
                                _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(
                                    msg:
                                    "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image:
                                _.currentPage == 3 ? "docsg.png" : "docs.png",
                            seleted: _.currentPage == 3 ? true : false,
                          ):SizedBox(),
                          DrawerTileButton(
                            title: 'Jobs',
                            onPressed: () {
                              if (_.plan != 'plans') {
                                _.navigateToPage(4);
                                _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(
                                    msg:
                                    "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image:
                                _.currentPage == 4 ? "jobsg.png" : "jobs.png",
                            seleted: _.currentPage == 4 ? true : false,
                          ),
                          _.empDashboardModel.result?.addOnTraining!=null||
                              _.empDashboardModel.result?.addOnDoc=="Training_Videos_Starter"||
                              _.empDashboardModel.result?.addOnDoc=="Training_Videos_Enterprise"||
                              _.empDashboardModel.result?.addOnDoc=="Training_Videos_Medium"?DrawerTileButton(
                            title: 'Training Videos',
                            onPressed: () {
                              if (_.plan != 'plans') {
                                _.navigateToPage(5);
                                _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(
                                    msg:
                                    "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image: _.currentPage == 5
                                ? "videosg.png"
                                : "videos.png",
                            seleted: _.currentPage == 5 ? true : false,
                          ):SizedBox(),
                          DrawerTileButton(
                            title: 'Subscription',
                            onPressed: () {
                              if (_.plan != 'plans') {
                                _.navigateToPage(6);
                                _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(msg: "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image: _.currentPage == 6
                                ? "subscriptiong.png"
                                : "subscription.png",
                            seleted: _.currentPage == 6 ? true : false,
                          ),
                          DrawerTileButton(
                            title: 'News Feed',
                            onPressed: () {
                              if (true) {
                              // if (_.plan != 'plans') {
                                _.navigateToPage(10);
                                // _.getAllStickyNotes(_.token);
                                _.update();
                              } else {
                                showToast(msg: "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                              }
                            },
                            image: _.currentPage == 10
                                ? "newsgreen.png"
                                : "newsWhite.png",
                            seleted: _.currentPage == 10 ? true : false,
                          ),

                          ExpansionTile(
                            iconColor: Colors.white,
                            collapsedBackgroundColor: AppColors.green,
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
                                  "Employer Info",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            children: <Widget>[
                              ListTile(
                                title: InkWell(
                                  onTap: () {
                                    if (_.plan != 'plans') {
                                      _.navigateToPage(8);
                                      _.getAllStickyNotes(_.token);
                                      _.update();
                                    } else {
                                      showToast(
                                          msg:
                                          "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                                    }

                                  },
                                  child: Text(
                                    "Profile Settings",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: InkWell(
                                  onTap: () {
                                    if (_.plan == 'plans') {
                                      showToast(
                                          msg:
                                          "Please Purchase a Package to Proceed",backgroundColor: Colors.red);
                                    } else {
                                      _.navigateToPage(9);
                                      _.getAllStickyNotes(_.token);
                                      _.update();
                                    }
                                  },
                                  child: Text(
                                    "Company Settings",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.8),
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
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // if()
          floatingActionButton: Container(
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
                                                  _.editColorDialog(context:context,note:_.stickyNote[index].note.toString(),color:_.stickyNote[index].color.toString(),id:_.stickyNote[index].id.toString());
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
                                                              _.deleteNote(context,_.token, _.stickyNote[index].id.toString());
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
        );
      },
    );
  }
  String a(DateTime fatchedDate) {
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
}
