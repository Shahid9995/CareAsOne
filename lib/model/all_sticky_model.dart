// To parse this JSON data, do
//
//     final stickyNotesModel = stickyNotesModelFromJson(jsonString);

import 'dart:convert';

StickyNotesModel stickyNotesModelFromJson(String str) => StickyNotesModel.fromJson(json.decode(str));

String stickyNotesModelToJson(StickyNotesModel stickyNote) => json.encode(stickyNote.toJson());

class StickyNotesModel {
  StickyNotesModel({
    this.message,
    this.stickyNote,
  });

  String? message;
  List<StickyNotes>? stickyNote;

  factory StickyNotesModel.fromJson(Map<String, dynamic> json) => StickyNotesModel(
    message: json["message"],
    stickyNote: List<StickyNotes>.from(json["data"].map((x) => StickyNotes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(stickyNote!.map((x) => x.toJson())),
  };
}

class StickyNotes {
  StickyNotes({
    this.id,
    this.note,
    this.color,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.diffTime,
  });

  int? id;
  String? note;
  String? color;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? diffTime;

  factory StickyNotes.fromJson(Map<String, dynamic> json) => StickyNotes(
    id: json["id"],
    note: json["note"],
    color: json["color"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    diffTime: json["diff_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "note": note,
    "color": color,
    "user_id": userId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "diff_time": diffTime,
  };
}
