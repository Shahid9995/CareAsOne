import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/employee_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login.dart';

class EmployerRegistrationScreen extends StatefulWidget {
  const EmployerRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<EmployerRegistrationScreen> createState() =>
      _EmployerRegistrationScreenState();
}

class _EmployerRegistrationScreenState
    extends State<EmployerRegistrationScreen> {



  @override
  void initState() {
    Get.lazyPut(() => EmployerRegisterController());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<EmployerRegisterController>(
        init: EmployerRegisterController(),
        builder: (_)=> Scaffold(
          key:_.scaffoldKey,


          body:SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bgWall.png'), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,

                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _.pages.length,
                                    (indexIndicator) => Padding(
                                  padding:
                                  const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color:
                                        _.currentPage == indexIndicator
                                            ? AppColors.green
                                            : Colors.grey,
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                  ),
                                )),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.87,
                            child: PageView.builder(
                                onPageChanged: (val) {
                                  setState(() {
                                    _.currentPage = val;
                                  });
                                },
                                itemCount: _.pages.length,
                                itemBuilder: (context, index) => Container(
                                    height: MediaQuery.of(context).size.height * 0.87,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),

                                       _.pages[index],

                                      ],
                                    ))),
                          ),

                        ],
                      ),
                    ),
                  ),
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
        ),
      ),
    );
  }
}
