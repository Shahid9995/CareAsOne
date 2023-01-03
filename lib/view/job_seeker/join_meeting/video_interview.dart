import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/view/Employeer/video_interview_meetings/create_meeting_controller.dart';
import 'package:careAsOne/view/job_seeker/join_meeting/join_call_page.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class JoinVideoMeeting extends StatefulWidget {
  const JoinVideoMeeting({Key? key}) : super(key: key);

  @override
  _JoinVideoMeetingState createState() => _JoinVideoMeetingState();
}

class _JoinVideoMeetingState extends State<JoinVideoMeeting> {
  final joinMeetingKey = new GlobalKey<FormBuilderState>();
  TextEditingController? _meetingId;
  @override
  void initState() {
    _meetingId = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateMeetingController>(init:CreateMeetingController(),builder: (_)=>
        Container(
          height: height(context) * 0.65,
      child: SingleChildScrollView(
      child: Container(

        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        margin: EdgeInsets.all(15),
        child: FormBuilder(
          key: joinMeetingKey,
          child: Center(
            child: Column(children: [

              DecoratedInputField(text: "Meeting Id",
                hintText: "Meeting Id(Received From Employer)",
                name: "Meeting Id",
                controller: _meetingId,
                validations: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8)]),),
              SizedBox(height: 12.7,),
              CustomButton(title: "Join Meeting",onTap: (){
                if(joinMeetingKey.currentState!.validate()){
                  onJoin();
                }

              },)
            ],),
          ),
        )),
    ),
    ));
  }

  Future<void> onJoin() async {
    if (_meetingId!.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      Get.to(()=>JoinCallPage(
        channelName: _meetingId!.text,
        role: ClientRole.Broadcaster,
      ));
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
