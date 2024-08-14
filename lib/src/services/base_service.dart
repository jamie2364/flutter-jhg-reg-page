import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/utils/app_urls.dart';

class BaseService {
  final int _apiTimeOut = 25;

  @protected
  Future<dynamic> get(
    String api, {
    Map<String, String> headers = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    Map<String, dynamic>? queryParams,
    String? baseUrl,
  }) async {
    Uri? uri;
    try {
      final base = baseUrl ?? AppUrls.base.url;
      uri = Uri.parse(base + api).replace(queryParameters: queryParams);
      requestLog(uri, 'GET');
      var response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: _apiTimeOut));
      responseLog(api, response, 'GET');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          message: 'No Internet Connection', url: uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          message: 'Api Not Responded in Time', url: uri.toString());
    }
    // catch (e) {
    //   exceptionLog(e.toString(),name: 'GET on BASE');
    // }
  }

  @protected
  Future<dynamic> post(
    String api,
    payLoadObj, {
    Map<String, String> headers = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    Map<String, dynamic>? queryParams,
    String? baseUrl,
  }) async {
    var uri = Uri.parse(baseUrl ?? AppUrls.base.url + api)
        .replace(queryParameters: queryParams);

    requestLog(uri, 'POST', body: payLoadObj);
    try {
      var response = await http
          .post(
            uri,
            body: json.encode(payLoadObj),
            headers: headers,
          )
          .timeout(Duration(seconds: _apiTimeOut));
      if (!uri.authority.contains('app.bentonow.com')) {
        responseLog(api, response, 'POST');
      }
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          message: 'No Internet Connection', url: uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          message: 'Api Not Responded in Time', url: uri.toString());
    }
    // catch (e) {
    //   exceptionLog(e.toString(), name: 'POST on BASE');
    // }
  }

  dynamic _processResponse(response) async {
    switch (response.statusCode) {
      case 200:
        try {
          if (response.body.toString().isEmpty) return true;
          var responseJson = json.decode(response.body);
          return responseJson;
        } catch (e) {
          return 'success 200';
        }
      case 201:
        try {
          if (response.body.toString().isEmpty) return true;
          var responseJson = json.decode(response.body);
          return responseJson;
        } catch (e) {
          return 'success 201';
        }
      case 400:
        throw BadRequestException(
            message: response.body, url: response.request?.url.toString());
      case 401:
      case 403:
        String code;
        try {
          code = json.decode(response.body)['code'];
        } catch (e) {
          code = 'jwt_auth';
        }
        throw UnAutthorizedException(
            errorCode: code,
            message: response.body,
            url: response.request?.url.toString());
      case 404:
        throw BadRequestException(
            errorCode: json.decode(response.body)['code'],
            message: json.decode(response.body)[''],
            url: response.request?.url.toString());

      case 409:
      case 422:
        throw UnProcessableException(
            message: json.decode(response.body),
            url: response.request?.url.toString());
      case 500:
      default:
        throw FetchDataException(
            message: 'Error Occured with code: ${response.statusCode} ',
            url: response.request?.url.toString());
    }
  }
}

mixin BaseController {
  Future<void> handleError(error) async {
    hideLoading();
    print('error in base $error ${error.message}');
    if (error is BadRequestException) {
      showErrorToast(Constant.productIdsFailedMessage);
    } else if (error is FetchDataException) {
      showErrorToast(error.message);
    } else if (error is ApiNotRespondingException) {
      showErrorToast('Oops! It tooks too long to respond');
    } else if (error is UnAutthorizedException) {
      showErrorToast(Constant.emailPasswordInCorrect);
    } else {
      showErrorToast('${Constant.productIdsFailedMessage} $error');
    }
  }
}
