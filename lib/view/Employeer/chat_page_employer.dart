import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/send_message_employer.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class ChatEmployerPage extends StatefulWidget {
  @override
  _ChatEmployerPageState createState() => _ChatEmployerPageState();
}

class _ChatEmployerPageState extends State<ChatEmployerPage> {
  final GlobalKey<FormBuilderState> _empChatKey = GlobalKey<FormBuilderState>();

  var two = Get.arguments;
  var token;
  GetStorage storage = new GetStorage();
  var messagebody;
  var newMessage;
  var data;
  bool _needsScroll = true;
  @override
  void initState() {
    print("applicant: ${two[3]}id: ${two[4]}");
    token = storage.read('authToken');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return GetBuilder<SendMessageEmployer>(
      init: SendMessageEmployer(),
      builder: (_) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: AppColors.green,
          title: Column(
            children: [
              SubText('${two[0]} ${two[1]}', color: AppColors.white),
              SizedBox(height: 2.5),
              SubText(two[6] == 'Online' ? 'Online' : 'Offline',
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
                child: CircularCachedImage(
                  imageUrl: two[2] != null
                      ? "${BaseApi.domainName}${two[2]}"
                      : 'https://image.freepik.com/free-photo/front-view-man-with-straight-face_23-2148364723.jpg',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              _.employeeSingleMessageList.data == null
                  ? Center(
                child: Text(
                  "Start Conversation",
                  style: TextStyle(
                      fontSize: 25, color: Colors.grey[400]),
                ),
              )
                  : Expanded(


                child: Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: StreamBuilder(
                        stream: _.getAllMessages(
                            Duration(seconds: 20)),
                        builder: (context, stream) {
                          return Scrollbar(
                            controller: _.scrollControllers,

                            child:   ListView.builder(
                                itemCount:
                                _.employeeSingleMessageList.data!.length,
                                primary: false,
                                physics:
                                ClampingScrollPhysics(),
                                controller:
                                _.scrollControllers,
                                shrinkWrap: true,
                                itemBuilder:
                                    (context, index) {
                                  return Column(
                                    children: [
                                      _.empProfileModel!.id ==
                                          _.employeeSingleMessageList.data![
                                          index]
                                              .from
                                          ? Padding(
                                        padding: const EdgeInsets.only(left: 50.0),
                                        child: ChatBubble(
                                            message: _.employeeSingleMessageList.data![
                                            index]
                                                .message,
                                            time: timeAgo( _.employeeSingleMessageList.data![
                                            index]
                                                .createdAt),
                                            isSender: true),
                                      )
                                          :Padding(
                                        padding: const EdgeInsets.only(right:50.0),
                                        child: ChatBubble(
                                          isSender:false,
                                            message:  _.employeeSingleMessageList.data![
                                            index]
                                                .message,
                                            time: timeAgo( _.employeeSingleMessageList.data![
                                            index]
                                                .createdAt)),
                                      ),
                                    ],
                                  );
                                }),
                          );
                        })
                ),


              ),
              FormBuilder(
                  key: _empChatKey,
                  child: Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.grey.withOpacity(0.05),
                    child: FormBuilderTextField(
                      name: 'text',
                      controller: _.textEditingController,
                      cursorColor: AppColors.green,
                      minLines: 1,
                      maxLines: 6,
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: ()async {
                            if(_.textEditingController.text!="") {
                              await _.sendMessage(context,
                                  _.textEditingController.text,
                                  _.status);

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
                  ))
            ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70.0,right: 10),
          child: Container(
            height: 30,
            width: 30,
            child: FloatingActionButton(
              child: Icon(Icons.arrow_downward_sharp),
              onPressed: ()async{
                _.getToLastMessage();
              },
            ),
          ),
        ),
      ),
    );
  }

  String timeAgo(DateTime? fatchedDate) {
    DateTime currentDate = DateTime.now();

    var different = currentDate.difference(fatchedDate!);

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
