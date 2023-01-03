import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/position_controller.dart';
import 'package:careAsOne/view/search/filter.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class JobPositionFilter extends StatelessWidget {
  const JobPositionFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetStorage storage = new GetStorage();
    var token = storage.read("authToken");
    final width = Get.width;
    return GetBuilder<PositionController>(
      init: PositionController(),
      builder: (_) => Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Container(
            // height: Get.height * 1.8,
            width: width,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            margin: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Checkbox(
                      value: _.nursingCheckbox,
                      onChanged: (value) {
                        _.nursingCheckbox = !_.nursingCheckbox;
                        _.positions = "Certified Nursing Assistance";
                        _.update();
                      },
                    ),
                    SubText('Certified Nursing Assistance'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _.practicalNurse,
                      onChanged: (value) {
                        _.position1 = "Licensed Practical Nurse";
                        _.practicalNurse = !_.practicalNurse;
                        _.update();
                      },
                    ),
                    SubText('Licensed Practical Nurse'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _.directSupport,
                      onChanged: (value) {
                        _.directSupport = !_.directSupport;

                        _.update();
                      },
                    ),
                    Text('Direct Support Professional'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _.homeHealthAid,
                      onChanged: (value) {
                        _.homeHealthAid = !_.homeHealthAid;
                        _.update();
                      },
                    ),
                    Text('Home Health Aid'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _.caregiver,
                      onChanged: (value) {
                        _.caregiver = !_.caregiver;
                        _.update();
                      },
                    ),
                    Text('Caregiver'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _.medicalTech,
                      onChanged: (value) {
                        _.medicalTech = !_.medicalTech;
                        _.update();
                      },
                    ),
                    Text('Medical Technician'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _.regNurse,
                      onChanged: (value) {
                        _.regNurse = !_.regNurse;

                        _.update();
                      },
                    ),
                    Text('Registered Nurse'),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onTap: () {
                    //
                    Get.off(FilterPage(),
                        arguments: [_.positions, _.position1]);
                  },
                  title: 'SHOW',
                  btnColor: AppColors.green,
                  textColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
