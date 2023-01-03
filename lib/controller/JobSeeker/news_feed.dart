import 'dart:convert';

import 'package:careAsOne/api/base_api.dart';
import 'package:careAsOne/common/common.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../model/news_feed/News_Feed_Model.dart';
import '../../model/news_feed/my_post.dart';
import '../../notification_key/notification_service_key.dart';
class NewsFeedController extends GetxController {
  var token;
  var userId;
  var one = Get.arguments;
  GetStorage storage = new GetStorage();
  NewsFeedModel AllData=NewsFeedModel();
  List<NewsFeedData> newsFeedList=[];
  MyPostModel myPostList=MyPostModel();
  List<MyPostData> myPostData=[];
  Comments commentRespons=Comments();
  Replies replyRespons=Replies();
  List<NewsFeedModel> responseData=[];
  bool isLoading=true;
  @override
  Future<void> onInit() async {
    isLoading=true;
    update();
    responseData = [];
    token = storage.read("authToken");
    userId = storage.read("userId");
    await getAllPost();
    isLoading=false;
    update();
    super.onInit();
  }
  Future<List<NewsFeedModel>> getAllPost() async {
    print("========NewsFeedController:getAllPost()======================");
    newsFeedList = [];
    AllData.data?.clear();
    // jobApplicantList = [];
    // responseData = [];
    // jobApplicantData = [];
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/news-feed/post/data?page=1&order=desc',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        AllData=NewsFeedModel.fromJson(response.data);
        newsFeedList=AllData.data!;
        print("========response:${AllData.data?.length}======================");
        print("========response:${AllData.links?.first}======================");
        // response.data['data']['companyApplicants'].forEach((e) {
        //   msgList.add(CompanyApplicant.fromJson(e));
        //   responseData = msgList;
        // });
        // responseData.forEach((element) {
        // });
        update();
      }
    } on DioError catch (e) {
      if(e.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
      isLoading=false;
        update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
  Future<List<NewsFeedModel>> likePost(id) async {
    print("=========likePost====================");
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/news-feed/post/like?post=$id',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        print("========response:$response======================");
        // response.data['data']['companyApplicants'].forEach((e) {
        //   msgList.add(CompanyApplicant.fromJson(e));
        //   responseData = msgList;
        // });
        // responseData.forEach((element) {
        // });
      }
    } on DioError catch (e) {
      if(e.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
      // isLoading=false;
      //   update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
  Future<List<NewsFeedModel>> likeComment(id) async {
    update();
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          '${BaseApi.domainName}api/news-feed/comment/like?comment=$id',
          queryParameters: {'api_token': token},
          options: Options(headers: {'Accept': 'application/json'}));
      if (response.statusCode == 200) {
        print("========response:$response======================");
        // response.data['data']['companyApplicants'].forEach((e) {
        //   msgList.add(CompanyApplicant.fromJson(e));
        //   responseData = msgList;
        // });
        // responseData.forEach((element) {
        // });
        update();
      }
    } on DioError catch (e) {
      if(e.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
      isLoading=false;
        update();
      }
      if (e.response!.statusCode == 500) {
        responseData = [];
      }
    }
    return responseData;
  }
  Future<List<NewsFeedModel>> createdPost(XFile? image,String comment,String fType) async {
    isLoading=true;
    update();
    var f =image;
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var request =await http.MultipartRequest("POST", Uri.parse('${BaseApi.domainName}api/news-feed/post/create'));
      request.fields["text"] =comment;
      request.fields["type"] = fType;
      if(f!=null){
        var pic = await http.MultipartFile.fromPath("file",f.path);
        request.files.add(pic);
      }
      request.headers.addAll(headers);
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        print("====response:${json.decode(value)}==================");
        if (json.decode(value)['status'].toString() == 'true') {
          await getAllPost();
         // await sendNotification();
        }
        isLoading = false;
        update();
      });
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
  Future<Comments> commentPost(id,String comment ) async {
    update();
    Dio dio = new Dio();
    try {
      print("=======commentPost===================");
      Response response = await dio.post('${BaseApi.domainName}api/news-feed/comment/create/$id',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"},), data: {
             'add_comment':comment});
      print("====response:$response===============");
      if (response.statusCode == 200) {
        commentRespons=Comments.fromJson(response.data["Comment"]);
        print("=======commentRespons:${commentRespons.userName}=================");
        // update();
      }
    } on DioError catch (e) {
      if(e.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
      isLoading=false;
           update();
      }
      if (e.response!.statusCode == 500) {
        // commentRespons;
      }
    }
    return commentRespons;
  }
  Future<Replies> replyPost(id,String reply ) async {
    update();
    Dio dio = new Dio();
    try {
      print("=======commentPost===================");
      Response response = await dio.post('${BaseApi.domainName}api/news-feed/reply/create/$id',
          queryParameters: {"api_token": token},
          options: Options(headers: {"Accept": "application/json"},), data: {
             'add_reply':reply});
      print("====response:$response===============");
      if (response.statusCode == 200) {
        replyRespons=Replies.fromJson(response.data["reply"]);
        print("=======replyRespons:${replyRespons.userName}=================");
        // update();
      }
    } on DioError catch (e) {
      if(e.type == DioErrorType.connectTimeout){
        showToast(msg: "Time out");
      }else {
      isLoading=false;
           update();
      }
      if (e.response!.statusCode == 500) {
        // commentRespons;
      }
    }
    return replyRespons;
  }
  sendNotification()async{
    var headers= <String, String>{
      'Authorization': 'key=$api_key',
      'Content-Type': 'application/json'
    };
    var body= jsonEncode(<String,dynamic>{
      "to" : "dWdw-0qHQ2ajZVcW4QZnlv:APA91bGpigvcBPtkpjQzzvXVtS7uJoP7lqQR0S9NfSRnBxXW55h-i5fqe_nw40fdNnc8qma-QTJK7XIibuH3AOKfpsOTwutJFGa88QDmweM0kbQf75E9vrCFxzJtH4NWJvKUPCC5R3UJ",
      "collapse_key" : "New Message",
      "priority": "high",
      "notification" : {
        "title": "New Message",
        "body" : "firstName sent you a message",
        "sound":"default"
      }
    });
    final response=await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headers,
        body: body);
    print("=====Notification Respons:$response=================================");
  }
}
