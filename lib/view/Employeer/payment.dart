import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/controller/Employeer/subscription_details.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class Payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    Get.find<HomeMasterController>();
    final paymentKey = new GlobalKey<FormBuilderState>();
    final width = Get.width;
    return GetBuilder<SubscriptionDetailController>(
      init: SubscriptionDetailController(),
      builder: (_) => Scaffold(
        backgroundColor: AppColors.bgGreen,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          title: Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth),
          actions: [
            InkWell(
              onTap: () {
                //  if(_.scaffoldKey.currentState.isDrawerOpen){
                Get.back();

                // }else{
                //   _.scaffoldKey.currentState.openDrawer();
                // }
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: AppColors.green,
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              SubText(
                'Payments',
                align: TextAlign.center,
                fontFamily: 'Freight',
                size: 30,
                color: AppColors.green,
                colorOpacity: 0.5,
              ),
              SizedBox(
                height: 35,
              ),
              FormBuilder(
                key: paymentKey,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 16),
                  child: Container(
                    width: width,
                    child: Card(
                      color: AppColors.white,
                      elevation: 3.0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            SubText(
                              "Chosen Package",
                              size: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SubText('${data[0]}'),
                            SizedBox(
                              height: 10,
                            ),
                            DecoratedInputField(
                              name: 'cardNumber',
                              text: 'Card Number',
                              controller: _.cardNumberController,
                              hintText: 'Enter Card Number',
                              // icon: Icons.email,
                              keyboard: TextInputType.number,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(16),
                                FormBuilderValidators.minLength(16),
                              ]),
                              onChange: (val) {
                                val = _.cardNumberController.text;
                              },
                            ),
                            DecoratedInputField(
                              name: 'cvc',
                              text: 'CVC',
                              controller: _.cvcController,
                              hintText: 'Enter CVC Number',
                              // icon: Icons.email,
                              keyboard: TextInputType.number,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(3),
                                FormBuilderValidators.minLength(3),
                              ]),
                              onChange: (val) {
                                val = _.cvcController.text;
                              },
                            ),
                            SubText(
                              "Expiry Date",
                              align: TextAlign.start,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    children: [
                                      SubText("Month"),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: DropdownButton<String>(
                                            value: _.monthDropDown,
                                            underline: SizedBox(),
                                            items: _.monthList
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child:
                                                    SubText(value, size: 12.0),
                                              );
                                            }).toList(),
                                            hint: Text("Jan"),
                                            onChanged: (val) {
                                              _.monthDropDown = val!;
                                              _.update();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    children: [
                                      SubText("Year"),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: DropdownButton<String>(
                                            value: _.yearDropDown,
                                            underline: SizedBox(),
                                            items: <String>[
                                              '2022',
                                              '2023',
                                              '2024',
                                              '2025',
                                              '2026',
                                              '2027',
                                              '2028',
                                              '2029',
                                              '2030',
                                              '2031',
                                              '2032',
                                              '2033',
                                              '2034',
                                              '2035',
                                              '2036'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child:
                                                    SubText(value, size: 12.0),
                                              );
                                            }).toList(),
                                            hint: Text("Jan"),
                                            onChanged: (val) {
                                              _.yearDropDown = val!;
                                              _.update();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                       SizedBox(height: 10,),
                            CustomButton(
                              title: "Confirm Payment",
                              onTap: () {
                                if (paymentKey.currentState!.validate()) {

                                    _.saveCardInformation(data[3].toString(),
                                        data[2].toString(), data[1].toString());
                                }

                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
