// To parse this JSON data, do
//
//     final seekerSingleMessageList = seekerSingleMessageListFromJson(jsonString);

import 'dart:convert';

SeekerSingleMessageList seekerSingleMessageListFromJson(String str) => SeekerSingleMessageList.fromJson(json.decode(str));

String seekerSingleMessageListToJson(SeekerSingleMessageList data) => json.encode(data.toJson());

class SeekerSingleMessageList {
  SeekerSingleMessageList({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<MessageList>? data;

  factory SeekerSingleMessageList.fromJson(Map<String, dynamic> json) => SeekerSingleMessageList(
    status: json["status"],
    message: json["message"],
    data: json["data"]==null?null:List<MessageList>.from(json["data"].map((x) => MessageList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MessageList {
  MessageList({
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
  String? currentUserId;
  dynamic currentUserImage;

  factory MessageList.fromJson(Map<String, dynamic> json) => MessageList(
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
    currentUserId: json["CurrentUserID"] == null ? null : json["CurrentUserID"],
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
    "CurrentUserID": currentUserId == null ? null : currentUserId,
    "CurrentUserImage": currentUserImage,
  };
}


