import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/pre_screen_question.dart';
import 'package:careAsOne/controller/JobSeeker/seeker_profile.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreQuestionPage extends StatelessWidget {
  PreQuestionPage({Key? key, this.jobSeekerController}) : super(key: key);
  final JobSeekerController? jobSeekerController;
  SingingCharacter? firstCheck;
  SingingCharacter? secondCheck;
  SingingCharacter? thirdCheck;
  SingingCharacter? fourthCheck;
  SingingCharacter? fifthCheck;
  SingingCharacter? sixthCheck;
  SingingCharacter? seventhCheck;

  SingingCharacter? eighthCheck;
  SingingCharacter? ninthCheck;
  SingingCharacter? tenthCheck;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SeekerProfileModel seekerProfileModel;

    return GetBuilder<PreQuestion>(
        init: PreQuestion(),
        builder: (_) => Scaffold(
            backgroundColor: AppColors.bgGreen,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              automaticallyImplyLeading: false,
              title: Container(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/images/playstore.png',
                      fit: BoxFit.fitWidth)),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: AppColors.green,
                      ),
                      onPressed: () {
                        _.authService.logOut();
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: _.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.green)),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Card(
                              elevation: 0.1,
                              child: Center(
                                child: Text(
                                  'CareAsOne Pre-Screen Questionnaire',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 30),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'Are you legally authorized to accept employment in the United States?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: firstCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  firstCheck = value!;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                            title: const Text('No'),
                                            leading: Radio<SingingCharacter>(
                                              value: SingingCharacter.no,
                                              groupValue: firstCheck,
                                              onChanged:
                                                  (SingingCharacter? value) {
                                                firstCheck = value!;
                                                _.update();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'Do you have any previous training as a caregiver/CNA or equivalent or are you a student past their required fundamentals?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: const Text('Yes'),
                                            leading: Radio<SingingCharacter>(
                                              value: SingingCharacter.yes,
                                              groupValue: secondCheck,
                                              onChanged:
                                                  (SingingCharacter? value) {
                                                secondCheck = value!;
                                                _.update();
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('No'),
                                            leading: Radio<SingingCharacter>(
                                              value: SingingCharacter.no,
                                              groupValue: secondCheck,
                                              onChanged:
                                                  (SingingCharacter? value) {
                                                secondCheck = value!;
                                                _.update();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('Do you speak any other languages other than English?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: const Text('Yes'),
                                            leading: Radio<SingingCharacter>(
                                              value: SingingCharacter.yes,
                                              groupValue: tenthCheck,
                                              onChanged:
                                                  (SingingCharacter? value) {
                                                tenthCheck = value;
                                                _.update();
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('No'),
                                            leading: Radio<SingingCharacter>(
                                              value: SingingCharacter.no,
                                              groupValue: tenthCheck,
                                              onChanged:
                                                  (SingingCharacter? value) {
                                                tenthCheck = value;
                                                _.update();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        "Do you have a current and valid driver's license?"),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: thirdCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  thirdCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                              title: const Text('No'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.no,
                                                groupValue: thirdCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  thirdCheck = value;
                                                  _.update();
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'Do you have a reliable vehicle with insurance?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: fourthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  fourthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                              title: const Text('No'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.no,
                                                groupValue: fourthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  fourthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'Do you have a clean driving history for the last 3 years?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: fifthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  fifthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                              title: const Text('No'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.no,
                                                groupValue: fifthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  fifthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text('Will you pass a criminal background check?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: sixthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  sixthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                              title: const Text('No'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.no,
                                                groupValue: sixthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  sixthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text('Will you pass a drug screen?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: seventhCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  seventhCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                              title: const Text('No'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.no,
                                                groupValue: seventhCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  seventhCheck = value;
                                                  _.update();
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'Can you provide professional references for our hiring team to contact?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: eighthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  eighthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                              title: const Text('No'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.no,
                                                groupValue: eighthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  eighthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'Can you provide results from a TB test within 1 week of accepting employment if required?'),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: const Text('Yes'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.yes,
                                                groupValue: ninthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  ninthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          ListTile(
                                              title: const Text('No'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.no,
                                                groupValue: ninthCheck,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  ninthCheck = value;
                                                  _.update();
                                                },
                                              )),
                                          MainHeading('Dear Applicant,'),
                                          Text(
                                              'Thank you for filling out our pre-screening questionnaire. If you qualify for the position, you will be contacted via CareAsOne, email or telephone.'),
                                          Text(
                                            'Thanks,',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          MainHeading('CareAsOne'),
                                          ElevatedButton(
                                            onPressed: () async {
                                              // var status =
                                              //     await OneSignal.shared.getPermissionSubscriptionState();
                                              // var playerId = status.subscriptionStatus.userId;
                                              if (firstCheck == null ||
                                                  secondCheck == null ||
                                                  thirdCheck == null ||
                                                  fourthCheck == null ||
                                                  fifthCheck == null ||
                                                  sixthCheck == null ||
                                                  seventhCheck == null ||
                                                  eighthCheck == null ||
                                                  ninthCheck == null ||
                                                  tenthCheck == null) {
                                                showToast(
                                                  msg: 'Please select atleast one answer',
                                                );
                                              } else {
                                                var playerId =
                                                    await FirebaseMessaging.instance.getToken();
                                                _.submit(context, body: {
                                                  "Are_you_legally_authorized_to_accept_employment_in_United_States?":
                                                      "$firstCheck",
                                                  "Are_you_trained_as_a_CNA\\/RN\\/_or_Caregiver(active_license_may_be_required_depending_on_profession)_or_nursing_student_past_fundamentals?":
                                                      "$secondCheck",
                                                  "Do_you_have_current_and_valid_driver's_license?":
                                                      "$thirdCheck",
                                                  "Do_you_have_reliable_vehicle_with_insurance?":
                                                      "$fourthCheck",
                                                  "Do_you_have_a_clean_driving_history_for_the_last_3_year":
                                                      "$fifthCheck",
                                                  "Will_you_pass_background_check":
                                                      "$sixthCheck",
                                                  "Will_you_Screening_test_for_illegal_drugs":
                                                      "$seventhCheck",
                                                  "profissional_references":
                                                      "$eighthCheck",
                                                  "Can_you_provide_the_results_from_a_TB_test_within_1_week_of_accepting_employment?":
                                                      "$ninthCheck",
                                                  "Are_you_English_proficient?":
                                                      tenthCheck,
                                                  "device_token": playerId,
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: AppColors.white),
                                            ),
                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ]))));
  }
}

enum SingingCharacter { yes, no }
