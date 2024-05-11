// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginModel {
  String? code;
  String? message;
  Data? data;
  String? token;
  String? userEmail;
  String? userLogin;
  String? userNicename;
  String? userDisplayName;
  FreeTrial? freeTrial;
  String? customerId;
  int? userId;

  LoginModel({
    this.code,
    this.message,
    this.data,
    this.token,
    this.userEmail,
    this.userLogin,
    this.userNicename,
    this.userDisplayName,
    this.freeTrial,
    this.customerId,
    this.userId,
  });
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      token: json["token"],
      userEmail: json["user_email"],
      userLogin: json["user_login"],
      userNicename: json["user_nicename"],
      userDisplayName: json["user_display_name"],
      freeTrial: json["free_trial"] == null
          ? null
          : FreeTrial.fromJson(json["free_trial"]),
      customerId: json["customer_id"].runtimeType == String
          ? json["customer_id"]
          : json["customer_id"].toString(),
      userId: json["user_id"],
    );
  }
  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
        "token": token,
        "user_email": userEmail,
        "user_login": userLogin,
        "user_nicename": userNicename,
        "user_display_name": userDisplayName,
        "free_trial": freeTrial?.toJson(),
        "customer_id": customerId,
        "user_id": userId,
      };

  @override
  String toString() {
    return 'LoginModel(code: $code, message: $message, data: $data, token: $token, userEmail: $userEmail, userLogin: $userLogin, userNicename: $userNicename, userDisplayName: $userDisplayName, freeTrial: $freeTrial, customerId: $customerId, userId: $userId)';
  }
}

class Data {
  int? status;

  Data({
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class FreeTrial {
  DateTime? date;
  bool? isActive;

  FreeTrial({
    this.date,
    this.isActive,
  });

  factory FreeTrial.fromJson(Map<String, dynamic> json) => FreeTrial(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "is_active": isActive,
      };
}
