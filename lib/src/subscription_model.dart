
import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) => SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) => json.encode(data.toJson());

class SubscriptionModel {
  String? softwareSuite;
  String? allAccessPass;
  String? allCoursePass;
  String? jhgRig;
  String? courseHub;

  SubscriptionModel({
    this.softwareSuite,
    this.allAccessPass,
    this.allCoursePass,
    this.jhgRig,
    this.courseHub,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
    softwareSuite: json["software_suite"],
    allAccessPass: json["all_access_pass"],
    allCoursePass: json["all_course_pass"],
    jhgRig: json["jhg-rig"],
    courseHub: json["course_hub"],
  );

  Map<String, dynamic> toJson() => {
    "software_suite": softwareSuite,
    "all_access_pass": allAccessPass,
    "all_course_pass": allCoursePass,
    "jhg-rig": jhgRig,
    "course_hub":courseHub
  };
}

