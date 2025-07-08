class AppException implements Exception {
  final String message;
  final String prefix;
  final String url;
  AppException(
      {required this.message, required this.prefix, required this.url});
}

class BadRequestException extends AppException {
  BadRequestException({String? message, String? url, this.errorCode})
      : super(message: message ?? '', prefix: "Bad Request", url: url!);
  String? errorCode;
  @override
  String toString() =>
      '🚨 🚨 🚨 \n message : $message \n prefix : $prefix \n url : $url \n errorCode : $errorCode \n 🚨 🚨 🚨';
}

class FetchDataException extends AppException {
  FetchDataException({String? message, String? url})
      : super(message: message!, prefix: "Unable to Process Data", url: url!);
  @override
  String toString() =>
      '🚨 🚨 🚨 \n message : $message \n prefix : $prefix \n url : $url \n 🚨 🚨 🚨';
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException({String? message, String? url})
      : super(message: message!, prefix: "Api Not Responding", url: url!);
  @override
  String toString() =>
      '🚨 🚨 🚨 \n message : $message \n prefix : $prefix \n url : $url \n 🚨 🚨 🚨';
}

class UnAutthorizedException extends AppException {
  UnAutthorizedException({String? message, String? url, this.errorCode})
      : super(message: message!, prefix: "UnAuthorized request", url: url!);
  String? errorCode;
  @override
  String toString() =>
      'UnAutthorizedException(🚨 🚨 🚨 \n message : $message \n prefix : $prefix \n url : $url \n 🚨 🚨 🚨)';
}

class UnProcessableException extends AppException {
  UnProcessableException({String? message, String? url})
      : super(message: message!, prefix: "UnProcessable request", url: url!);
  @override
  String toString() =>
      '🚨 🚨 🚨 \n message : $message \n prefix : $prefix \n url : $url \n 🚨 🚨 🚨';
}
