import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/auth_screens/login.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'job_seeker.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bgWall.png'),
                    fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 1,
                      child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 20.0),
                        color: AppColors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MainHeading('Create Account'),
                            SizedBox(height: 15.0),

                            Container(
                              child: TabBar(
                                isScrollable: true,
                                indicatorWeight: 3.0,
                                indicatorColor: AppColors.green,
                                labelColor: AppColors.green,
                                unselectedLabelColor: AppColors.black,
                                labelStyle: TextStyle(fontSize: 12.0),
                                // labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                tabs: [
                                  Tab(text: 'JOB SEEKER'),
                                  // Tab(text: 'EMPLOYER'),
                                  // Tab(text: 'EMPLOYER'),
                                ],
                              ),
                            ),
                            Container(
                              height: 650,
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.5),
                                    child: JobSeekerPage(),
                                  ),
                             /*     Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.5),
                                    child: EmployerPage(),
                                  ),*/
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 2.5),
                                  //   child: EmployerPage(),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    MainHeading('We\'re glad to see you!',
                        color: AppColors.white),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        Get.offAll(() => LoginPage());
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        width: 120.0,
                        // height: 120.0,
                        child: Image.asset('assets/images/signInBtn.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

  }
}
