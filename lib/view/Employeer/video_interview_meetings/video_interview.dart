import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/Employeer/video_interview_meetings/create_meeting_controller.dart';
import 'package:careAsOne/view/messages/messages.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call_page.dart';

class CreateVideoMeeting extends StatefulWidget {
  const CreateVideoMeeting({Key? key}) : super(key: key);

  @override
  _CreateVideoMeetingState createState() => _CreateVideoMeetingState();
}

class _CreateVideoMeetingState extends State<CreateVideoMeeting> {
  TextEditingController? _meetingId;
  final createMeetingKey = new GlobalKey<FormBuilderState>();
  @override
  void initState() {
    _meetingId = TextEditingController();

  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateMeetingController>(init:CreateMeetingController(),builder: (_)=>Scaffold(
      backgroundColor: AppColors.bgGreen,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title:
        Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth),
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
      child: FormBuilder(
        key: createMeetingKey,
        child: Center(
          child: Column(children: [
            DecoratedInputField(text: "Meeting Id",hintText: "Meeting Id",name: "Meeting Id",controller: _meetingId,
              validations: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8)]),),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                child:Text("Send Invitation",style: TextStyle(color: Colors.white),),onPressed: (){
                if(createMeetingKey.currentState!.validate()){
                  _.sendInvitation(_meetingId!.text.toString());
                }
              },),
                ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                child:Text("Start Meeting",style: TextStyle(color: Colors.white),),onPressed: (){
                if(createMeetingKey.currentState!.validate()){
                  onJoin();
                }
              },)
            ],),

          ],),
        ),
      )),
    ));
  }

  Future<void> onJoin() async {
    if (_meetingId!.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);

      Get.to(()=>CallPage(
        channelName: _meetingId!.text,
        role: ClientRole.Broadcaster,
      ));
    }
  }
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }
}
