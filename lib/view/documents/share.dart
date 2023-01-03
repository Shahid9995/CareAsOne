import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/seeker_share_doc.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ShareDocPage extends StatelessWidget {
  final List? docList;
  final String? type;

  const ShareDocPage({Key? key, this.docList, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeekerShareDoc>(
        init: SeekerShareDoc(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close, size: 28.0, color: AppColors.black),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MainHeading(type == null || type == "document"
                        ? 'Share Documents'
                        : "Share Videos"),
                    SizedBox(height: 30.0),
                    SearchField(
                      onChange: (val) {
                        controller.empName=val!.toLowerCase();
                        controller.update();
                        controller.searchedList=[];
                        for(int i=0;i<controller.employerList.length;i++){
                          if(controller.employerList[i].firstName!.toLowerCase().contains(controller.empName.toLowerCase())){
                            controller.searchedList.add(controller.employerList[i]);
                            controller.update();
                          }
                        }
                      },
                      suffixIcon: IconButton(icon: Icon(Icons.search,color: AppColors.green,),onPressed: (){},),
                      validators: FormBuilderValidators.compose([]),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFF0F0EF))),
                      child: controller.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.green)),
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: Checkbox(
                                            value: controller.selectAll,
                                            onChanged: (val) {
                                              controller.selectAll = val!;
                                              controller
                                                  .employerList
                                                  .forEach((element) {
                                                element.isSelected = val;
                                                if (element.isSelected ==
                                                    true) {
                                                  controller.id.add(element.id);
                                                } else {
                                                  controller.id = [];
                                                }
                                              });
                                              controller.update();
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        SubText('All', size: 12.0),
                                      ],
                                    ),

                                  ],
                                ),
                                controller.employerList == null
                                    ? Center(
                                        child: Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: SubText("No User Found"),
                                      ))
                                    : controller.searchedList.length==0?Column(
                                        children: List.generate(
                                            controller.employerList.length, (index) {
                                          return SeekerShareCard(

                                            allEmployer:
                                                controller.employerList[index],

                                            onSelect: (val) {
                                              if (val == true) {
                                                controller.id.add(controller
                                                    .employerList[index].id);
                                              } else {
                                                controller.id.remove(controller
                                                    .employerList[index].id);
                                              }
                                              controller.employerList[index]
                                                  .isSelected = val!;
                                              controller.update();
                                            },
                                          );
                                        }),
                                      ):Column(children: List.generate(controller.searchedList.length, (index) {
                                        return SeekerShareCard(

                                          allEmployer: controller.searchedList[index],
                                          onSelect: (val) {
                                            //  controller.empService.employeesList[index].isSelected = val;
                                            if (val == true) {
                                              controller.id.add(controller
                                                  .searchedList[index].id);
                                            } else {
                                              controller.id.remove(controller
                                                  .searchedList[index].id);
                                            }
                                            controller.searchedList[index]
                                                .isSelected = val!;
                                            controller.update();
                                          },
                                        );
                                }),),
                                SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        onTap: () {
                                          controller.id = [];
                                          Get.back();
                                        },
                                        title: 'CLOSE',
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(
                                      child: CustomButton(
                                        onTap: () {
                                          if (controller.id.length != 0) {
                                            controller.showSelectionDialog(
                                                context,
                                                fileld: docList,
                                                id: controller.id);
                                          } else {
                                            showToast(
                                                msg: 'Please Select Employee');
                                          }
                                        },
                                        title: 'SHARE',
                                        btnColor: AppColors.green,
                                        textColor: AppColors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
