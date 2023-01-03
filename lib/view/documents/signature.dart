import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/documents/share.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'add.dart';

class SignatureDocPage extends StatelessWidget {
  const SignatureDocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              onChange: (val) {},
              validators: FormBuilderValidators.compose([]),
            ),
            SizedBox(height: 30.0),
            CustomButton(
              onTap: () {
                Get.to(() => AddDocPage());
              },
              title: 'ADD NEW',
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: Checkbox(value: true, onChanged: (val) {}),
                    ),
                    SizedBox(width: 5.0),
                    SubText('All', size: 12.0),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.close,
                                    size: 28.0, color: AppColors.black),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFFF0F0EF))),
                                child: Column(
                                  children: [
                                    SubText(
                                        'Are you sure you want to delete this documents?',
                                        size: 16.0,
                                        colorOpacity: 0.7),
                                    SizedBox(height: 30.0),
                                    SubText('2 ITEMS',
                                        size: 12.0, color: AppColors.green),
                                    SizedBox(height: 30.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            onTap: () {},
                                            title: 'YES',
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: CustomButton(
                                            onTap: () {},
                                            title: 'NO',
                                            btnColor: AppColors.green,
                                            textColor: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline,
                          size: 20.0, color: AppColors.black.withOpacity(0.5)),
                      SizedBox(width: 2.5),
                      SubText('DELETE', size: 12.0, colorOpacity: 0.9),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => ShareDocPage());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.share,
                          size: 20.0, color: AppColors.black.withOpacity(0.5)),
                      SizedBox(width: 2.5),
                      SubText('SHARE WITH EMPLOYER',
                          size: 12.0, colorOpacity: 0.9),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}
