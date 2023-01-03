import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:careAsOne/model/jobseeker_message.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../constants/app_colors.dart';
import '../../model/news_feed/News_Feed_Model.dart';
import '../../model/news_feed/my_post.dart';
class MyPostController extends GetxController {
  var token;
  var userId;
  GetStorage storage = new GetStorage();
  NewsFeedModel AllData = NewsFeedModel();
  List<NewsFeedData> newsFeedList = [];
  MyPostModel myPostList = MyPostModel();
  List<MyPostData> myPostData = [];
  List<NewsFeedModel> responseData = [];
  bool isLoading = true;
  List<AllMessageJob>? jobApplicantList;
  final myProfile = Get.find<ProfileService>();
  @override
  Future<void> onInit() async {
    isLoading = true;
    update();
    responseData = [];
    token = storage.read("authToken");
    userId = storage.read("userId");
    await getMyPost();
    isLoading = false;
    update();
    super.onInit();
  }
  Future<List<NewsFeedModel>> getMyPost() async {
    print("========NewsFeedController:getMyPost()======================");
    print("=======isLoading:$isLoading======================");
    myPostList.clear();
    myPostData = [];
    // jobApplicantList = [];
    // responseData = [];
    // jobApplicantData = [];
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/news-feed/mypost/data/$userId?per_page=&order=desc',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        myPostList = MyPostModel.fromJson(response.data);
        myPostData = myPostList.data!;
        // response.data['data']['companyApplicants'].forEach((e) {
        //   msgList.add(CompanyApplicant.fromJson(e));
        //   responseData = msgList;
        // });
        // responseData.forEach((element) {
        // });
        print("===myPostData:${myPostData.length}====================");
        update();
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        isLoading = false;
        update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
  Future<List<NewsFeedModel>> deleteMyPost(id) async {
    isLoading=true;
    print("========NewsFeedController:getMyPost()======================");
    print("=======isLoading:$isLoading======================");
    myPostList.clear();
    myPostData = [];
    // jobApplicantList = [];
    // responseData = [];
    // jobApplicantData = [];
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.delete(
          '${BaseApi.domainName}api/news-feed/post/delete/$id',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      print("====response:$response=====================");
      if (response.statusCode == 200) {
        await getMyPost();
        // response.data['data']['companyApplicants'].forEach((e) {
        //   msgList.add(CompanyApplicant.fromJson(e));
        //   responseData = msgList;
        // });
        // responseData.forEach((element) {
        // });
        print("=======update()=============");
        isLoading=false;
        update();
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        isLoading = false;
        update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
  Future<List<NewsFeedModel>> deleteMedia(id) async {
    isLoading=true;
    print("=======isLoading:$isLoading======================");
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.delete(
          '${BaseApi.domainName}api/news-feed/post/file/delete/$id',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      print("===deleteMedia=response:$response=====================");
      if (response.statusCode == 200) {
        // response.data['data']['companyApplicants'].forEach((e) {
        //   msgList.add(CompanyApplicant.fromJson(e));
        //   responseData = msgList;
        // });
        // responseData.forEach((element) {
        // });
        print("=======update()=============");
        isLoading=false;
        update();
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        isLoading = false;
        update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
  Future<List<NewsFeedModel>> updatPost(id, XFile? image,String comment,String fType) async {
    isLoading=true;
    update();
    var f =image;
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var request =await http.MultipartRequest("POST", Uri.parse('${BaseApi.domainName}api/news-feed/post/update/$id'));
      request.fields["comment"] =comment;
      request.fields["type"] = fType;
      print("=postID:$id===========");
      if(f!=null){
      var pic = await http.MultipartFile.fromPath("file",f.path);
      request.files.add(pic);
      }
      request.headers.addAll(headers);
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        print("====response:${json.decode(value)}==================");
        if (json.decode(value)['status'].toString() == 'true') {
          await getMyPost();
        }
        isLoading = false;
        update();
      });
      // Response response = await dio.post('${BaseApi.domainName}api/news-feed/post/update/$id',
      //         queryParameters: {"api_token": token},
      //         options: Options(
      //           headers: {"Accept": "application/json"},
      //         ),
      //         data: body);
      // if (response.statusCode == 200) {
      //   // response.data['data']['companyApplicants'].forEach((e) {
      //   //   msgList.add(CompanyApplicant.fromJson(e));
      //   //   responseData = msgList;
      //   // });
      //   // responseData.forEach((element) {
      //   // });
      //   update();
      // }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        showToast(msg: "Time out");
      } else {
        isLoading = false;
        update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
  Future showSelectionDialog(BuildContext context, String id) {
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
                child: ListBody(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Do you want to Delete Post?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: AppColors.green),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: Colors.grey,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            color: AppColors.green,
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              await deleteMyPost(id);
                              // await deleteDocument( idList);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
