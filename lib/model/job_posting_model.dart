class PositionModel {
  PositionModel({
    this.id,
    this.name,
    this.description,
    this.order,
    this.status,
    this.featured,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? name;
  String? description;
  String? order;
  String? status;
  String? featured;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory PositionModel.fromJson(Map<String, dynamic> json) => PositionModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        order: json["order"],
        status: json["status"],
        featured: json["featured"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "order": order,
        "status": status,
        "featured": featured,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

// Experience List
class ExperienceList {
  ExperienceList({
    this.id,
    this.name,
    this.description,
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? name;
  String? description;
  int? order;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory ExperienceList.fromJson(Map<String, dynamic> json) => ExperienceList(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        order: json["order"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "order": order,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
