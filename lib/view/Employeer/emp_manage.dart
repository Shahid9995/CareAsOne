import 'dart:isolate';
import 'dart:ui';

import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/home_master.dart';
import 'package:careAsOne/controller/Employeer/manage_emp.dart';
import 'package:careAsOne/controller/JobSeeker/manage_availability.dart';
import 'package:careAsOne/model/dashboard.dart';
import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/widget/card.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ManageEmployees extends StatefulWidget {
  @override
  _ManageEmployeesState createState() => _ManageEmployeesState();
}ReceivePort _port = ReceivePort();

class _ManageEmployeesState extends State<ManageEmployees> {
  var dashboardData=Get.find<HomeMasterController>();

  EmpDashboardModel empDashboardModel = new EmpDashboardModel();
  final storage = GetStorage();
  var token;
  @override
  initState() {
    token = storage.read("authToken");
getDetail();
    super.initState();
  }
  getDetail()async{
    empDashboardModel=await dashboardData.getDashboardData(token);
  }



  @override
  Widget build(BuildContext context) {

    return GetBuilder<ManageEmployeesController>(
      init: ManageEmployeesController(),
      builder: (_) =>
          SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: _.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.green)),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainHeading('Manage Employees'),
                      SizedBox(height: 20.0),
                      SearchField(
                        suffixIcon: IconButton(icon: Icon(Icons.search,color: AppColors.green,),onPressed:(){}),
                        onChange: (val) {

                          _.employeesName=val!.toLowerCase();
                          _.searchedList=[];
                          _.update();
                          for(int i=0;i<_.employeesList!.length;i++){
                            if(_.employeesList![i].name!.toLowerCase().contains(_.employeesName.toLowerCase())){
                              _.searchedList.add(_.employeesList![i]);
                              _.update();
                            }
                          }

                        },
                        validators: FormBuilderValidators.compose([]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _.employeesList == null || _.employeesList!.isEmpty
                          ? SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SubText(
                                          "Select All",
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        Checkbox(
                                          value: _.selectAll,
                                          onChanged: (val) {
                                            _.selectAll = val!;
                                            _.employeesList!.forEach((element) {
                                              element.isSelected = val;
                                              if (element.isSelected == true) {
                                                _.id.add(element.id);
                                              } else {
                                                _.id = [];
                                              }
                                            });
                                            _.update();
                                          },
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SubText(
                                            "Delete All",
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        if (_.id.length != 0) {
                                          _.showSelectionDialog(context, _.id);
                                        } else {
                                          showToast(
                                              msg: 'Please Select Employee');
                                        }
                                      },
                                    )),
                              ],
                            ),
                      _.employeesList == null || _.employeesList!.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: SubText(
                                "No Employees",
                                color: Colors.grey,
                                size: 18,
                              )),
                            )
                          : _.searchedList.length==0?Column(
                              children: List.generate(_.employeesList!.length,
                                  (index) {
                                return EmployeeDetailCard(
                                  isAllowDoc:empDashboardModel.result!.addOnDoc!=null?"yes":"no",
                                    jobTitle:
                                        "${_.employeesList![index].jobTitle}",
                                    name: "${_.employeesList![index].name}",
                                    email: " ${_.employeesList![index].email}",
                                    salary: "\$ ${_.employeesList![index].salary}",
                                    status: " ${_.employeesList![index].status}",
                                    onEye: () {

                                      Get.find<HomeMasterController>().navigateToPage(3);
                                      _.update();
                                    },
                                    onEdit: () {
                                      Get.toNamed(AppRoute.empEditEmployeeRoute,
                                          arguments: {
                                            "empData": _.employeesList![index]
                                          });
                                    },
                                    onDelete: () {
                                      if (_.id.length != 0) {
                                        _.showSelectionDialog(context, _.id);
                                      } else {
                                        showToast(
                                            msg: 'Please Select Employee');
                                      }
                                    },
                                    isSelect: (bool? val) {
                                      _.employeesList![index].isSelected = val!;
                                      if (val == true) {
                                        _.id.add(_.employeesList![index].id);
                                      } else {
                                        _.id.remove(_.employeesList![index].id);
                                      }
                                      _.update();
                                    },
                                    select: _.employeesList![index].isSelected,
                                    canSee: true);
                              }),
                            ):Column(
                        children: List.generate(_.searchedList.length, (index) {
                          return EmployeeDetailCard(
                              jobTitle:
                              "${_.searchedList[index].jobTitle}",
                              name: "${_.searchedList[index].name}",
                              email: " ${_.searchedList[index].email}",
                              salary: "\$ ${_.searchedList[index].salary}",
                              status: " ${_.searchedList[index].status}",
                              onEye: () async {
                                Get.find<HomeMasterController>().navigateToPage(3);
                                _.update();
                              },
                              onEdit: () {
                                Get.toNamed(AppRoute.empEditEmployeeRoute,
                                    arguments: {
                                      "empData": _.searchedList[index]
                                    });
                              },
                              onDelete: () {
                                if (_.id.length != 0) {
                                  _.showSelectionDialog(context, _.id);
                                } else {
                                  showToast(
                                      msg: 'Please Select Employee');
                                }
                              },
                              isSelect: (bool? val) {
                                _.searchedList[index].isSelected = val!;
                                if (val == true) {
                                  _.id.add(_.searchedList[index].id);
                                } else {
                                  _.id.remove(_.searchedList[index].id);
                                }
                                _.update();
                              },
                              select: _.searchedList[index].isSelected,
                              canSee: true);
                        }),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      // ),
    );
  }

}

class AvailabilityClass extends StatelessWidget {
  const AvailabilityClass({
    required this.controller,
    this.dayTitle,
    this.onTap,
    required this.checkValue,
    Key? key,
  });

  final ManageAvailabilityController controller;
  final String? dayTitle;
  final void Function(bool?)? onTap;
  final bool checkValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(value: checkValue, onChanged: onTap),
                Text(
                  dayTitle.toString(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: checkValue ? AppColors.green : Colors.grey),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  checkValue ? "Working Day" : "Day Off",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.withOpacity(0.4)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  // width: width/3,
                  height: 40.0,

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black.withOpacity(0.2)),
                  ),
                  child: DropdownButton<String>(
                    // isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: "09:00 AM",
                    underline: SizedBox(),
                    items: <String>['09:00 AM', '010:00 AM']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SubText(
                          value,
                          size: 12.0,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      // _.dropdownValue = val;
                      controller.update();
                    },
                  ),
                ),
                Text("-"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  // width: width/3,
                  height: 40.0,

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black.withOpacity(0.2)),
                  ),
                  child: DropdownButton<String>(
                    // isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: "09:00 AM",
                    underline: SizedBox(),
                    items: <String>['09:00 AM', '010:00 AM']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SubText(
                          value,
                          size: 12.0,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      // _.dropdownValue = val;
                      controller.update();
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.grey,
                    ))
              ],
            ),
            SizedBox(height: 10),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: AppColors.green,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }

}
