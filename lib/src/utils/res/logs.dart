import 'dart:developer';

import 'package:http/http.dart';

const nameTag = 'BaseService';
const reqTag = ' Request';
const resTag = ' Response';

requestLog(Uri uri, String tag, {dynamic body}) {
  log(
    '''⏳ ⏳ ⏳
url==>: $uri  base: ${uri.authority}, api: ${uri.path} ,
params: ${uri.queryParameters}  
body: $body
⏳ ⏳ ⏳''',
    name: tag + reqTag,
  );
}

responseLog(String api, Response res, String tag) {
  String emoji =
      res.statusCode == 200 || res.statusCode == 201 ? '✅ ✅ ✅' : '🚫 🚫 🚫';
  log(
    name: tag + resTag,
    '''$emoji
"$api"  status ===>> ${res.statusCode}
response  ===>>   ${res.body} 
$emoji''',
  );
}

exceptionLog(Object e, {dynamic name}) {
  log('''🚫 🚫 🚫
${e.toString()}
🚫 🚫 🚫''', name: 'Exception $name');
}

debugLog(Object message, {String? name}) {
  log(message.toString(), name: 'Debug $name');
}
