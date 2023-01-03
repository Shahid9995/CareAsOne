import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/manage_availability.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ManageAvailability extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return GetBuilder<ManageAvailabilityController>(
      init: ManageAvailabilityController(),
      builder: (_) => SingleChildScrollView(
        child: Container(
          width: width,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          margin: EdgeInsets.all(15),
          child: _.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColors.green,
                ))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 5.0),
                      MainHeading('Manage Availability'),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.85,
                                          child: SubText(
                                            'Select the date range you are available for your interview.',
                                              overflow: TextOverflow.clip,maxLines: 2,),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            _.addLeadAgent(
                                                context); // Call Function that has showDatePicker()
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.only(
                                                top: 13, bottom: 13, left: 8),
                                            margin: EdgeInsets.only(
                                                bottom: 10, left: 0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black38,
                                                    width: 1)),
                                            child: SubText(
                                              _.range == ''
                                                  ? 'Select Date'
                                                  : _.range,
                                              size: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
Container(
  width: MediaQuery.of(context).size.width*0.8,
    child: SubText("Select the days and times you are available.",overflow: TextOverflow.clip,maxLines: 2,)),
                      SizedBox(height: 10,),
                      //New Availability UI for test
                      Column(children:List.generate(_.jobSeekerAvailability.data!.length, (index) =>
                      Column(
                        children: [
                          Card(
                            elevation: 3.0,
                            child: Container(

                              decoration: BoxDecoration(
                                  color: index.isOdd?Colors.white:AppColors.bgGreen,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SubText(
                                          "Start",
                                          color: AppColors.green,
                                          fontWeight: FontWeight.bold,
                                          size: 17,
                                        ),
                                        SubText(
                                          "End",
                                          color: AppColors.green,
                                          fontWeight: FontWeight.bold,
                                          size: 17,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SubText(
                                          _.jobSeekerAvailability.data![index].startTime.toString(),
                                          size: 17,
                                        ),
                                        SubText("-"),
                                        SubText(
                                          _.jobSeekerAvailability.data![index].endTime.toString(),
                                          size: 17,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: List.generate(_.jobSeekerAvailability.data![index].days!.length, (index2) =>
                                        SubText(
                                          _.jobSeekerAvailability.data![index].days![index2].name!.substring(0,3).capitalizeFirst!,
                                          color: AppColors.green,
                                          fontWeight: FontWeight.bold,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: List.generate(_.jobSeekerAvailability.data![index].days!.length, (index2) =>
                                   Checkbox(value: _.preSelectedIds.contains(_.jobSeekerAvailability.data![index].days![index2].id), onChanged: (val){
                                     if(val!){
                               _.preSelectedIds.add(_.jobSeekerAvailability.data![index].days![index2].id!);
                               print(_.preSelectedIds);
                               _.update();
                                     }else{
                                       _.preSelectedIds.remove(_.jobSeekerAvailability.data![index].days![index2].id);
                                       print(_.preSelectedIds);
                                       _.update();

                                     }
                                   }),


                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),

                      ),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        child:CustomButton(
                                onTap: () {
                                  if(_.preSelectedIds.isEmpty){
showToast(msg: "Please select your availability slots");
                                  }else if(_.startDate!=null&&DateFormat("MM-dd-y").format(_.startDate)==DateFormat("MM-dd-y").format(_.endDate)){
                                    showToast(msg: "Please select correct date range");
                                  }else if(_.endDate==null){
                                    showToast(msg: "Please select correct date range");
                                  }else{
                                    _.postAvailabilityNew();
                                  }

                                  //  Get.find<ManageAvailabilityController>().update();
                                },
                                title: 'SAVE',
                                textColor: AppColors.white,
                                btnColor: AppColors.green,
                              )

                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
