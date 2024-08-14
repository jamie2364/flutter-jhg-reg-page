// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Result<T> {
  dynamic code;
  String? message;
  String? token;
  int? userId;
  T? data;
  Result(
      {required this.code,
      required this.message,
      this.data,
      this.token,
      this.userId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'message': message,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      code: map['code'] as int,
      message: map['message'] as String,
      token: map['token'],
      userId: map['user_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Result.fromJson(String source) =>
      Result.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Result(code: $code, message: $message)';

  @override
  bool operator ==(covariant Result other) {
    if (identical(this, other)) return true;

    return other.code == code && other.message == message;
  }

  @override
  int get hashCode => code.hashCode ^ message.hashCode;

  Result<T> copyWith({
    int? code,
    String? message,
    T? data,
  }) {
    return Result<T>(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
