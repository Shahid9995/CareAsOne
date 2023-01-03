import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/messages.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'chat.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessagesController>(
      init: MessagesController(),
      builder: (_) =>  Scaffold(
              backgroundColor: AppColors.bgGreen,
              appBar: AppBar(
                title: SubText("Messages",color: AppColors.green,),
                elevation: 0.0,
                backgroundColor: AppColors.white,
                iconTheme: IconThemeData(color: AppColors.black),
                // title: Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth),
                actions: [
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                height: double.infinity,
                color: Colors.white,
                child: _.isLoading?Center(child: CircularProgressIndicator(color: AppColors.green,),):_.responseData.length==0||_.responseData.isEmpty
                    ? Center(
                        child: Text(
                          "You don't have any conversation from employer yet.",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: _.responseData.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Get.to(
                                  () => ChatPage(),
                                  arguments: [
                                    "${_.responseData[index].job!.company!.id}",
                                    "${_.responseData[index].id}",
                                    "${_.responseData[index].job!.user!.id}",
                                    "${_.responseData[index].status}",
                                    "${_.responseData[index].job!.user!.firstName}",
                                    "${_.responseData[index].job!.user!.lastName}",
                                    "${_.responseData[index].job!.user!.profileImage}",
                                    "${_.responseData[index].job!.user!.status}",
                                    "${_.responseData[index].job!.user!.deviceToken}"
                                  ],
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7.5),
                                    child: ListTile(
                                      horizontalTitleGap: 0,
                                      contentPadding: const EdgeInsets.all(0.0),
                                      leading: Stack(
                                        children: [
                                          CircularCachedImage(
                                              radius: 16.0,
                                              imageUrl:
                                                  '${BaseApi.domainName}${_.responseData[index].job!.user!.profileImage}'),
                                          Positioned(
                                            right: 5.0,
                                            child: CircleAvatar(
                                                radius: 3.0,
                                                backgroundColor:
                                                    _.responseData[index].job!.user!.status=="Online"?
                                                    AppColors.green:Colors.grey[200]),
                                          ),
                                        ],
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SubText(
                                                  '${_.responseData[index].job!.user!.firstName} ${_.responseData[index].job!.user!.lastName}',
                                                  size: 16.0,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          Expanded(
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: SubText(
                                                      "${convertTime(_.responseData[index].createdAt)}",
                                                      size: 10.0,
                                                      colorOpacity: 0.5))),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Expanded(
                                            child: SubText(
                                              _.responseData[index].job!.title.toString(),
                                              //   _.responseData[index].message[index].message,
                                              size: 12.0,
                                              maxLines: 2,
                                              colorOpacity: 0.5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // hello(_.responseData[index].message, _.responseData[index].job.user.id).toString()=="0"?
                                          _.responseData[index].smsCount.toString()=="0"?SizedBox(height: 0,):Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.5),
                                            child: Center(
                                              child: CircleAvatar(
                                                radius: 8.0,
                                                backgroundColor:
                                                    AppColors.green,
                                                child: SubText(
                                                    _.responseData[index].smsCount.toString(),
                                                    size: 10.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(height: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
  hello(message,id){
    var messageUnseenList=[];
    for (int i = 0; i < message.length; i++){
      if (message[i].from.toString() ==  id.toString()) {
        message[i].seen ==0?
        messageUnseenList.add(
            message[i].seen):print('vv');


      }else{
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
