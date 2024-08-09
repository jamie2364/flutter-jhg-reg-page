import 'dart:developer';

import 'package:http/http.dart';

const nameTag = 'BaseService';
const reqTag = ' Request';
const resTag = ' Response';

requestLog(Uri uri, String tag, {dynamic body}) {
  log(
    'url==>: $uri  base: ${uri.authority}, api: ${uri.path} ,'
    'params: ${uri.queryParameters}  body: $body',
    name: tag + reqTag,
  );
}

responseLog(String api, Response res, String tag) {
  log(
    name: tag + resTag,
    '$tag=> "$api"  status ===>> ${res.statusCode}\n'
    'response  ===>>   ${res.body}',
  );
}

exceptionLog(Object message, {dynamic name}) {
  log('\n${message.toString()}\n', name: 'Exception $name');
}

debugLog(Object message, {String? name}) {
  log(message.toString(), name: 'Debug $name');
}
