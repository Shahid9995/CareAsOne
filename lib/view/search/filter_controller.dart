import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/circular_loader/circular_loader.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/model/job_search_model.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';

class FilterController extends GetxController {
  var token;
  GetStorage storage = new GetStorage();
  List<JobsSearchModel> allJobsList=[];
  List<JobsSearchModel> append = [];
  List<JobsSearchModel> responseData=[];
  List<JobsSearchModel> filteredList=[];
  int? jobCounter;
  int currentPage=1;
  bool nursingCheckbox=false;
  bool practicalNurse=false;
  bool directSupport=false;
  bool homeHealthAid=false;
  bool caregiver=false;
  bool medicalTech=false;
  bool regNurse=false;
  String city="";
  var citiesNewList=[];
  bool isLoading = true;
  bool partTimeCheck=false;
  bool fullTimeCheck=false;
  bool fullPartCheck=false;
  bool noExperienceCheck=false;
  bool lessThanOneCheck=false;
  bool oneThreeCheck=false;
  bool threeFiveCheck=false;
  bool fivePlusCheck=false;
  String lessThanOne = "";
  String oneThree = "";
  String threeFive = "";
  String fivePlus = "";
  String newFivePlus ='';
  String noExperience = "";
  String fullTime = "";
  String partTime = "";
  String fullPart = "";
  int responseCounter = 1;
  String schedual = "";
  String positions = "";
  String position1 = "";
  String position2 = "";
  String position3 = "";
  String position4 = "";
  String position5 = "";
  String position6 = "";
  String experience = "";
  String sortedBy = "";
  List<String> list = ['part-time', 'full-time', 'Full-and-Part-Time'];
  List<String> experienceList = [
    'No Experience',
    '< 1 Year',
    '1-3 Years',
    '3-5 Years',
    '5+ Years'
  ];
  var dropDownValue = 'part-time';
  String sorted = "date_desc";

  var experienceDropDown = 'No Experience';

  @override
  Future<void> onInit() async {
    isLoading=true;
    update();
    token = storage.read("authToken");
    jobCounter = 0;
    currentPage = 1;

    filteredList = [];


    noExperienceCheck = false;
    lessThanOneCheck = false;
    oneThreeCheck = false;
    threeFiveCheck = false;
    fivePlusCheck = false;
    partTimeCheck = false;
    fullTimeCheck = false;
    fullPartCheck = false;
    nursingCheckbox = false;
    practicalNurse = false;
    directSupport = false;
    homeHealthAid = false;
    caregiver = false;
    medicalTech = false;
    regNurse = false;
    update();
    responseData = [];

    await getAllJobDataOnce();
    isLoading = false;
    update();

    super.onInit();
  }
String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
  Future<List<JobsSearchModel>> getAllJobDataClear() async {
    print('${BaseApi.domainName}api/job-seeker/search-jobs?api_token=$token&page=1');
    allJobsList = [];
    append = [];
    Dio dio = new Dio();
    Response response = await dio.get(
        '${BaseApi.domainName}api/job-seeker/search-jobs?api_token=$token&page=1',
        options: Options(headers: {'Accept': 'application/json'}));

    if (response.statusCode == 200) {

      response.data['data']['jobs']['data'].forEach((e) {
        allJobsList.add(JobsSearchModel.fromJson(e));
      });
      allJobsList.forEach((element) {


        city = element.city.toString();
        if (city.contains('value')) {
          var cityList = [];
          try {
            var parsedJson;
            parsedJson = jsonDecode(city);
            String cityJson = "";
            cityList = parsedJson as List;

            for (int i = 0; i < cityList.length; i++) {
              cityJson = "${(i+1!=cityList.length&&i+1<city.length)?",":" "}"+cityList[i]['value'] + "" + cityJson;
              element.city = cityJson;
              citiesNewList.add("${cityList[i]['value']}");
              element.city = citiesNewList.toString();
            }
            element.city = cityJson;
          } catch (e) {}
        } else {
          element.city = city;
        }

      });
      isLoading = false;
      update();
    }
    return filteredList;
    return responseData;
  }
  Future<List<JobsSearchModel>> getAllJobDataOnce() async {
    print('${BaseApi.domainName}api/job-seeker/search-jobs?api_token=$token$partTime$fullTime$fullPart$positions$position1$position2$position3$position4$position5$position6$noExperience$lessThanOne$oneThree$threeFive$fivePlus&page=$currentPage');
    allJobsList = [];
    append = [];
    Dio dio = new Dio();
    Response response = await dio.get(
        '${BaseApi.domainName}api/job-seeker/search-jobs?api_token=$token$partTime$fullTime$fullPart$positions$position1$position2$position3$position4$position5$position6$noExperience$lessThanOne$oneThree$threeFive$fivePlus&page=$currentPage',
        options: Options(headers: {'Accept': 'application/json'}));

    if (response.statusCode == 200) {

      response.data['data']['jobs']['data'].forEach((e) {
        allJobsList.add(JobsSearchModel.fromJson(e));
      });
      allJobsList.forEach((element) {


        city = element.city.toString();
        if (city.contains('value')) {
          var cityList = [];
          try {
            var parsedJson;
            parsedJson = jsonDecode(city);
            String cityJson = "";
            cityList = parsedJson as List;

            for (int i = 0; i < cityList.length; i++) {
              cityJson = "${(i+1!=cityList.length&&i+1<city.length)?",":" "}"+cityList[i]['value'] + "" + cityJson;
              element.city = cityJson;
              citiesNewList.add("${cityList[i]['value']}");
              element.city = citiesNewList.toString();
            }
            element.city = cityJson;
          } catch (e) {}
        } else {
          element.city = city;
        }

      });
      isLoading = false;
      update();
    }
    return filteredList;
    return responseData;
  }

  showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
              // title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ListBody(
                      children: <Widget>[
                        Row(
                          children: [
                            Checkbox(
                              value: nursingCheckbox,
                              onChanged: (value) {
                                positions = "Certified Nursing Assistant";
                                nursingCheckbox = !nursingCheckbox;
                                update();
                              },
                            ),
                            SubText('Certified Nursing Assistance'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: practicalNurse,
                              onChanged: (value) {
                                practicalNurse = !practicalNurse;
                                update();
                                position1 = "Licensed Practical Nurse";
                              },
                            ),
                            SubText('Licensed Practical Nurse'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: directSupport,
                              onChanged: (value) {
                                directSupport = !directSupport;
                                position2 = "Direct Support Professional";
                                update();
                              },
                            ),
                            Text('Direct Support Professional'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: homeHealthAid,
                              onChanged: (value) {
                                homeHealthAid = !homeHealthAid;
                                position3 = "Home Health Aid";
                                update();
                              },
                            ),
                            Text('Home Health Aid'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: caregiver,
                              onChanged: (value) {
                                caregiver = !caregiver;
                                position4 = "Medical Technician";
                                update();
                              },
                            ),
                            Text('Caregiver'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: medicalTech,
                              onChanged: (value) {
                                medicalTech = !medicalTech;
                                position5 = "Medical Technician";
                                update();
                              },
                            ),
                            Text('Medical Technician'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: regNurse,
                              onChanged: (value) {
                                regNurse = !regNurse;
                                position6 = "Registered Nurse";

                                update();
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
                          onTap: () {},
                          title: 'SHOW',
                          btnColor: AppColors.green,
                          textColor: AppColors.white,
                        ),
                      ],
                    )),
              ));
        });
  }

   applyOnJob(BuildContext context,int id) async {

    Dio dio = new Dio();
    Response response = await dio.post(
        '${BaseApi.domainName}api/job-seeker/job-submit',
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: {"id": id});
    if (response.statusCode == 200) {

      showToast(msg: "Applied Successfully!");
      await getAllJobDataOnce();
    }
    isLoading = false;
    update();
  }
  applyJobPopUp(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content:
          Text(
            'Are you sure you are applying to the city and state you live in?',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),







          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  child: CustomButton(
                    onTap: () {
                      //    deleteNoticeData(accessToken, userId, context, id);
                      Get.back();

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => CreateContractTemplate()),
                      // );
                    },
                    title: "No",
                    textColor: AppColors.green,
                    btnColor: Colors.white,

                  ),
                ),

                Container(
                  width: 100,
                  child:  CustomButton(
                    onTap: () async{
                      //    deleteNoticeData(accessToken, userId, context, id);

CircularLoader().showAlert(context);
                      await applyOnJob(context, id);
                      Get.back();
                      Get.back();


                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => CreateContractTemplate()),
                      // );
                    },
                    title: "Yes",
                    textColor: Colors.white,
                    btnColor: AppColors.green,
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
          ],
        );
      },
    );
  }
}
