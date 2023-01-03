import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/controller/JobSeeker/search.dart';
import 'package:careAsOne/model/job_search_model.dart';
import 'package:careAsOne/view/job_seeker/jobs_detail.dart';
import 'package:careAsOne/view/search/filter.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/app_colors.dart';
import '../widget/button.dart';
import '../widget/card.dart';
import '../widget/text.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int totalPages = 0;
    List<JobsSearchModel> jobs = [];
    var token = GetStorage().read("authToken");
    final width = Get.width;
    return GetBuilder<SearchController>(
        init: SearchController(),
        builder: (_) => SingleChildScrollView(
                child: Container(
              width: width,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainHeading('Search Jobs'),
                  SizedBox(height: 10.0),
                  SizedBox(height: 10.0),
                  DecoratedInputField(
                    text: "",
                    hintText: "City",
                    name: "city",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 25,
                      ),
                      color: AppColors.green,
                      onPressed: () {
                        _.getJobDataInList(_.token, true);
                      },
                    ),
                    showSuffixIcon: true,
                    onChange: (val) {
                      _.cityNew = val!;
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    onTap: () {
                      Get.to(() => FilterPage());
                    },
                    title: 'FILTER',
                  ),
                  SizedBox(height: 12.5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.maxFinite,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.black.withOpacity(0.7)),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _.dropdownValue,
                      underline: SizedBox(),
                      items: <String>[
                        'Select State',
                        'Alabama',
                        'Alaska',
                        'Arizona',
                        'Arkansas',
                        'California',
                        'Colorado',
                        'Connecticut',
                        "Delaware",
                        'Florida',
                        'Georgia',
                        'Hawaii',
                        'Idaho',
                        'Illinois',
                        'Indiana',
                        'Lowa',
                        'Kansas',
                        'Kentucky',
                        'Louisiana',
                        'Maine',
                        'Maryland',
                        'Massachusetts',
                        'Michigan',
                        'Minnesota',
                        'Mississippi',
                        'Missouri',
                        'Montana',
                        'Nebraska',
                        'Nevada',
                        'New Hampshire',
                        'New Jersey',
                        'New Mexico',
                        'New York',
                        'North Carolina',
                        'North Dakota',
                        'Ohio',
                        'Oklahoma',
                        'Oregon',
                        'Pennsylvania',
                        'Rhode Island',
                        'South Carolina',
                        'South Dakota',
                        'Tennessee',
                        'Texas',
                        'Utah',
                        'Vermont',
                        'Virginia',
                        'Washington',
                        'West Virginia',
                        'Wisconsin',
                        'Wyoming'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SubText(value, size: 12.0),
                        );
                      }).toList(),
                      hint: Text("State"),
                      onChanged: (val) {
                        _.dropdownValue = val;
                        _.update();
                        _.getJobDataInList(_.token, true);
                      },
                    ),
                  ),
                  SizedBox(height: 30.0),
                  SizedBox(
                    height: 410,
                    child: SmartRefresher(
                        controller: _.refreshController,
                        enablePullUp: true,
                        onRefresh: () async {
                          await _.getJobDataInList(token, true);
                          _.refreshController.refreshCompleted();
                        },
                        onLoading: () async {
                          await _.getJobDataInList(token, false);
                          _.refreshController.loadComplete();
                        },
                        child: SingleChildScrollView(
                          child: _.responseData.length == 0
                              ? Center(
                                  child: Text(
                                    "No Jobs Found",
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 20),
                                  ),
                                )
                              : Column(
                                  children: List.generate(_.responseData.length,
                                      (index) {
                                    final jobListData = _.responseData[index];

                                    return PostCard(
                                        onTap: () {
                                          Get.to(() => JobsDetails(),
                                              arguments: [
                                                _.responseData[index].id,
                                                _.responseData[index].postedDate
                                                    .toString()
                                                    .split(" ")[0],
                                                _.responseData[index].applied ==
                                                        true
                                                    ? "Applied"
                                                    : "Apply Now"
                                              ]);
                                        },
                                        heading: jobListData.title,
                                        subHeading: _.responseData[index].user!
                                            .companyProfile!.name,
                                        location: jobListData.city.toString() +
                                            "|" +
                                            jobListData.state.toString(),
                                        description: _.parseHtmlString(jobListData.description.toString()),
                                        jobType: jobListData.schedule,
                                        experience: jobListData.experience,
                                        salary: "\$ ${jobListData.salary}",
                                        imageUrl: _.responseData[index].user!
                                                    .companyProfile!.logo ==
                                                null
                                            ? 'https://www.gravatar.com/avatar/159dca37d8cbb410c9075424bd6276b7?d=mm&s=250'
                                            : '${BaseApi.domainName}${_.responseData[index].user!.companyProfile!.logo}',
                                        titleButton:
                                            _.responseData[index].applied ==
                                                    true
                                                ? "Applied"
                                                : "Apply Now",
                                        date: DateTime.parse(_
                                                .responseData[index].createdAt!
                                                .toIso8601String())
                                            .toString()
                                            .split(" ")[0],
                                        onApply: () {
                                          if (_.responseData[index].applied ==
                                              true) {
                                            showToast(
                                                msg:
                                                    "You already applied to this job");
                                          } else
                                            _.applyJobPopUp(context,_.responseData[index].id!);
                                        });
                                  }),
                                ),
                        )),
                  )
                ],
              ),
            )));
  }

}
