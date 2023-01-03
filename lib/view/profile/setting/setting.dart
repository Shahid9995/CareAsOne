import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/constants/size.dart';
import 'package:careAsOne/view/profile/setting/account.dart';
import 'package:careAsOne/view/profile/setting/education_detail.dart';
import 'package:careAsOne/view/profile/setting/work_experience.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = Get.width;

    return SingleChildScrollView(
        child: Container(
            //height: Get.height * 2,
            width: width,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            margin: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeading('Profile Settings'),
                    SizedBox(height: 15.0),
                    Container(
                      child: TabBar(
                        indicatorWeight: 3.0,
                        indicatorColor: AppColors.green,
                        labelColor: AppColors.green,
                        isScrollable: true,
                        unselectedLabelColor: AppColors.black,
                        labelStyle: TextStyle(fontSize: 12.0),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        tabs: [
                          Tab(text: 'ACCOUNT'),
                          Tab(text: 'WORK EXPERIENCE'),
                          Tab(text: 'EDUCATION DETAILS'),
                        ],
                      ),
                    ),
                    Container(
                      height: height(context) * 0.65,
                      child: TabBarView(
                        children: [
                          AccountPage(),
                          WorkExperiencePage(),
                          EducationDetailsPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}

class GenderRadio extends StatelessWidget {
  const GenderRadio(
      {Key? key,required this.value,required this.text, this.onChange,required this.groupVal})
      : super(key: key);

  final bool value;
  final String text;
  final void Function(Object?)? onChange;
  final int groupVal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          activeColor: Theme.of(context).primaryColor,
          groupValue: groupVal,
          value: value,
          onChanged: onChange,
        ),
        SubText(text, colorOpacity: 0.5),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab(
      {Key? key,required this.isSelected,required this.text,required this.width,required this.onTap})
      : super(key: key);
  final String text;
  final bool isSelected;
  final double width;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    color: isSelected ? AppColors.green : Colors.grey,
                    width: 3),
              )),
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? AppColors.green : Colors.grey,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
