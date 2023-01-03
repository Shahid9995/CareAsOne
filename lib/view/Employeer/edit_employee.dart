import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/edit_employee.dart';
import 'package:careAsOne/view/messages/messages.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class EmpEditEmployeePage extends StatelessWidget {
  final editEmployee = new GlobalKey<ScaffoldState>();
  final editEmployeeKey = new GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmpEditEmployeeController>(
        init: EmpEditEmployeeController(),
        builder: (_) => Scaffold(
            key: editEmployee,
            backgroundColor: AppColors.bgGreen,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              automaticallyImplyLeading: false,
              title:Container( height: 40,width: 40,
                  child: Image.asset('assets/images/playstore.png', fit: BoxFit.fitWidth)),
              actions: [
                UnReadMsgIconButton(
                  onTap: () {
                    Get.to(() => MessagesPage());
                  },
                  msgNumber: 0,
                ),
                InkWell(
                  onTap: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child:IconButton(icon: Icon(Icons.exit_to_app_rounded,color: AppColors.green,),onPressed: (){
                      Get.back();
                    },),
                  ),
                ),
              ],
            ),

            body: Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              margin: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: editEmployeeKey,
                  child: _.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.green)),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainHeading('EDIT EMPLOYEE'),
                            SizedBox(height: 20.0),
                            DecoratedInputField(
                              name: 'First Name',
                              text: "EMPLOYEE FIRST NAME*",
                              hintText: 'First Name',
                              icon: Icons.email,
                              controller: _.empFName,
                              keyboard: TextInputType.text,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {
                                val = _.empFName.text;
                              },
                            ),
                            DecoratedInputField(
                              name: 'Last Name',
                              text: "EMPLOYEE LAST NAME*",
                              hintText: 'Last Name',
                              icon: Icons.email,
                              controller: _.empLName,
                              keyboard: TextInputType.text,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {
                              },
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  top: 13, bottom: 13, left: 8),
                              margin: EdgeInsets.only(bottom: 10, left: 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black38, width: 1)),
                              child: SubText(
                                _.email.text,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                            DecoratedInputField(
                              name: 'Job Title',
                              text: "JOB TITLE*",
                              controller: _.jobTitle,
                              hintText: 'Job Title',
                              icon: Icons.email,
                              keyboard: TextInputType.text,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {
                              },
                            ),
                            DecoratedInputField(
                              name: 'Salary',
                              text: "TOTAL SALARY*",
                              controller: _.totalSalary,
                              hintText: 'Salary',
                              icon: Icons.email,
                              keyboard: TextInputType.number,

                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChange: (val) {
                              },
                            ),
                            SizedBox(height: 15.0),
                            SubText(
                              "Status",
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 55,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 01, color: Colors.grey[400]!),
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              margin: EdgeInsets.only(
                                  bottom: 10, top: 5, left: 0, right: 0),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: _.status == ""
                                    ? Text("Select Status")
                                    : Text(_.status),
                                underline: SizedBox(
                                  height: 0,
                                ),
                                items: <String>["Enable", "Disable"]
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  _.status = val!;
                                  _.update();
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            CustomButton(
                              onTap: () {
                                if (editEmployeeKey.currentState!.validate()) {
                                  _.updateEmployee(context, {
                                    "id": _.employees!.id,
                                    "name": "${_.empFName.text}" ,
                                    "last_name":"${_.empLName.text}",
                                    "job_title": _.jobTitle.text,
                                    "salary": _.totalSalary.text,
                                    "status": _.status == "Enable" ? 1 : 2,
                                  });
                                }
                              },
                              title: 'SAVE CHANGES',
                              textColor: AppColors.white,
                              btnColor: AppColors.green,
                            ),
                          ],
                        ),
                ),
              ),
            )));
  }
}
