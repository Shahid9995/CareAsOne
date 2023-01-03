import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/controller/Employeer/subscription_details.dart';
import 'package:careAsOne/view/Employeer/payment.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/tags/chip_tag.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter/material.dart';

class SubscriptionDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<HomeMasterController>();
    final width = Get.width;
    final height = Get.height;
    return GetBuilder<SubscriptionDetailController>(
      init: SubscriptionDetailController(),
      builder: (_) =>
          _.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.green)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: _.plan == "plans"
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            SubText(
                              'Care As One Hiring \n Solutions',
                              align: TextAlign.center,
                              fontFamily: 'Freight',
                              size: 30,
                              color: AppColors.green,
                              colorOpacity: 0.5,
                            ),
                            SizedBox(height: 35.0),
                            Column(
                              children: List.generate(_.planModelList.length,
                                  (index) {
                                if (_.planModelList[index].id == 1 ||
                                    _.planModelList[index].id == 7 ||
                                    _.planModelList[index].id == 13)
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: Container(
                                      width: width,
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SubText(
                                                  _.planModelList[index].name.toString() +
                                                      " Business Plan",
                                                  fontFamily: "GT",
                                                  color: AppColors.green,
                                                  size: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    _.planModelList[index]
                                                                    .value1 ==
                                                                false &&
                                                            _
                                                                    .planModelList[
                                                                        index]
                                                                    .value2 ==
                                                                false
                                                        ? SubText(
                                                            "\$ ${_.planModelList[index].cost}",
                                                            fontFamily: "GT",
                                                          )
                                                        : _.planModelList[index]
                                                                        .value1 ==
                                                                    true &&
                                                                _
                                                                    .planModelList[
                                                                        index]
                                                                    .value2!
                                                            ? SubText(
                                                                "\$ ${_.planModelList[index].cost! + 180}",
                                                                fontFamily:
                                                                    "GT",
                                                              )
                                                            : _.planModelList[index].value1 ==
                                                                        true &&
                                                                    _.planModelList[index].value2 ==
                                                                        false
                                                                ? SubText(
                                                                    "\$ ${_.planModelList[index].cost! + 80}",
                                                                    fontFamily:
                                                                        "GT",
                                                                  )
                                                                : _.planModelList[index].value2 ==
                                                                            true &&
                                                                        _.planModelList[index].value1 ==
                                                                            false
                                                                    ? SubText(
                                                                        "\$ ${_.planModelList[index].cost! + 100}",
                                                                        fontFamily:
                                                                            "GT",
                                                                      )
                                                                    : SizedBox(),
                                                    _.planModelList[index]
                                                        .id ==
                                                        13?SizedBox(
                                                      height: 40,
                                                      width: 140,
                                                      child: CustomPaint(
                                                        painter:
                                                            PriceTagPaint(),
                                                        child: Center(
                                                          child: Text(
                                                            "Recommended",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ):SizedBox()
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              height: 1.5,
                                              width: width,
                                              color:
                                                  Colors.grey.withOpacity(0.5)),
                                          Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SubText(
                                                  "Features of ${_.planModelList[index].name} Plan: ",
                                                  color: AppColors.black,
                                                  colorOpacity: 0.7,
                                                  fontWeight: FontWeight.bold,
                                                  size: 16,
                                                ),
                                                ListTile(
                                                  title: _.planModelList[index]
                                                              .id ==
                                                          1
                                                      ? Text(
                                                          '◦ 10 guaranteed qualified candidates in your area\n'
                                                          '◦ Unlimited in-platform messaging\n'
                                                              '◦ Automated Text & Voicemail Reminders\n'
                                                          '◦ Unlimited live video interviews')
                                                      : _.planModelList[index]
                                                                  .id ==
                                                              7
                                                          ? Text(
                                                              '◦ 30 guaranteed qualified candidates in your area\n'
                                                              '◦ Unlimited in-platform messaging\n'
                                                                  '◦ Automated Text & Voicemail Reminders\n'
                                                              '◦ Unlimited live video interviews')
                                                          : _.planModelList[index]
                                                                      .id ==
                                                                  13
                                                              ? Text('◦ 50 guaranteed qualified candidates in your area\n'
                                                                  '◦ Unlimited in-platform messaging\n'
                                                      '◦ Automated Text & Voicemail Reminders\n'
                                                                  '◦ Unlimited live video interviews')
                                                              : Text(''),
                                                ),

                                                SizedBox(
                                                  height: 20,
                                                ),

                                                CustomButton(
                                                  title: 'Buy Now',
                                                  onTap: () {
                                                    if (_.planModelList[index]
                                                                .name ==
                                                            "Starter" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            false &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .cost,
                                                            "{\"starter\":\"${_.planModelList[index].stripePlanId}\"}",
                                                            "starter"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Medium" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            false &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .cost,
                                                            "{\"medium\":\"${_.planModelList[index].stripePlanId}\"}",
                                                            "medium"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Enterprise" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            false &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .cost,
                                                            "{\"enterprise\":\"${_.planModelList[index].stripePlanId}\"}",
                                                            "enterprise"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Starter" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            true) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                180,
                                                            "{\"starter\":\"${_.planModelList[index].stripePlanId}\",\"Document_Management_Starter\":\"price_1H4vTLD31ApUAf8Xk4udaRRz\",\"Training_Videos_Starter\":\"price_1H4vTHD31ApUAf8XNNBY88mY\"}",
                                                            "starter"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Medium" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            true) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                180,
                                                            "{\"medium\":\"${_.planModelList[index].stripePlanId}\",\"Document_Management_Medium\":\"price_1H4vSzD31ApUAf8XVKeZSEva\",\"Training_Videos_Medium\":\"price_1H4vT4D31ApUAf8XRPlMU3AA\"}",
                                                            "medium"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Enterprise" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            true) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                180,
                                                            "{\"enterprise\":\"${_.planModelList[index].stripePlanId}\",\"Document_Management_Enterprise\":\"price_1HrTrwD31ApUAf8XqzgYfO1k\",\"Training_Videos_Enterprise\":\"price_1HrTrOD31ApUAf8XFuSjX1Wo\"}",
                                                            "enterprise"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Starter" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                100,
                                                            "{\"starter\":\"${_.planModelList[index].stripePlanId}\",\"Document_Management_Starter\":\"price_1H4vTLD31ApUAf8Xk4udaRRz\"}",
                                                            "starter"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Medium" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                100,
                                                            "{\"medium\":\"${_.planModelList[index].stripePlanId}\",\"Document_Management_Medium\":\"price_1H4vSzD31ApUAf8XVKeZSEva\"}",
                                                            "medium"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Enterprise" &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                100,
                                                            "{\"enterprise\":\"${_.planModelList[index].stripePlanId}\",\"Document_Management_Enterprise\":\"price_1HrTrwD31ApUAf8XqzgYfO1k\"}",
                                                            "enterprise"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Starter" &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                80,
                                                            "{\"starter\":\"${_.planModelList[index].stripePlanId}\",\"Training_Videos_Starter\":\"price_1H4vTHD31ApUAf8XNNBY88mY\"}",
                                                            "starter"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Medium" &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                80,
                                                            "{\"medium\":\"${_.planModelList[index].stripePlanId}\",\"Training_Videos_Medium\":\"price_1H4vT4D31ApUAf8XRPlMU3AA\"}",
                                                            "medium"
                                                          ]);
                                                    } else if (_
                                                                .planModelList[
                                                                    index]
                                                                .name ==
                                                            "Enterprise" &&
                                                        _.planModelList[index]
                                                                .value1 ==
                                                            true &&
                                                        _.planModelList[index]
                                                                .value2 ==
                                                            false) {
                                                      Get.to(() => Payment(),
                                                          arguments: [
                                                            _
                                                                .planModelList[
                                                                    index]
                                                                .name,
                                                            _.planModelList[index]
                                                                    .cost! +
                                                                80,
                                                            "{\"enterprise\":\"${_.planModelList[index].stripePlanId}\",\"Training_Videos_Enterprise\":\"price_1HrTrOD31ApUAf8XFuSjX1Wo\"}",
                                                            "enterprise"
                                                          ]);
                                                    }

                                                    //Get.to(Payment(),arguments: [_.planModelList[index].name,_.planModelList[index].cost,_.planModelList[index].stripePlanId]);
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                return SizedBox();
                              }),
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 30.0),
                            width: double.maxFinite,
                            color: AppColors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainHeading('Subscription'),
                                SizedBox(height: 35.0),
                                Container(
                                  height: !(context).isLandscape
                                      ? width / 1.2
                                      : height / 1.2,
                                  width: !(context).isPortrait
                                      ? width / 1.2
                                      : height / 1.2,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3))),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/employeer/subscription.png",
                                        height: width / 2,
                                        width: width / 2,
                                        scale: 1.0,
                                      ),
                                      SubText("Active Subscription"),
                                      SubText(
                                        _.storage.read("bought"),
                                        fontWeight: FontWeight.w500,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SubText(
                                  "Want to Upgrade the plan?",
                                  size: 16,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    SubText(
                                      "Please call us at ",
                                      size: 16,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        UrlLauncher.launch(
                                            "tel://1-855-544-2321");
                                      },
                                      child: SubText(
                                        "1-855-544-2321",
                                        color: AppColors.green,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                SubText(
                                  "Want to cancel your subscription?",
                                  size: 16,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    SubText(
                                      "Please call us at ",
                                      size: 16,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        UrlLauncher.launch(
                                            "tel://1-855-544-2321");
                                      },
                                      child: SubText(
                                        "1-855-544-2321",
                                        color: AppColors.green,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                ),
      // )
    );
  }
}
