import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/Employeer/employee_register_controller.dart';
import '../../../widget/tags/chip_tag.dart';
import '../../../widget/text.dart';

class EmployerPlansScreen extends StatefulWidget {
  const EmployerPlansScreen({Key? key}) : super(key: key);

  @override
  State<EmployerPlansScreen> createState() => _EmployerPlansScreenState();
}

class _EmployerPlansScreenState extends State<EmployerPlansScreen> {
  @override
  Widget build(BuildContext context) {
    var employeeRegisterController = Get.find<EmployerRegisterController>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(

            children: [
              MainHeading("Plans"),
              employeeRegisterController.planError==null?SizedBox():Row(
                children: [
                  SubText("Please select a plan",color: Colors.red,),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              employeeRegisterController.plansList.isEmpty?Center(child: Text("No Plans Available",style: TextStyle(fontSize:20,fontWeight:FontWeight.w600,color: Colors.grey[400]!),),):Column(
                children: List.generate(
                  employeeRegisterController.plansList.length,
                  (index) => Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.87,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0, 3))
                            ]),
                        child: Column(
                          children: [
                            employeeRegisterController.plansList[index].name
                                        .toString() ==
                                    "Enterprise"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 120,
                                        child: CustomPaint(
                                          painter: PriceTagPaint(),
                                          child: Center(
                                            child: Text(
                                              "Recommended",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(height: 10),
                            MainHeading(employeeRegisterController
                                .plansList[index].name
                                .toString()),
                            SizedBox(
                              height: 5,
                            ),
                            Heading("\$" +
                                employeeRegisterController.plansList[index].cost
                                    .toString()),
                            Text(
                                "◦ Up to ${index == 0 ? "10" : index == 1 ? "30" : "50"} qualified candidates in your area\n" +
                                    "◦ Unlimited in-platform messaging\n" +
                                    "◦ Automated Text & Voicemail Reminders\n" +
                                    "◦ Unlimited live video interviews"),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: CustomButton(
                                textColor: Colors.white,
                                title: "Select",

                                btnColor:employeeRegisterController.planId.toString()==  employeeRegisterController
                                    .plansList[index].id
                                    .toString()?Colors.orangeAccent: AppColors.green,
                                onTap: () {
                                  setState((){
                                    employeeRegisterController.planId =
                                      employeeRegisterController
                                          .plansList[index].id
                                          .toString();
                                    employeeRegisterController.planType =
                                      employeeRegisterController
                                          .plansList[index].slug
                                          .toString();
                                    employeeRegisterController.stripePlanId =
                                      employeeRegisterController
                                          .plansList[index].stripePlanId
                                          .toString();
                                    employeeRegisterController.costId =
                                      employeeRegisterController
                                          .plansList[index].slug
                                          .toString();
                                    employeeRegisterController.amount =
                                      employeeRegisterController
                                          .plansList[index].cost
                                          .toString();

                                  });

                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
