class ReceivedDocsModel {
  ReceivedDocsModel({
    this.id,
    this.uploadedby,
    this.name,
    this.type,
    this.extension,
    this.createdAt,
    this.updatedAt,
    this.documentUrl,
  });

  int? id;
  int? uploadedby;
  String? name;
  String? type;
  String? extension;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? documentUrl;
  bool isSelected = false;

  factory ReceivedDocsModel.fromJson(Map<String, dynamic> json) =>
      ReceivedDocsModel(
        id: json["id"],
        uploadedby: json["uploaded_by"],
        name: json["name"],
        type: json["type"],
        extension: json["extension"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        documentUrl: json["document_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uploaded_by": uploadedby,
        "name": name,
        "type": type,
        "extension": extension,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "document_url": documentUrl,
      };
}
