import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/share_Doc.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareEmpDocPage extends StatelessWidget {
  final List docList;
  final String type;

  const ShareEmpDocPage({Key? key,required this.docList,required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SharedDocsController>(
        init: SharedDocsController(),
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
                        controller.empName = val!.toLowerCase();
                        controller.update();
                        controller.searchedList = [];
                        for (int i = 0; i < controller.empList.length; i++) {
                          if (controller.empList[i].name.toString().contains(controller.empName.toLowerCase())) {
                            controller.searchedList.add(controller.empList[i]);
                            controller.update();
                          }
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: AppColors.green,
                        ),
                        onPressed: () {},
                      ),

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
                                              if (type == null ||
                                                  type == "document") {
                                                controller.selectAll = val!;
                                                controller.empService.employeesList!.forEach((element) {
                                                  element.isSelected = val;
                                                  if(controller.selectAll) {
                                                    if (element.isSelected ==
                                                        true &&
                                                        element.status == 1) {
                                                      controller.id.add(
                                                          element.userId);
                                                    } else
                                                    if (element.isSelected ==
                                                        true &&
                                                        element.status == 0) {
                                                    } else {

                                                    }
                                                  }else{
                                                    controller.id = [];
                                                    controller.update();
                                                  }
                                                });
                                                controller.update();
                                              } else {
                                                controller.selectAll = val!;
                                                controller.empService.employeesList!.forEach((element) {
                                                  element.isSelected = val;
                                                  if (controller.selectAll) {
                                                    if (element.isSelected ==
                                                        true &&
                                                        element.status == 1) {
                                                      controller.id.add(
                                                          element.id);
                                                    } else
                                                    if (element.isSelected ==
                                                        true &&
                                                        element.status == 0) {
                                                    } else {

                                                    }
                                                  }
                                                  else {
                                                    controller.id = [];
                                                    controller.update();
                                                  }
                                                }
                                                  );
                                                controller.update();
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        SubText('All', size: 12.0),
                                      ],
                                    ),
                                  ],
                                ),
                                controller.empList == null
                                    ? Center(
                                        child: Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: SubText("No User Found"),
                                      ))
                                    : controller.searchedList.length == 0
                                        ? Column(
                                            children: List.generate(
                                                controller.empList.length,
                                                (index) {
                                              return controller.empList[index]
                                                          .status ==
                                                      1
                                                  ? ShareDocumentCard(
                                                      employees: controller
                                                          .empList[index],
                                                      onSelect: (val) {
                                                        if (val == true) {
                                                          if (type == null || type == "document") {
                                                            if (controller.empList[index].status == 1) {
                                                              controller.id.add(controller.empList[index].userId);
                                                            }
                                                          } else {
                                                            if(controller.empList[index].status == 1) {
                                                              controller.id.add(controller.empList[index].id);
                                                            }
                                                          }
                                                        } else {
                                                          if (type == null ||
                                                              type ==
                                                                  "document") {
                                                            controller.id.remove(
                                                                controller
                                                                    .empList[
                                                                        index]
                                                                    .userId);
                                                          } else {
                                                            controller.id.remove(
                                                                controller
                                                                    .empList[
                                                                        index]
                                                                    .id);
                                                          }
                                                        }
                                                        controller
                                                            .empList[index]
                                                            .isSelected = val!;
                                                        controller.update();
                                                      },
                                                    )
                                                  : SizedBox();
                                            }),
                                          )
                                        : Column(
                                            children: List.generate(
                                                controller.searchedList.length,
                                                (index) {
                                              return
                                                controller.searchedList[index]
                                                    .status ==
                                                    1
                                                    ?ShareDocumentCard(
                                                employees: controller
                                                    .searchedList[index],
                                                onSelect: (val) {
                                                  if (val == true) {
                                                    if (type == null ||
                                                        type == "document") {
                                                      controller.id.add(
                                                          controller
                                                              .searchedList[
                                                                  index]
                                                              .userId);
                                                    } else {
                                                      controller.id.add(
                                                          controller
                                                              .searchedList[
                                                                  index]
                                                              .id);
                                                    }
                                                  } else {
                                                    if (type == null ||
                                                        type == "document") {
                                                      controller.id.remove(
                                                          controller
                                                              .searchedList[
                                                                  index]
                                                              .userId);
                                                    } else {
                                                      controller.id.remove(
                                                          controller
                                                              .searchedList[
                                                                  index]
                                                              .id);
                                                    }
                                                  }
                                                  controller.searchedList[index]
                                                      .isSelected = val!;
                                                  controller.update();
                                                },
                                              ):SizedBox();
                                            }),
                                          ),
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
                                                id: controller.id,
                                                type: type);
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
