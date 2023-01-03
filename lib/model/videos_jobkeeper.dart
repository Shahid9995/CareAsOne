class Videos {
  Videos({
    this.id,
    this.localName,
    this.originalName,
    this.folder,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? localName;
  String? originalName;
  String? folder;
  String? createdAt;
  String? updatedAt;
  bool isCheck = false;

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        id: json["id"],
        localName: json["local_name"],
        originalName: json["original_name"],
        folder: json["folder"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
