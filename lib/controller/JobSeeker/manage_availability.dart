import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/JobSeeker/home.dart';
import 'package:careAsOne/model/seeker_availability.dart';
import 'package:careAsOne/model/seeker_profile.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/view/availability/availability_model.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ManageAvailabilityController extends GetxController {
  JobSeekerAvailability jobSeekerAvailability = JobSeekerAvailability();
  AvailabilityData? availabilityData;
  List<Day>? monday;

  List<Day>? tuesday;

  List<Day>? wednesday;

  List<Day>? thursday;

  List<Day>? friday;

  List<Day>? saturday;

  List<Day>? sunday;
  List<int> preSelectedIds = [];

  List<CombinedAvailability> mondayNewList = [];
  List<CombinedAvailability> tuesdayNewList = [];
  List<CombinedAvailability> wednesdayNewList = [];
  List<CombinedAvailability> thursdayNewList = [];
  List<CombinedAvailability> fridayNewList = [];
  List<CombinedAvailability> saturdayNewList = [];
  List<CombinedAvailability> sundayNewList = [];
  List<String> mondayValueList = [
    '00:00 AM',
    '01:00 AM',
    '02:00 AM',
    '03:00 AM',
    '04:00 AM',
    '05:00 AM',
    '06:00 AM',
    '07:00 AM',
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '08:00 PM',
    '09:00 PM',
    '10:00 PM',
    '11:00 PM',
    '00:00 PM'
  ];

  //All DropDown Values

