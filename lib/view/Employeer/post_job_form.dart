import 'dart:convert';

import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/controller/Employeer/post_job.dart';
import 'package:careAsOne/view/messages/messages.dart';
import 'package:careAsOne/view/widget/button.dart';
import 'package:careAsOne/view/widget/input.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

class JobPostPage extends StatefulWidget {
  @override
  State<JobPostPage> createState() => _JobPostPageState();
}

class _JobPostPageState extends State<JobPostPage> {
  var scaffoldJobKey = new GlobalKey<ScaffoldState>();

 var  jobKey = new GlobalKey<FormBuilderState>();
double _distanceToField=0.0;
  TextfieldTagsController? cityTagController;
  TextfieldTagsController? zipTagController;
  TextfieldTagsController? keyTagController;

  var data = Get.arguments;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    cityTagController!.dispose();
    zipTagController!.dispose();
    keyTagController!.dispose();
  }
  @override
  void initState() {
    super.initState();
    cityTagController = TextfieldTagsController();
    zipTagController = TextfieldTagsController();
    keyTagController = TextfieldTagsController();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostJobController>(
        init: PostJobController(),
        builder: (_) => Scaffold(
            key: scaffoldJobKey,
            backgroundColor: AppColors.bgGreen,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              automaticallyImplyLeading: false,
              title: Container(
                  height: 40,
                  width: 40,
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
                    //  if(_.scaffoldKey.currentState.isDrawerOpen){
                    Get.back();
                    // }else{
                    //   _.scaffoldKey.currentState.openDrawer();
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.exit_to_app_rounded,
                      color: AppColors.green,
                    ),
                  ),
                ),
              ],
            ),
            body: _.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.green)),
                  )
                : Container(
                    width: double.maxFinite,
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    margin: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: FormBuilder(
                        key: jobKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          size: 16,
                                        ),
                                        Text("Back"),
                                      ],
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                MainHeading(_.jobsModel != null
                                    ? 'Edit Form'
                                    : 'Post a Job'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _.jobsModel != null
                                ? SubText("Job Edit Form")
                                : SizedBox(),
                            SizedBox(height: 20.0),
                            // SubText("Company Settings Form",size: 20,color:AppColors.green),
                            // SizedBox(height: 20,),
                            DecoratedInputField(
                              name: 'Job Title',
                              controller: _.jobTitle,
                              text: "JOB TITLE*",
                              hintText: 'Job Title',
                              icon: Icons.email,
                              keyboard: TextInputType.text,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(40),
                                FormBuilderValidators.minLength(1),
                              ]),
                              onChange: (val) {
                                val = _.jobTitle.text;
                              },
                            ),
                            SizedBox(height: 12.7,),
                            SubText(
                              "Schedule*".toUpperCase(),
                              size: 12,
                            ),
                            Container(
                              height: 45,
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
                                elevation: 16,
                                isExpanded: true,
                                iconEnabledColor: Colors.grey,
                                iconDisabledColor: Colors.grey,
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (value) {
                                  if (value == "Full Time") {
                                    _.schedule = "full-time";
                                    _.update();
                                  } else if (value == "Part Time") {
                                    _.schedule = "part-time";
                                    _.update();
                                  } else if (value == "Full Time & Part Time") {
                                    _.schedule = "Full-and-Part-Time";
                                    _.update();
                                  }
                                },
                                hint: _.schedule == "" || _.schedule == null
                                    ? Text(
                                        "Select Schedule",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      )
                                    : Text(_.schedule,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 14)),
                                items: _.scheduleList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: AppColors.green, fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SubText(
                              "Job Position*".toUpperCase(),
                              size: 12,
                            ),
                            Container(
                              height: 45,
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
                                elevation: 16,
                                isExpanded: true,
                                iconEnabledColor: Colors.grey,
                                iconDisabledColor: Colors.grey,
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (value) {
                                  _.position = value!;
                                  _.update();
                                },
                                hint: _.position == "" || _.position == null
                                    ? Text(
                                        "Select Position",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      )
                                    : Text(_.position,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 14)),
                                items: _.positionModelList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: AppColors.green, fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              children: [
                                SubText(
                                  "Cities* ".toUpperCase(),
                                  size: 12,
                                ),
                                SubText(
                                  "(Add comma after adding City)",
                                  size: 12,
                                  color: AppColors.green,
                                ),
                              ],
                            ),
                            TextFieldTags(
                              textfieldTagsController: cityTagController,
                              initialTags: _.finalList,
                              textSeparators: _.citySeparator,
                              letterCase: LetterCase.normal,
                              validator: (String tag) {
                                if (cityTagController!.getTags!.contains(tag)) {
                                  return 'you already entered that';
                                }
                                return null;
                              },
                              inputfieldBuilder:
                                  (context, tec, fn, error, onChanged, onSubmitted) {
                                return ((context, sc, tags, onTagDelete) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top:3.0),
                                    child: TextField(
                                      cursorColor: AppColors.green,
                                      controller: tec,
                                      focusNode: fn,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 1.0,
                                          ),
                                        ),

                                        helperStyle: const TextStyle(
                                          color: Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        hintText: cityTagController!.hasTags ? '' : "Cities",

                                        errorText: error,
                                        prefixIconConstraints:
                                        BoxConstraints(maxWidth: _distanceToField * 0.74),
                                        prefixIcon: tags.isNotEmpty
                                            ? SingleChildScrollView(
                                          controller: sc,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                    color: Color.fromARGB(255, 74, 137, 92),
                                                  ),
                                                  margin: const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Text(
                                                          '$tag',
                                                          style: const TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        onTap: () {
                                                          print("$tag selected");
                                                        },
                                                      ),
                                                      const SizedBox(width: 4.0),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.cancel,
                                                          size: 14.0,
                                                          color: Color.fromARGB(
                                                              255, 233, 233, 233),
                                                        ),
                                                        onTap: () {
                                                          onTagDelete(tag);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList()),
                                        )
                                            : null,
                                      ),
                                      onChanged: onChanged,
                                      onSubmitted: onSubmitted,
                                    ),
                                  );
                                });
                              },
                            ),

                                /*  textFieldStyler: TextFieldStyler(
                                    textFieldFocusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    cursorColor: Colors.grey,
                                    hintText: 'City',
                                    helperText: '',
                                    helperStyle:
                                        TextStyle(height: 0, fontSize: 0),
                                    textFieldBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  initialTags: _.finalList,
                                  tagsStyler: TagsStyler(
                                      tagTextStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.white),
                                      tagDecoration: BoxDecoration(
                                        color: AppColors.green,
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      tagCancelIcon: Icon(Icons.cancel,
                                          size: 18.0, color: AppColors.white),
                                      tagPadding: const EdgeInsets.all(6.0)),
                                  onTag: (tag) {
                                    _.finalList.add(tag);

                                    _.isCityTag = false;
                                    _.update();
                                  },
                                  validator: (tag) {
                                    if (tag.length > 15) {
                                      return "hey that's too long";
                                    }
                                    return null;
                                  },
                                  onDelete: (tag) {
                                    _.finalList.remove(tag);
                                    _.update();
                                  },
                                  textSeparators: [","],
                                */

                            _.isCityTag
                                ? SubText(
                                    "Required",
                                    color: Colors.red,
                                  )
                                : SizedBox(),

                            SizedBox(height: 12.7,),
                            SubText(
                              "STATE",
                              size: 12,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              width: double.maxFinite,
                              height: 45.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey[400]!),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _.dropdownValue,
                                underline: SizedBox(),
                                items: <String>[
                                  'Alabama',
                                  'Alaska',
                                  'Arizona',
                                  'Arkansas',
                                  'California',
                                  'Canada',
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
                                  //  _.getJobDataInList(_.token, true);
                                },
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SubText(
                                  "Zip Codes* ".toUpperCase(),
                                  size: 12,
                                ),
                                SubText(
                                  "(Add space after adding Zip code)",
                                  size: 12,
                                  color: AppColors.green,
                                ),
                              ],
                            ),
                            TextFieldTags(
                              textfieldTagsController: zipTagController,
                              initialTags: _.finalZipList,
                              textSeparators: _.keywordSeparator,
                              letterCase: LetterCase.normal,
                              validator: (String tag) {
                                if (zipTagController!.getTags!.contains(tag)) {
                                  return 'you already entered that';
                                }
                                return null;
                              },
                              inputfieldBuilder:
                                  (context, tec, fn, error, onChanged, onSubmitted) {
                                return ((context, sc, tags, onTagDelete) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top:3.0),
                                    child: TextField(
                                      cursorColor: AppColors.green,
                                      controller: tec,
                                      focusNode: fn,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 1.0,
                                          ),
                                        ),

                                        helperStyle: const TextStyle(
                                          color: Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        hintText: zipTagController!.hasTags ? '' : "Zip code",

                                        errorText: error,
                                        prefixIconConstraints:
                                        BoxConstraints(maxWidth: _distanceToField * 0.74),
                                        prefixIcon: tags.isNotEmpty
                                            ? SingleChildScrollView(
                                          controller: sc,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                    color: Color.fromARGB(255, 74, 137, 92),
                                                  ),
                                                  margin: const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Text(
                                                          '$tag',
                                                          style: const TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        onTap: () {
                                                          print("$tag selected");
                                                        },
                                                      ),
                                                      const SizedBox(width: 4.0),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.cancel,
                                                          size: 14.0,
                                                          color: Color.fromARGB(
                                                              255, 233, 233, 233),
                                                        ),
                                                        onTap: () {
                                                          onTagDelete(tag);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList()),
                                        )
                                            : null,
                                      ),
                                      onChanged: onChanged,
                                      onSubmitted: onSubmitted,
                                    ),
                                  );
                                });
                              },
                            ),

                            _.isZipTag
                                ? SubText(
                                    "Required",
                                    color: Colors.red,
                                  )
                                : SizedBox(),
                            _.isZipTag
                                ?  SizedBox(
                              height: 5,
                            ):SizedBox(),
                            DecoratedInputField(
                              name: 'Salary',
                              text: "SALARY*",
                              controller: _.salary,
                              hintText: 'Salary',
                              icon: Icons.email,
                              keyboard: TextInputType.number,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric()
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 12.7,),
                            SubText(
                              "Minimum years of experience*".toUpperCase(),
                              size: 12,
                            ),
                            Container(
                              height: 45,
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
                                elevation: 16,
                                isExpanded: true,
                                iconEnabledColor: Colors.grey,
                                iconDisabledColor: Colors.grey,
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (value) {
                                  _.experience = value!;
                                  _.update();
                                },
                                hint: _.experience == "" || _.experience == null
                                    ? Text(
                                        "Select Experience",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      )
                                    : Text(_.experience,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 14)),
                                items: _.experienceModelList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: AppColors.green, fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              children: [
                                SubText(
                                  "keywords* ".toUpperCase(),
                                  size: 12,
                                ),
                                SubText(
                                  " (Add space after adding Keyword)",
                                  size: 12,
                                  color: AppColors.green,
                                ),
                              ],
                            ),
                            TextFieldTags(
                              textfieldTagsController: keyTagController,
                              initialTags: _.finalTagList,
                              textSeparators: _.keywordSeparator,
                              letterCase: LetterCase.normal,
                              validator: (String tag) {
                                if (keyTagController!.getTags!.contains(tag)) {
                                  return 'you already entered that';
                                }
                                return null;
                              },
                              inputfieldBuilder:
                                  (context, tec, fn, error, onChanged, onSubmitted) {
                                return ((context, sc, tags, onTagDelete) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top:3.0),
                                    child: TextField(
                                      cursorColor: AppColors.green,
                                      controller: tec,
                                      focusNode: fn,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 1.0,
                                          ),
                                        ),

                                        helperStyle: const TextStyle(
                                          color: Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        hintText: keyTagController!.hasTags ? '' : "keywords",
                                        errorText: error,
                                        prefixIconConstraints:
                                        BoxConstraints(maxWidth: _distanceToField * 0.74),
                                        prefixIcon: tags.isNotEmpty
                                            ? SingleChildScrollView(
                                          controller: sc,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                    color: Color.fromARGB(255, 74, 137, 92),
                                                  ),
                                                  margin: const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Text(
                                                          '$tag',
                                                          style: const TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        onTap: () {
                                                          print("$tag selected");
                                                        },
                                                      ),
                                                      const SizedBox(width: 4.0),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.cancel,
                                                          size: 14.0,
                                                          color: Color.fromARGB(
                                                              255, 233, 233, 233),
                                                        ),
                                                        onTap: () {
                                                          onTagDelete(tag);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList()),
                                        )
                                            : null,
                                      ),
                                      onChanged: onChanged,
                                      onSubmitted: onSubmitted,
                                    ),
                                  );
                                });
                              },
                            ),

                            _.isKeyTag
                                ? SubText(
                                    "Required",
                                    color: Colors.red,
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                            SubText(
                              "Status*".toUpperCase(),
                              size: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    value: 1,
                                    groupValue: _.status,
                                    title: Text(
                                      "Enable",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (int? val) {
                                      _.status = val!;
                                      _.update();
                                    },
                                    activeColor: AppColors.green,
                                    selected: true,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    value: 2,
                                    groupValue: _.status,
                                    title: Text("Disable",
                                        style: TextStyle(color: Colors.grey)),
                                    onChanged: (int? val) {
                                      _.status = val!;
                                      _.update();
                                    },
                                    activeColor: AppColors.green,
                                    selected: false,
                                  ),
                                )
                              ],
                            ),
                            SubText(
                              "Job Type*".toUpperCase(),
                              size: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    value: 1,
                                    groupValue: _.jobType,
                                    title: Text(
                                      "Hourly",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (int? val) {
                                      _.jobType = val!;
                                      _.update();
                                    },
                                    activeColor: AppColors.green,
                                    selected: true,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    value: 2,
                                    groupValue: _.jobType,
                                    title: Text("Fixed",
                                        style: TextStyle(color: Colors.grey)),
                                    onChanged: (int? val) {
                                      _.jobType = val!;
                                      _.update();
                                    },
                                    activeColor: AppColors.green,
                                    selected: false,
                                  ),
                                )
                              ],
                            ),
                            DecoratedInputField(
                              name: 'description',
                              text: "Description*",
                              hintText: 'Description Here ...',
                              minLines: 6,
                              maxLines: 8,
                              controller: _.description,

                              textCapitalization: TextCapitalization.sentences,
                              validations: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Description is empty',
                                ),
                              ]),
                              onChange: (val) {},
                            ),
                            SizedBox(height: 15.0),
                            CustomButton(
                              onTap: () {
                                _.finalList=cityTagController!.getTags!;
                        /*        if(_.finalList.isEmpty){
                                  _.isCityTag=true;
                                  _.update();
                                }else{
                                  _.isCityTag=false;
                                  _.update();
                                }*/
                                _.finalZipList=zipTagController!.getTags!;
                            /*    if(_.finalList.isEmpty){
                                  _.isZipTag=true;
                                  _.update();
                                }else{
                                  _.isZipTag=false;
                                  _.update();
                                }*/
                                _.finalTagList=keyTagController!.getTags!;
                              /*  if(_.finalList.isEmpty){
                                  _.isKeyTag=true;
                                  _.update();
                                }else{
                                  _.isKeyTag=false;
                                  _.update();
                                }*/
                                if (jobKey.currentState!.saveAndValidate()) {
                                  if (_.schedule == null || _.schedule == "") {
                                    showToast(msg: 'Please Select Schedule');
                                  } else if (_.position == null ||
                                      _.position == "") {
                                    showToast(
                                        msg: 'Please Select Job Position');
                                  } else if (_.experience == null ||
                                      _.experience == "") {
                                    showToast(
                                        msg:
                                            'Please Select Experience Required');
                                  } else if (_.dropdownValue == null ||
                                      _.dropdownValue == "") {
                                    showToast(msg: 'Please Select State');
                                  } else {
                                    var status = "";
                                    var jobType = "";
                                    if (_.status == 1) {
                                      status = "enable";
                                    } else {
                                      status = "disable";
                                    }
                                    if (_.jobType == 1) {
                                      jobType = "hourly";
                                    } else {
                                      jobType = "fixed";
                                    }
                                    if (_.jobsModel != null) {
                                      _.managedTags = [];
                                      if (_.finalTagList.length >= 1) {
                                        for (int i = 0;
                                            i < _.finalTagList.length;
                                            i++) {
                                          _.managedTags.add(
                                              {"value": _.finalTagList[i]});
                                        }
                                      }
                                      _.encodedCities = [];
                                      if (_.finalList.length >= 1) {
                                        for (int i = 0;
                                            i < _.finalList.length;
                                            i++) {
                                          _.encodedCities
                                              .add({"value": _.finalList[i]});
                                        }
                                      }

                                      _.managedZipCode = [];
                                      if (_.finalZipList.length >= 1) {
                                        for (int i = 0;
                                            i < _.finalZipList.length;
                                            i++) {
                                          _.managedZipCode.add(
                                              {"value": _.finalZipList[i]});
                                        }
                                      }

                                      if (_.finalTagList.length == 0) {
                                        _.isKeyTag = true;
                                        _.update();
                                      }
                                      if (_.finalZipList.length == 0) {
                                        _.isZipTag = true;
                                        _.update();
                                      }
                                      if (_.finalList.length == 0) {
                                        _.isCityTag = true;
                                        _.update();
                                      } else if (_.finalTagList.length >= 1 &&
                                          _.finalZipList.length >= 1 &&
                                          _.finalList.length >= 1) {
                                        _.postJobUpdate(context, params: {
                                          "id": _.jobsModel!.id!,
                                          "title": _.jobTitle.text,
                                          "position": _.position,
                                          "city": json.encode(_.encodedCities),
                                          "state": _.dropdownValue,
                                          "zip_code":
                                              json.encode(_.managedZipCode),
                                          "salary": _.salary.text,
                                          "experience": _.experience,
                                          "schedule": _.schedule,
                                          "job_type": jobType,
                                          "description": _.description.text,
                                          "status": status,
                                          "keywords": json.encode(_.managedTags)
                                        });
                                      }
                                    } else {
                                      _.managedTags = [];
                                      if (_.finalTagList.length >= 1) {
                                        for (int i = 0;
                                            i < _.finalTagList.length;
                                            i++) {
                                          _.managedTags.add(
                                              {"value": _.finalTagList[i]});
                                        }
                                      }
                                      _.encodedCities = [];
                                      if (_.finalList.length >= 1) {
                                        for (int i = 0;
                                            i < _.finalList.length;
                                            i++) {
                                          _.encodedCities
                                              .add({"value": _.finalList[i]});
                                        }
                                      }

                                      _.managedZipCode = [];
                                      if (_.finalZipList.length >= 1) {
                                        for (int i = 0;
                                            i < _.finalZipList.length;
                                            i++) {
                                          _.managedZipCode.add(
                                              {"value": _.finalZipList[i]});
                                        }
                                      }

                                      if (_.finalTagList.length == 0) {
                                        _.isKeyTag = true;
                                        _.update();
                                      }
                                      if (_.finalZipList.length == 0) {
                                        _.isZipTag = true;
                                        _.update();
                                      }
                                      if (_.finalList.length == 0) {
                                        _.isCityTag = true;
                                        _.update();
                                      } else if (_.finalTagList.length >= 1 &&
                                          _.finalZipList.length >= 1 &&
                                          _.finalList.length >= 1) {
                                        _.postJob(context, params: {
                                          "title": _.jobTitle.text,
                                          "position": _.position,
                                          "city": json.encode(_.encodedCities),
                                          "state": _.dropdownValue,
                                          "zip_code":
                                              json.encode(_.managedZipCode),
                                          "salary": _.salary.text,
                                          "experience": _.experience,
                                          "schedule": _.schedule,
                                          "job_type": jobType,
                                          "description": _.description.text,
                                          "status": status,
                                          "keywords": json.encode(_.managedTags)
                                        });
                                      }
                                    }
                                  }
                                }
                              },
                              title: 'SAVE',
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
