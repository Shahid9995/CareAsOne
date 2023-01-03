
class AllApplicantsInterview {
  AllApplicantsInterview({
    this.id,
    this.title,
    this.position,
    this.location,
    this.salary,
    this.experience,
    this.userId,
    this.industryId,
    this.schedule,
    this.keywords,
    this.jobType,
    this.description,
    this.status,
    this.postedDate,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.state,
    this.zipCode,
    this.deletedAt,
    this.applicantionId,
    this.applicantId,
    this.firstName,
    this.lastName,
  });

  int? id;
  String? title;
  String? position;
  dynamic location;
  String? salary;
  String? experience;
  int? userId;
  dynamic industryId;
  String? schedule;
  String? keywords;
  String? jobType;
  String? description;
  String? status;
  DateTime? postedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? city;
  String? state;
  String? zipCode;
  dynamic deletedAt;
  int? applicantionId;
  int? applicantId;
  String? firstName;
  String? lastName;

  factory AllApplicantsInterview.fromJson(Map<String, dynamic> json) => AllApplicantsInterview(
    id: json["id"],
    title: json["title"],
    position: json["position"],
    location: json["location"],
    salary: json["salary"],
    experience: json["experience"],
    userId: json["user_id"],
    industryId: json["industry_id"],
    schedule: json["schedule"],
    keywords: json["keywords"],
    jobType: json["job_type"],
    description: json["description"],
    status: json["status"],
    postedDate: DateTime.parse(json["posted_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    city: json["city"],
    state: json["state"],
    zipCode: json["zip_code"],
    deletedAt: json["deleted_at"],
    applicantionId: json["applicantion_id"],
    applicantId: json["applicant_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "position": position,
    "location": location,
    "salary": salary,
    "experience": experience,
    "user_id": userId,
    "industry_id": industryId,
    "schedule": schedule,
    "keywords": keywords,
    "job_type": jobType,
    "description": description,
    "status": status,
    "posted_date": "${postedDate!.year.toString().padLeft(4, '0')}-${postedDate!.month.toString().padLeft(2, '0')}-${postedDate!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "city": city,
    "state": state,
    "zip_code": zipCode,
    "deleted_at": deletedAt,
    "applicantion_id": applicantionId,
    "applicant_id": applicantId,
    "first_name": firstName,
    "last_name": lastName,
  };
}
