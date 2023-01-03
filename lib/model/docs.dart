class DocsModel {
  DocsModel({
    this.id,
    this.name,
    this.type,
    this.extension,
    this.createdAt,
    this.updatedAt,
    this.documentUrl,
  });

  int? id;
  String? name;
  String? type;
  String? extension;
  String? createdAt;
  String? updatedAt;
  String? documentUrl;
  bool isSelected = false;

  factory DocsModel.fromJson(Map<String, dynamic> json) => DocsModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        extension: json["extension"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        documentUrl: json["document_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "extension": extension,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "document_url": documentUrl,
      };
}
