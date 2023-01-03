import 'dart:io';

import 'package:dio/dio.dart';
abstract class BaseApi {
  static Dio? client;
  static String domainName = "http://137.184.16.105/careasone/public/";
  // static String domainName = "https://careasone.com/";
  static fullUrl(url) {
    print(domainName + 'api/' + url);
    return '$domainName' + 'api/'+ url;
  }
  static Dio getDio() {
    if (client == null) {
      client = Dio();
      client!.options.headers['Accept'] = 'application/json';
    }
    return client!;
  }
  static Future<Response?> get({String? url, params}) async {
    Response response;
    try {
      response = await getDio().get(fullUrl(url), queryParameters: params);
    } on SocketException {
      return Response(statusCode: 410, statusMessage: 'No Internet',requestOptions: RequestOptions(path:domainName));
    }
    return response;
  }
  static Future<Response?> post(
      {required String url, required Map<String, dynamic> params, dynamic body}) async {
    Response response;
    try {
      print("post job");
      print(body);
      print(params);
      print("post job");
      print("uuuuuuuuuuuuuuuuuuuuuurrrrrrrrrllllllll " + fullUrl(url));
      // print(params);
      response = await getDio().post(
        fullUrl(url),
        queryParameters: params,
      );
    } on SocketException {
      return Response(statusCode: 410, statusMessage: 'No Internet', requestOptions:RequestOptions(path: domainName));
    } on DioError catch (e) {
      return e.response;
    }
    return response;
  }
  static Future<Response?> put({String? url, Map<String, dynamic>? params}) async {
    Response response;
    try {
      response = await getDio().post(fullUrl(url),
          queryParameters: params,
          options:
              Options(method: 'PUT', headers: {'Accept': 'application/json'}));
    } on SocketException {
      return Response(statusCode: 410, statusMessage: 'No Internet',requestOptions: RequestOptions(path: domainName));
    } on DioError catch (e) {
      return e.response;
    }
    return response;
  }
}