//Second Dropdown values
  String _selectedDate = '';
  String _dateCount = '';
  String range = '';
  String rangeCount = '';
  String? multiDateString;
  SeekerProfileModel? applicant;
  List<dynamic> multiDate = [];
  bool isLoading = true;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool mondayBool = false;
  bool tuesdayBool = false;
  bool wednesdayBool = false;
  bool thursdayBool = false;
  bool fridayBool = false;
  bool saturdayBool = false;
  bool sundayBool = false;
  DateRangePickerController controller = DateRangePickerController();
  GetStorage storage = new GetStorage();
  var token;

  @override
  void onInit() async {
    token = storage.read("authToken");
    print(token);
    final myProfile = Get.find<ProfileService>();
    monday = [];
    tuesday = [];
    wednesday = [];
    thursday = [];
    friday = [];
    saturday = [];
    sunday = [];
    // await getAvailability(token);
   applicant = await myProfile.getSeekerData(token);
    await getAvailabilityNew(token);


    super.onInit();
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    multiDate = [];

    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.

    if (args.value is PickerDateRange) {
      range = '${DateFormat('MM-dd-y').format(args.value.startDate)} -'
          // ignore: lines_longer_than_80_chars
          ' ${DateFormat('MM-dd-y').format(args.value.endDate ?? args.value.startDate)}';
      print(range);
      startDate = args.value.startDate;
      endDate = args.value.endDate;
      update();
    } else if (args.value is DateTime) {
      _selectedDate = args.value.toString().split(" ")[0];
      update();
    } else if (args.value is List<DateTime>) {
      multiDate = args.value;
      update();
      _dateCount = args.value.length.toString();
      multiDateString =
          args.value.join(",").replaceAll(RegExp(" 00:00:00.000"), '');
      print(multiDateString);
      update();
    } else {
      rangeCount = args.value.length.toString();
      update();
    }
  }

  addLeadAgent(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: SubText(
            'Select Date Range',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Center(
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 230,
                                      child: SfDateRangePicker(
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                        controller: controller,
                                        initialSelectedRanges: [
                                          PickerDateRange(startDate, endDate)
                                        ],
                                        onSelectionChanged: onSelectionChanged,
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.green)),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => CreateContractTemplate()),
                        // );
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  postAvailabilityNew() async {
    print(applicant!.id);
    var body = {
      "date_range": range,
      "job_seeker_id": applicant!.id,
      "availability": preSelectedIds
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        BaseApi.domainName + "api/job-seeker/set-availability-new",
        queryParameters: {"api_token": token},
        options: Options(headers: {"Accept": "application/json"}),
        data: body,
      );
      if (response.statusCode == 200) {
        Get.find<HomeController>().getAvailabilityNew(token);


        await getAvailabilityNew(token);
        showToast(msg: "Successfully Updated");
      } else {
        showToast(msg: "Something went wrong");
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
        print(e.error);
        showToast(msg: "Something went wrong");
      }
    }
  }

  Map<String, String> overallMap = {};

  void postAvailability() async {
    overallMap = {};
    update();
    overallMap.addAll({
      "start_date_range": DateFormat('MM-dd-y').format(startDate).toString(),
      "end_date_range": DateFormat('MM-dd-y').format(endDate).toString()
    });
    //Below Code Contain Mapping Solution For Availability
    if (mondayBool) {
      for (int i = 0; i < mondayNewList.length; i++) {
        overallMap['availability[monday][$i][from]'] =
            mondayNewList[i].fromTime.split(" ")[0];
        overallMap['availability[monday][$i][from_time]'] =
            mondayNewList[i].fromTime.split(" ")[1];
        overallMap['availability[monday][$i][to]'] =
            mondayNewList[i].toTime.split(" ")[0];
        overallMap['availability[monday][$i][to_time]'] =
            mondayNewList[i].toTime.split(" ")[1];
      }
    } else {
      overallMap['availability[monday][0][from]'] = "00:00";
      overallMap['availability[monday][0][from_time]'] = "AM";
      overallMap['availability[monday][0][to]'] = "00:00";
      overallMap['availability[monday][0][to_time]'] = "PM";
    }
    if (tuesdayBool) {
      for (int i = 0; i < tuesdayNewList.length; i++) {
        overallMap['availability[tuesday][$i][from]'] =
            tuesdayNewList[i].fromTime.split(" ")[0];
        overallMap['availability[tuesday][$i][from_time]'] =
            tuesdayNewList[i].fromTime.split(" ")[1];
        overallMap['availability[tuesday][$i][to]'] =
            tuesdayNewList[i].toTime.split(" ")[0];
        overallMap['availability[tuesday][$i][to_time]'] =
            tuesdayNewList[i].toTime.split(" ")[1];
      }
    } else {
      overallMap['availability[tuesday][0][from]'] = "00:00";
      overallMap['availability[tuesday][0][from_time]'] = "AM";
      overallMap['availability[tuesday][0][to]'] = "00:00";
      overallMap['availability[tuesday][0][to_time]'] = "PM";
    }
    if (wednesdayBool) {
      for (int i = 0; i < wednesdayNewList.length; i++) {
        overallMap['availability[wednesday][$i][from]'] =
            wednesdayNewList[i].fromTime.split(" ")[0];
        overallMap['availability[wednesday][$i][from_time]'] =
            wednesdayNewList[i].fromTime.split(" ")[1];
        overallMap['availability[wednesday][$i][to]'] =
            wednesdayNewList[i].toTime.split(" ")[0];
        overallMap['availability[wednesday][$i][to_time]'] =
            wednesdayNewList[i].toTime.split(" ")[1];
      }
    } else {
      overallMap['availability[wednesday][0][from]'] = "00:00";
      overallMap['availability[wednesday][0][from_time]'] = "AM";
      overallMap['availability[wednesday][0][to]'] = "00:00";
      overallMap['availability[wednesday][0][to_time]'] = "PM";
    }
    if (thursdayBool) {
      for (int i = 0; i < thursdayNewList.length; i++) {
        overallMap['availability[thursday][$i][from]'] =
            thursdayNewList[i].fromTime.split(" ")[0];
        overallMap['availability[thursday][$i][from_time]'] =
            thursdayNewList[i].fromTime.split(" ")[1];
        overallMap['availability[thursday][$i][to]'] =
            thursdayNewList[i].toTime.split(" ")[0];
        overallMap['availability[thursday][$i][to_time]'] =
            thursdayNewList[i].toTime.split(" ")[1];
      }
    } else {
      overallMap['availability[thursday][0][from]'] = "00:00";
      overallMap['availability[thursday][0][from_time]'] = "AM";
      overallMap['availability[thursday][0][to]'] = "00:00";
      overallMap['availability[thursday][0][to_time]'] = "PM";
    }
    if (fridayBool) {
      for (int i = 0; i < fridayNewList.length; i++) {
        overallMap['availability[friday][$i][from]'] =
            fridayNewList[i].fromTime.split(" ")[0];
        overallMap['availability[friday][$i][from_time]'] =
            fridayNewList[i].fromTime.split(" ")[1];
        overallMap['availability[friday][$i][to]'] =
            fridayNewList[i].toTime.split(" ")[0];
        overallMap['availability[friday][$i][to_time]'] =
            fridayNewList[i].toTime.split(" ")[1];
      }
    } else {
      overallMap['availability[friday][0][from]'] = "00:00";
      overallMap['availability[friday][0][from_time]'] = "AM";
      overallMap['availability[friday][0][to]'] = "00:00";
      overallMap['availability[friday][0][to_time]'] = "PM";
    }
    if (saturdayBool) {
      for (int i = 0; i < saturdayNewList.length; i++) {
        overallMap['availability[saturday][$i][from]'] =
            saturdayNewList[i].fromTime.split(" ")[0];
        overallMap['availability[saturday][$i][from_time]'] =
            saturdayNewList[i].fromTime.split(" ")[1];
        overallMap['availability[saturday][$i][to]'] =
            saturdayNewList[i].toTime.split(" ")[0];
        overallMap['availability[saturday][$i][to_time]'] =
            saturdayNewList[i].toTime.split(" ")[1];
      }
    } else {
      overallMap['availability[saturday][0][from]'] = "00:00";
      overallMap['availability[saturday][0][from_time]'] = "AM";
      overallMap['availability[saturday][0][to]'] = "00:00";
      overallMap['availability[saturday][0][to_time]'] = "PM";
    }
    if (sundayBool) {
      for (int i = 0; i < sundayNewList.length; i++) {
        overallMap['availability[sunday][$i][from]'] =
            sundayNewList[i].fromTime.split(" ")[0];
        overallMap['availability[sunday][$i][from_time]'] =
            sundayNewList[i].fromTime.split(" ")[1];
        overallMap['availability[sunday][$i][to]'] =
            sundayNewList[i].toTime.split(" ")[0];
        overallMap['availability[sunday][$i][to_time]'] =
            sundayNewList[i].toTime.split(" ")[1];
      }
    } else {
      overallMap['availability[sunday][0][from]'] = "00:00";
      overallMap['availability[sunday][0][from_time]'] = "AM";
      overallMap['availability[sunday][0][to]'] = "00:00";
      overallMap['availability[sunday][0][to_time]'] = "PM";
    }
    print(overallMap);

    //Above Code Contain Mapping Solution For Availability

    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${BaseApi.domainName}/api/job-seeker/set-availability?api_token=$token'));
    request.fields.addAll(overallMap);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      showToast(msg: "Saved successfully!");

      update();
    } else {}
  }

  getAvailabilityNew(token) async {
    isLoading = true;
    update();
    try {
      Dio dio = Dio();
      var response = await dio.get(
          BaseApi.domainName + "api/job-seeker/get-availabilities-new",
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseBody = response.data;
        jobSeekerAvailability = JobSeekerAvailability.fromJson(responseBody);
        jobSeekerAvailability.data!.forEach((element) {
          element.days!.forEach((element2) {
            if (element2.jobSeekerDetails!.isNotEmpty) {
              preSelectedIds.add(element2.id!);
            }
          });
        });
        if (jobSeekerAvailability.jobseekerDateRange == null) {
          range = DateFormat('MM-dd-y').format(DateTime.now()).toString() +
              " - " +
              DateFormat('MM-dd-y').format(DateTime.now()).toString();
          startDate = DateTime.now();
        } else {
          startDate=DateFormat("MM-dd-y").parse(jobSeekerAvailability.jobseekerDateRange.toString().split(" - ")[0]);
          endDate=DateFormat("MM-dd-y").parse(jobSeekerAvailability.jobseekerDateRange.toString().split(" - ")[1]);
          print(range);
          print(startDate);
          print(endDate);
          range = jobSeekerAvailability.jobseekerDateRange!;
        }
        print(preSelectedIds);
        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
      }
    } catch (e) {
      if (e is DioError) {
  /*      isLoading = false;
        update();*/
        print(e.response);
        print(e.message);
        print(e.error);
      }
    }
  }

  getAvailability(token) async {
    isLoading = true;
    update();

    Dio dio = new Dio();
    mondayNewList = [];
    tuesdayNewList = [];
    wednesdayNewList = [];
    thursdayNewList = [];
    fridayNewList = [];
    saturdayNewList = [];
    sundayNewList = [];
    update();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/job-seeker/availability',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"}));

      if (response.statusCode == 200) {
        if (response.data["data"] != null) {
          availabilityData = AvailabilityData.fromJson(response.data);

          if (availabilityData!.startDateRange == null) {
            range = DateFormat('MM-dd-y').format(DateTime.now()).toString() +
                " - " +
                DateFormat('MM-dd-y').format(DateTime.now()).toString();
            startDate = DateTime.now();
            endDate = DateTime.now();
          } else {
            startDate =
                DateFormat('MM-dd-y').parse(availabilityData!.startDateRange!);
            endDate =
                DateFormat('MM-dd-y').parse(availabilityData!.endDateRange!);
            range = DateFormat('MM-dd-y').format(startDate).toString() +
                " - " +
                DateFormat('MM-dd-y').format(endDate).toString();
          }
          if (response.data['data'] == null) {
            //  await getAvailability(token);
          } else {
            monday = availabilityData!.data!.monday;
            tuesday = availabilityData!.data!.tuesday;
            wednesday = availabilityData!.data!.wednesday;
            thursday = availabilityData!.data!.thursday;
            friday = availabilityData!.data!.friday;
            saturday = availabilityData!.data!.saturday;
            sunday = availabilityData!.data!.sunday;
          }
          for (int i = 0; i < monday!.length; i++) {
            mondayNewList.add(CombinedAvailability(
                fromTime: monday![i].from.toString() + " " + monday![i].fromTime.toString(),
                toTime: monday![i].to.toString() + " " + monday![i].toTime.toString()));
            if (monday![0].from == "00:00" && monday![0].to == "00:00") {
            } else {
              mondayBool = true;
            }
          }
          for (int i = 0; i < tuesday!.length; i++) {
            tuesdayNewList.add(CombinedAvailability(
                fromTime: tuesday![i].from.toString() + " " + tuesday![i].fromTime.toString(),
                toTime: tuesday![i].to.toString() + " " + tuesday![i].toTime.toString()));
            if (tuesday![0].from == "00:00" && tuesday![0].to == "00:00") {
            } else {
              tuesdayBool = true;
            }
          }
          for (int i = 0; i < wednesday!.length; i++) {
            wednesdayNewList.add(CombinedAvailability(
                fromTime: wednesday![i].from.toString() + " " + wednesday![i].fromTime.toString(),
                toTime: wednesday![i].to.toString() + " " + wednesday![i].toTime.toString()));
            if (wednesday![0].from == "00:00" && wednesday![0].to == "00:00") {
            } else {
              wednesdayBool = true;
            }
          }
          for (int i = 0; i < thursday!.length; i++) {
            thursdayNewList.add(CombinedAvailability(
                fromTime: thursday![i].from.toString() + " " + thursday![i].fromTime.toString(),
                toTime: thursday![i].to.toString() + " " + thursday![i].toTime.toString()));
            if (thursday![0].from == "00:00" && thursday![0].to == "00:00") {
            } else {
              thursdayBool = true;
            }
          }
          for (int i = 0; i < friday!.length; i++) {
            fridayNewList.add(CombinedAvailability(
                fromTime: friday![i].from.toString() + " " + friday![i].fromTime.toString(),
                toTime: friday![i].to.toString() + " " + friday![i].toTime.toString()));
            if (friday![0].from == "00:00" && friday![0].to == "00:00") {
            } else {
              fridayBool = true;
            }
          }
          for (int i = 0; i < saturday!.length; i++) {
            saturdayNewList.add(CombinedAvailability(
                fromTime: saturday![i].from.toString() + " " + saturday![i].fromTime.toString(),
                toTime: saturday![i].to.toString() + " " + saturday![i].toTime.toString()));
            if (saturday![0].from == "00:00" && saturday![0].to == "00:00") {
            } else {
              saturdayBool = true;
            }
          }
          for (int i = 0; i < sunday!.length; i++) {
            sundayNewList.add(CombinedAvailability(
                fromTime: sunday![i].from.toString() + " " + sunday![i].fromTime.toString(),
                toTime: sunday![i].to.toString() + " " + sunday![i].toTime.toString(),));
            if (sunday![0].from == "00:00" && sunday![0].to == "00:00") {
            } else {
              sundayBool = true;
            }
          }
        } else {
          mondayNewList.add(
              CombinedAvailability(fromTime: "00:00 AM", toTime: "00:00 PM"));
          tuesdayNewList.add(
              CombinedAvailability(fromTime: "00:00 AM", toTime: "00:00 PM"));
          wednesdayNewList.add(
              CombinedAvailability(fromTime: "00:00 AM", toTime: "00:00 PM"));
          thursdayNewList.add(
              CombinedAvailability(fromTime: "00:00 AM", toTime: "00:00 PM"));
          fridayNewList.add(
              CombinedAvailability(fromTime: "00:00 AM", toTime: "00:00 PM"));
          saturdayNewList.add(
              CombinedAvailability(fromTime: "00:00 AM", toTime: "00:00 PM"));
          sundayNewList.add(
              CombinedAvailability(fromTime: "00:00 AM", toTime: "00:00 PM"));
          range = DateFormat('MM-dd-y').format(DateTime.now()).toString() +
              " - " +
              DateFormat('MM-dd-y').format(DateTime.now()).toString();
          startDate = DateTime.now();
          endDate = DateTime.now();
        }
        isLoading = false;
        update();
      }
    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        showToast(msg: "ERROR");
      }
    }
  }
}

class CombinedAvailability {
  String fromTime;
  String toTime;

  CombinedAvailability({required this.fromTime,required this.toTime});
}
