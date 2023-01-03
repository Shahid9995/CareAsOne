import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/send_message_controller.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}


String? lastConnectionState;

GetStorage read = new GetStorage();
var token;


class _ChatPageState extends State<ChatPage> {
  var pusher;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    setState(() {
      token = read.read("authToken");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SendMessageController>(
        init: SendMessageController(),
        builder: (_) => Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: AppColors.green,
              title: Column(
                children: [
                  SubText('${_.one[4]} ${_.one[5]}', color: AppColors.white),
                  SizedBox(height: 2.5),
                  SubText(_.one[7] == 'Online' ? 'Online' : 'Offline',
                      size: 12.0, color: AppColors.white),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 5.0),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child:_.one[6] == null?Container(): CircularCachedImage(
                      imageUrl:
                          "${BaseApi.domainName}${_.one[6]}",
                    ),
                  ),
                ),
              ],
            ),
            body: _.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.green,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: _.seekerSingleMessageList.data==null||_.seekerSingleMessageList.data!.isEmpty
                              ? Center(
                                  child: Text(
                                    "Start Conversation",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.grey[400]),
                                  ),
                                )
                              : StreamBuilder(
                                  stream:
                                      _.getAllMessages(Duration(seconds: 20)),
                                  builder: (context, stream) {
                                    return Scrollbar(
                                      controller: _.scrollControllers,
                                      child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          itemCount:_.seekerSingleMessageList.data!.length,
                                          primary: false,
                                          controller: _.scrollControllers,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                           _.seekerSingleMessageList.data![index].from.toString()==_.seekerProfileModel!.id.toString()
                                                    ? Padding(
                                                      padding: const EdgeInsets.only(left: 50),
                                                      child: ChatBubble(
                                                          message: _.seekerSingleMessageList.data![index].message,
                                                          isSender: true,
                                                          time: timeAgo(_.seekerSingleMessageList.data![index].createdAt!),
                                                        ),
                                                    )
                                                    : Padding(
                                                      padding: const EdgeInsets.only(right: 50.0),
                                                      child: ChatBubble(
                                                              message:_.seekerSingleMessageList.data![index].message,
                                                              time:
                                                                  "${timeAgo(_.seekerSingleMessageList.data![index].createdAt!)}", isSender: false,
                                                            ),
                                                    ),

                                              ],
                                            );
                                          }),
                                    );
                                  }),
                        ),
                      ),
                      Container(
                        color: Colors.grey.withOpacity(0.05),
                        child: FormBuilder(
                          key: _fbKey,
                          child: Container(
                            height: 70,

                            padding: EdgeInsets.only(left: 15),
                            child: FormBuilderTextField(
                              name: 'text',
                              controller: _.messageTextController,
                              cursorColor: AppColors.green,
                              minLines: 1,
                              maxLines: 6,
                              validator:FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {

                                      if (_.messageTextController.text != "") {
                                        _.sendMessage(
                                            context,
                                            _.messageTextController.text);
                                        _.update();
                                      }else{
                                        showToast(msg:"You cannot send empty message");
                                      }

                                  },
                                  icon: Icon(Icons.send_outlined,
                                      color: AppColors.green),
                                ),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 70.0, right: 10),
              child: Container(
                height: 30,
                width: 30,
                child: FloatingActionButton(
                  child: Icon(Icons.arrow_downward_sharp),
                  onPressed: () async {
                    _.getToLastMessage();
                  }
                ),
              ),
            )));
  }

  String timeAgo(DateTime fatchedDate) {
    DateTime currentDate = DateTime.now();

    var different = currentDate.difference(fatchedDate);

    if (different.inDays > 365) {
      return "${(different.inDays / 365).floor()} ${(different.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (different.inDays > 30) {
      return "${(different.inDays / 30).floor()} ${(different.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (different.inDays > 7) {
      return "${(different.inDays / 7).floor()} ${(different.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (different.inDays > 0) {
      return "${different.inDays} ${different.inDays == 1 ? "day" : "days"} ago";
    }
    if (different.inHours > 0) {
      return "${different.inHours} ${different.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (different.inMinutes > 0) {
      return "${different.inMinutes} ${different.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    if (different.inMinutes == 0) return 'Just Now';

    return fatchedDate.toString();
  }
}
