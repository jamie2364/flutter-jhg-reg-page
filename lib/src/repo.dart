import 'dart:io';
import 'package:dio/dio.dart';
import 'package:reg_page/reg_page.dart';

class ApiRepo {

  postRequest(String url, Map<String, dynamic> data ,{bool? isHeader}) async {
    try {

      Dio dio = Dio();

      final headers =  {
       // HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        //HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptEncodingHeader: "*"
        };

      final headers1 = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Basic cDJmY2M2NjIwZDMxNjg3NjQzY2VmYjBkMmFiNjliMmQ5OnNhNGYxZGZmMTZlMTYyNGRiNDUwM2I5YTQ0NjdjMzRlOA==',
      };

      Options options = Options(
          sendTimeout:const Duration(seconds: 60),
          receiveTimeout:const Duration(seconds: 60),
          receiveDataWhenStatusError: true,
          headers: isHeader == true ? headers1 : headers );

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

  getRequest(String url, Map<String, dynamic> data) async {

    final String? token = await LocalDB.getBearerToken;
    try {
      Dio dio = Dio();
      final headers =  {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.acceptEncodingHeader: "*"
      };
      Options options = Options(
          sendTimeout:const Duration(seconds: 60),
          receiveTimeout:const Duration(seconds: 60),
          receiveDataWhenStatusError: true,
          headers: headers );
      Response response = await dio.get(url, queryParameters: data,options: options);
      return response;
    } on DioException catch (exception) {
      return exception.response;
    }
  }


  getRequestWithoutHeader(String url, Map<String, dynamic> data) async {
    try {
      Dio dio = Dio();
      Options options = Options(
          sendTimeout:const Duration(seconds: 60),
          receiveTimeout:const Duration(seconds: 60),
          receiveDataWhenStatusError: true);
      Response response = await dio.get(url, queryParameters: data,options: options);
      return response;
    } on DioException catch (exception) {
      return exception.response;
    }
  }
}

