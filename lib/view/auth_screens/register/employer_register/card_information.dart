import 'package:careAsOne/controller/Employeer/employee_register_controller.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../widget/text.dart';

class EmployerCardScreen extends StatefulWidget {
  const EmployerCardScreen({Key? key}) : super(key: key);

  @override
  State<EmployerCardScreen> createState() => _EmployerCardScreenState();
}

class _EmployerCardScreenState extends State<EmployerCardScreen> {
  @override
  Widget build(BuildContext context) {
    var employeeRegisterController = Get.find<EmployerRegisterController>();
    return Container(
      height: MediaQuery.of(context).size.height*0.85,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              MainHeading("Card Information"),
              SizedBox(
                height: 10,
              ),
              CreditCardWidget(
                cardNumber: employeeRegisterController.cardNumber,
                expiryDate: employeeRegisterController.expireDate,
                cardHolderName: employeeRegisterController.holderName,
                cvvCode: employeeRegisterController.cvv,
                showBackView: employeeRegisterController.showBack,
                backgroundImage: 'assets/employeer/card_bg.jpg',
              //  glassmorphismConfig: Glassmorphism.defaultConfig(),
                obscureCardNumber: true,
                obscureCardCvv: false,
                isHolderNameVisible: true,
                height: 175,
                textStyle: TextStyle(color: Colors.white),
                width: MediaQuery.of(context).size.width,
                isChipVisible: true,
                isSwipeGestureEnabled: true,
                animationDuration: Duration(milliseconds: 1000),
                onCreditCardWidgetChange: (cardBrand) {},
              ),
              /*CreditCardForm(
                formKey: employeeRegisterController.formKey, // Required
                onCreditCardModelChange: (CreditCardModel data) {
                  setState(() {
employeeRegisterController.holderName=data.cardHolderName;
employeeRegisterController.cardNumber=data.cardNumber;
employeeRegisterController.cvv=data.cvvCode;
employeeRegisterController.expireDate=data.expiryDate;
                  });
                }, // Required
                themeColor: Colors.red,
                obscureCvv: false,
                obscureNumber: false,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,

                cardNumberDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),

                cvvCodeDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: const InputDecoration(

                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ), cardNumber: employeeRegisterController.cardNumber, cvvCode: employeeRegisterController.cvv, expiryDate: employeeRegisterController.cvv, cardHolderName: employeeRegisterController.holderName,
              ),*/
              FormBuilder(
                  key: employeeRegisterController.formKey,
                  child: Column(
                    children: [
                      DecoratedInputField(
                        controller: employeeRegisterController.cardNumberController,
                        text: "Card Number*",
                        name: 'cardNumber',
                        hintText: "Card Number",
                        keyboard: TextInputType.number,
                        onChange: (val) {
                          setState(() {
                            employeeRegisterController.showBack=false;
                          employeeRegisterController.cardNumber=val!;
                        });

                        },
                        inputFormatters: [  FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                        validations: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                      ),
                      employeeRegisterController.cardNumberError==null?SizedBox():Row(
                        children: [
                          SubText(employeeRegisterController.cardNumberError!,color: Colors.red,),
                        ],
                      ),
                      DecoratedInputField(
                        controller: employeeRegisterController.holderNameController,
                        text: "Holder Name*",
                        name: 'holderName',
                        hintText: "Holder Name",
                        onChange: (val) {
                          setState(() {
                            employeeRegisterController.showBack=false;
                            employeeRegisterController.holderName=val!;
                          });
                        },

                        validations: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                      ),
                      employeeRegisterController.holderNameError==null?SizedBox():Row(
                        children: [
                          SubText(employeeRegisterController.holderNameError!,color: Colors.red,),
                        ],
                      ),
                      DecoratedInputField(
                        controller: employeeRegisterController.cvvController,
                        text: "CVV*",
                        name: 'cvv',
                        hintText: "CVV",
                        onChange: (val) {
                          setState(() {
                            employeeRegisterController.showBack=true;
                            employeeRegisterController.cvv=val!;
                          });
                        },
                        keyboard: TextInputType.number,
                        validations: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                      ),
                      employeeRegisterController.cvvError==null?SizedBox():Row(
                        children: [
                          SubText(employeeRegisterController.cvvError!,color: Colors.red,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            margin: EdgeInsets.only(
                                bottom: 10, top: 5, left: 0, right: 0),
                            decoration: BoxDecoration(

                                borderRadius:
                                BorderRadius.circular(
                                    0.0),
                                color: Colors.transparent,
                                border: Border.all(
                                    color: Colors.grey[400]!)),
                            child: DropdownButtonFormField<
                                String>(
                              isExpanded: true,
                              menuMaxHeight: 300,
                              decoration:
                              const InputDecoration(
                                  enabledBorder:
                                  InputBorder.none,
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.only(
                                      bottom: 0)),
                              items: employeeRegisterController.monthModelList
                                  .map((data) =>
                                  DropdownMenuItem<
                                      String>(
                                    child:
                                    Text(data.monthChar!,style: TextStyle(color: AppColors.green),),
                                    value: data.monthDigit
                                        .toString(),
                                  ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(
                                      FocusNode());
                                  employeeRegisterController.selectedMonth =
                                      value;
                                });
                                print(employeeRegisterController.selectedMonth);
                              },
                              hint: Text(employeeRegisterController.hintMonth,
                                  style: const TextStyle(color: AppColors.green,
                                      fontSize: 14)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            height: 45,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 01, color: Colors.grey[400]!),
                            ),
                            padding: EdgeInsets.only(left: 5, right: 5),
                            margin: EdgeInsets.only(
                                bottom: 10, top: 5, left: 0, right: 0),
                            child: DropdownButton<String>(
                              menuMaxHeight: 300,
                              elevation: 16,
                              isExpanded: true,
                              iconEnabledColor: Colors.grey,
                              iconDisabledColor: Colors.grey,
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  employeeRegisterController.selectedYear = value!;
                                  employeeRegisterController.update();
                                });

                              },
                              hint: employeeRegisterController.selectedYear == "" || employeeRegisterController.selectedYear == null
                                  ? Text(
                                "Select Year",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              )
                                  : Text(employeeRegisterController.selectedYear,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: AppColors.green,
                                      fontSize: 14)),
                              items: employeeRegisterController.yearList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: AppColors.green, fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],),
                      CustomButton(title: "Save",textColor: Colors.white,btnColor: AppColors.green,onTap: ()async{

  await employeeRegisterController.postEmployeeAllData();
setState(() {

});



                      },),


                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
