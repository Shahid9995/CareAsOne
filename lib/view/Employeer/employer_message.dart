import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/employer_mesage_controller.dart';
import 'package:careAsOne/view/Employeer/chat_page_employer.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class EmployerMessage extends StatefulWidget {
  const EmployerMessage({Key? key}) : super(key: key);
  @override
  _EmployerMessageState createState() => _EmployerMessageState();
}
class _EmployerMessageState extends State<EmployerMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployerMessagesController>(
      init: EmployerMessagesController(),
      builder: (_) => Scaffold(
        backgroundColor: AppColors.bgGreen,
        appBar: AppBar(
          title: SubText("Messages",color: AppColors.green,),
          elevation: 0.0,
          backgroundColor: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.black),
          actions: [
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(10),
          height: double.infinity,
          color: Colors.white,
          child: _.isLoading?
         Center(child: CircularProgressIndicator(color: AppColors.green,),):
          _.employerApplicantsMessageList.data==null? Center(
            child: Text(
              "No conversations from job seekers",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ):_.employerApplicantsMessageList.data!.userJob![0].applications!.length==0? Center(
            child: Text(
              "No conversations from job seekers",
              style: TextStyle(color: Colors.grey[500]),
            ),
          )

              : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: _.employerApplicantsMessageList.data!.userJob![0].applications!.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                            () => ChatEmployerPage(),
                        arguments: [
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.firstName}",
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.lastName}",
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.profileImage}",
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.id}",
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].id}",
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].status}",
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.status}",
                          "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.deviceToken}",
                        ],
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 7.5),
                          child: ListTile(
                            horizontalTitleGap: 0,
                            contentPadding: const EdgeInsets.all(0.0),
                            leading: Stack(
                              children: [
                                CircularCachedImage(
                                    radius: 16.0,
                                    imageUrl:
                                    '${BaseApi.domainName}${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.profileImage}'),
                                Positioned(
                                  right: 5.0,
                                  child: CircleAvatar(
                                      radius: 3.0,
                                      backgroundColor:_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.status=="Online"?AppColors.green:Colors.grey[200]),
                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SubText(
                                        "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.firstName} ${_.employerApplicantsMessageList.data!.userJob![0].applications![index].applicant!.lastName}",
                                        size: 16.0,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: SubText('',
                                            size: 10.0,
                                            colorOpacity: 0.5))),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: SubText(
                                    "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].jobTitle}",
                                    size: 12.0,
                                    maxLines: 2,
                                    colorOpacity: 0.5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Column(
                                  children: [
                                    SubText(
                                      "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].msgCreatedAt==null?"":_.employerApplicantsMessageList.data!.userJob![0].applications![index].msgCreatedAt.toString().split(" ")[0]}",
                                      color: Colors.grey[300],
                                    ),
                                    //hello(_._.employerApplicantsMessageList.data.employeeList[index].messages, _.listElementData[index].applicant.id).toString()=="0"
                                    _.employerApplicantsMessageList.data!.userJob![0].applications![index].smsCount==0?
                                    SizedBox(height: 0,):
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.5),
                                      child: Center(
                                        child: CircleAvatar(
                                          radius: 8.0,
                                          backgroundColor:
                                          AppColors.green,
                                          child: SubText(
                                              "${_.employerApplicantsMessageList.data!.userJob![0].applications![index].smsCount}",
                                              size: 10.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 0.0),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  hello(message, id) {
    var messageUnseenList = [];
    for (int i = 0; i < message.length; i++) {
      if (message[i].from.toString() == id.toString()) {
        message[i].seen == 0
            ? messageUnseenList.add(message[i].seen)
            : print('vv');
      } else {
      }
    }

    return messageUnseenList.length;
  }

  convertTime(yourTime) {
    TimeOfDay nowTime = TimeOfDay.now();
    var newTime = DateFormat('hh:mm a').format(yourTime);
    double _doubleYourTime =
        yourTime.hour.toDouble() + (yourTime.minute.toDouble() / 60);
    double _doubleNowTime =
        nowTime.hour.toDouble() + (nowTime.minute.toDouble() / 60);

    double _timeDiff = _doubleNowTime - _doubleYourTime;

    int _hr = _timeDiff.truncate();
    double _minute = (_timeDiff - _timeDiff.truncate()) * 60;
    var num2 = int.parse(_minute.toStringAsFixed(0));
    if (_minute <= 1.00) {
      return "now";
    } else {
      return "$newTime";
    }
  }
}
