class Employees {
  Employees({
    this.id,
    this.name,
    this.jobTitle,
    this.email,
    this.salary,
    this.userId,
    this.employerId,
    this.companyId,
    this.resume,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.signatureRequestId,
    this.signatureId,
    this.deletedAt,
    this.lastName,
  });

  int? id;
  String? name;
  String? jobTitle;
  String? lastName;
  String? email;
  dynamic salary;
  int? userId;
  int? employerId;
  dynamic companyId;
  dynamic resume;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? signatureRequestId;
  String? signatureId;
  dynamic deletedAt;
  bool isSelected = false;

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        id: json["id"],
        name: json["name"],
        jobTitle: json["job_title"],
        email: json["email"],
        salary: json["salary"],
        userId: json["user_id"],
        employerId: json["employer_id"],
        companyId: json["company_id"],
        resume: json["resume"],
        status: json["status"],
        lastName: json["last_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        signatureRequestId: json["signature_request_id"],
        signatureId: json["signature_id"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "job_title": jobTitle,
        "email": email,
        "salary": salary,
        "user_id": userId,
        "employer_id": employerId,
        "company_id": companyId,
        "resume": resume,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "signature_request_id": signatureRequestId,
        "signature_id": signatureId,
        "deleted_at": deletedAt,
      };
}
