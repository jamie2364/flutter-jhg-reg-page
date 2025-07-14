import 'dart:developer';

import 'package:http/http.dart';

const nameTag = 'BASE_SERVICE';
const reqTag = ' REQUEST';
const resTag = ' RESPONSE';

// Request Log

/// [requestLog] is used to log debug messages.
/// It takes a [api], [res], and an optional [tag] parameter.
/// The [api] parameter is the API endpoint being called.
/// The [res] parameter is the response object returned from the API call.
/// The [tag] parameter is used to identify the source of the log message.
requestLog(Uri uri, String tag, {dynamic body}) {
  log('''⏳ ⏳ ⏳
URL==>: $uri  BASE: ${uri.authority}, API: ${uri.path} ,
PARAMS: ${uri.queryParameters}  
BODY: $body
⏳ ⏳ ⏳''', name: tag + reqTag);
}

/// [reqLog] is used to log debug messages.
/// It takes a [api], [res], and an optional [tag] parameter.
/// The [api] parameter is the API endpoint being called.
/// The [res] parameter is the response object returned from the API call.
/// The [tag] parameter is used to identify the source of the log message.
reqLog(Uri uri, String tag, {dynamic body}) => requestLog(uri, tag, body: body);

// Response Log

/// [responseLog] is used to log debug messages.
/// It takes a [api], [res], and an optional [tag] parameter.
/// The [api] parameter is the API endpoint being called.
/// The [res] parameter is the response object returned from the API call.
/// The [tag] parameter is used to identify the source of the log message.
responseLog(String api, Response res, String tag) {
  String emoji =
      res.statusCode == 200 || res.statusCode == 201 ? '✅ ✅ ✅' : '🚫 🚫 🚫';
  log(name: tag + resTag, '''$emoji
"$api"  STATUS ===>> ${res.statusCode}
RESPONSE  ===>>   ${res.body} 
$emoji''');
}

/// [resLog] is used to log debug messages.
/// It takes a [api], [res], and an optional [tag] parameter.
/// The [api] parameter is the API endpoint being called.
/// The [res] parameter is the response object returned from the API call.
/// The [tag] parameter is used to identify the source of the log message.
resLog(String api, Response res, String tag) => responseLog(api, res, tag);

// Exception Log

/// [exceptionLog] is used to log debug messages.
/// It takes a [e] and an optional [name] parameter.
/// The [name] parameter is used to identify the source of the log message.
exceptionLog(Object? e, {dynamic name}) {
  log('''🚫 🚫 🚫
${e.toString()}
🚫 🚫 🚫''', name: 'EXCEPTION $name');
}

/// [exLog] is used to log debug messages.
/// It takes a [e] and an optional [name] parameter.
/// The [name] parameter is used to identify the source of the log message.
exLog(Object? e, {dynamic name}) => exceptionLog(e, name: name);

// Debug Log

/// [debugLog] is used to log debug messages.
/// It takes a [message] and an optional [name] parameter.
/// The [name] parameter is used to identify the source of the log message.
debugLog(Object? message, {String? name}) =>
    log(message.toString(), name: name == null ? '' : 'DEBUG $name');

/// [dLog] is used to log debug messages.
/// It takes a [message] and an optional [name] parameter.
/// The [name] parameter is used to identify the source of the log message.
dLog(Object? message, {String? name}) => debugLog(message, name: name);

class Log {
  Log._();

  ///
  /// [request] Log for the base service request
  ///
  static void req(Uri uri, String tag, {dynamic body, dynamic headers}) =>
      _requestLog(uri, tag, body: body, headers: headers);

  ///
  /// [response] Log for the base service response
  ///
  static void res(String api, Response res, String tag) =>
      _responseLog(api, res, tag);

  ///
  /// [exception] Log for the exceptions and errors
  ///
  static void ex(Object e, {dynamic name}) => _exceptionLog(e, name: name);

  ///
  /// [debug] Log for the debug messages
  ///
  static void d(Object? message, {String? name}) => _dLog(message, name: name);

  static void success(Object? message, {String? name}) =>
      _successLog(message, name: name);

  ///
  /// [info] Log for the info messages
  ///
  static void i(Object? message, {String? name}) => log(
        '\n$message\nℹ️ ℹ️ ℹ️\n',
        name: 'ℹ️ ℹ️ ℹ️ $name ℹ️ ℹ️ ℹ️',
      );

  static void _requestLog(Uri uri, String tag,
          {dynamic body, dynamic headers}) =>
      log(
        '''⏳ ⏳ ⏳
URL==>: $uri  BASE: ${uri.authority}, API: ${uri.path} ,
PARAMS: ${uri.queryParameters}  
BODY: $body
HEADERS: $headers
⏳ ⏳ ⏳''',
        name: tag + reqTag,
      );

  static void _responseLog(String api, Response res, String tag) {
    String emoji =
        res.statusCode == 200 || res.statusCode == 201 ? '✅ ✅ ✅' : '🚫 🚫 🚫';
    log(
      name: tag + resTag,
      '''$emoji
"$api"  STATUS ===>> ${res.statusCode}
RESPONSE  ===>>   ${res.body} 
$emoji''',
    );
  }

  static void _exceptionLog(Object e, {dynamic name}) => log('''🚫 🚫 🚫
${e.toString()}
🚫 🚫 🚫''', name: 'EXCEPTION${name == null ? '' : ' $name'}');

  static void _dLog(Object? message, {String? name}) =>
      log(message.toString(), name: 'DEBUG${name == null ? '' : ' $name'}');

  static void _successLog(Object? message, {String? name}) => log(
        '\n$message\n✅✅✅\n',
        name: '✅✅✅ $name ✅✅✅',
      );
}
