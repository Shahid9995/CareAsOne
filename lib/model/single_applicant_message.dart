// To parse this JSON data, do
//
//     final employeeSingleMessageList = employeeSingleMessageListFromJson(jsonString);

import 'dart:convert';

EmployeeSingleMessageList employeeSingleMessageListFromJson(String str) => EmployeeSingleMessageList.fromJson(json.decode(str));

String employeeSingleMessageListToJson(EmployeeSingleMessageList data) => json.encode(data.toJson());

class EmployeeSingleMessageList {
  EmployeeSingleMessageList({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<SingleApplicantMessageList>? data;

  factory EmployeeSingleMessageList.fromJson(Map<String, dynamic> json) => EmployeeSingleMessageList(
    status: json["status"],
    message: json["message"],
    data:json["data"]==null?null: List<SingleApplicantMessageList>.from(json["data"].map((x) => SingleApplicantMessageList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleApplicantMessageList {
  SingleApplicantMessageList({
    this.id,
    this.companyId,
    this.jobApplicationId,
    this.from,
    this.to,
    this.message,
    this.seen,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.time,
    this.employerId,
    this.currentUserId,
    this.currentUserImage,
  });

  int? id;
  int? companyId;
  int? jobApplicationId;
  int? from;
  int? to;
  String? message;
  int? seen;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? time;
  dynamic employerId;
  dynamic currentUserId;
  String? currentUserImage;

  factory SingleApplicantMessageList.fromJson(Map<String, dynamic> json) => SingleApplicantMessageList(
    id: json["id"],
    companyId: json["company_id"],
    jobApplicationId: json["job_application_id"],
    from: json["from"],
    to: json["to"],
    message: json["message"],
    seen: json["seen"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    time: json["time"],
    employerId: json["EmployerID"],
    currentUserId: json["CurrentUserID"],
    currentUserImage: json["CurrentUserImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "job_application_id": jobApplicationId,
    "from": from,
    "to": to,
    "message": message,
    "seen": seen,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "time": time,
    "EmployerID": employerId,
    "CurrentUserID": currentUserId,
    "CurrentUserImage": currentUserImage,
  };
}