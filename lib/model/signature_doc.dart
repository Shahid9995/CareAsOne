class SignatureDocModel {
  SignatureDocModel({
    this.id,
    this.templateName,
    this.file,
    this.templateId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? templateName;
  String? file;
  String? templateId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory SignatureDocModel.fromJson(Map<String, dynamic> json) =>
      SignatureDocModel(
        id: json["id"],
        templateName: json["template_name"],
        file: json["file"],
        templateId: json["template_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );
}
