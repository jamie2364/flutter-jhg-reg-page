import 'dart:io';
import 'package:dio/dio.dart';

class ApiRepo {
  postRequest(String url, Map<String, dynamic> data) async {
    try {
      Dio dio = Dio();
     final headers =  {
       // HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        //HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptEncodingHeader: "*"
        };
      Options options = Options(
          sendTimeout:const Duration(seconds: 60),
          receiveTimeout:const Duration(seconds: 60),
          receiveDataWhenStatusError: true,
          headers: headers );

      Response response = await dio.post(
        options:options,
        url,
        data: data,
      );
      return response;
    } on DioException catch (exception) {
      return exception.response;

    }
  }

  // getRequest(String url, Map<String, dynamic> data) async {
  //   try {
  //     Dio dio = Dio();
  //
  //     // debugPrint(
  //     //     "Bearer Token =================================>>>>>>>>>>>>> \n $token");
  //     // final headers = {
  //     //   // 'Content-type': 'application/json',
  //     //   // 'Accept': 'application/json',
  //     //   'Authorization': 'Bearer $token'
  //     // };
  //     //dio.options.headers = headers;
  //
  //     Response response = await dio.get(url, queryParameters: data);
  //     return response;
  //   } on DioException catch (exception) {
  //     return exception;
  //   }
  // }
}

