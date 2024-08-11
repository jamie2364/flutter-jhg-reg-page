// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  String userName;
  String? fName;
  String? lName;
  String? country;
  String? email;
  String password;
  String? token;
  String? profilePictureUrl;
  String? customerId;
  int? userId;
  User(
      {required this.userName,
      this.email,
      required this.password,
      this.token,
      this.userId,
      this.fName,
      this.lName,
      this.country,
      this.customerId,
      this.profilePictureUrl});

  Map<String, dynamic> toMapToRegister() {
    return <String, dynamic>{
      'username': userName,
      'email': email,
      'password': password,
      'first_name': fName,
      'last_name': lName,
      'country': country,
    };
  }

  factory User.fromMap(Map<String, dynamic> json) => User(
        token: json["token"],
        email: json["user_email"],
        fName: json["user_nicename"],
        lName: json["user_display_name"],
        customerId: json["customer_id"],
        password: json['password'],
        userName: json["user_login"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "user_email": email,
        "user_nicename": fName,
        "user_display_name": lName,
        "customer_id": customerId,
        "user_login": userName,
        "user_id": userId,
      };

  Map<String, dynamic> toMapToLogin() {
    return <String, dynamic>{
      'username': userName,
      'password': password,
    };
  }

  // factory User.fromMap(Map<String, dynamic> map) {
  //   return User(
  //     userName: map['user_login'] as String,
  //     email: map['user_email'] as String,
  //     password: '',
  //     userId: map['user_id'],
  //     token: map['token'] as String,
  //     fName: 'first_name',
  //     lName: 'last_name',
  //     country: 'country',
  //   );
  // }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(userName: $userName, fName: $fName, lName: $lName, country: $country, email: $email, password: $password, token: $token, userId: $userId)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => userName.hashCode ^ email.hashCode ^ password.hashCode;

  User copyWith({
    String? userName,
    String? fName,
    String? lName,
    String? country,
    String? email,
    String? password,
    String? token,
    String? profilePictureUrl,
    String? customerId,
    int? userId,
  }) {
    return User(
      userName: userName ?? this.userName,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      country: country ?? this.country,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
    );
  }
}
