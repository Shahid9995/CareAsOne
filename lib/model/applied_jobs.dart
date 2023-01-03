class AppliedJobs {
  int? id;
  int? jobId;
  int? applicantId;
  String? appliedOn;
  String? status;
  int? scheduled;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Job? jobs;

  AppliedJobs(
      {this.id,
      this.jobId,
      this.applicantId,
      this.appliedOn,
      this.status,
      this.scheduled,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.jobs});

  factory AppliedJobs.fromJson(Map<String, dynamic> json) => AppliedJobs(
      id: json["id"],
      jobId: json["job_id"],
      applicantId: json["applicant_id"],
      appliedOn: json["applied_on"],
      status: json["status"],
      scheduled: json["scheduled"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
      jobs: Job.fromJson(json["job"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "applicant_id": applicantId,
        "applied_on": appliedOn,
        "status": status,
        "scheduled": scheduled,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

class Job {
  Job({
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

  // List<KeywordClass> keywords;
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

  factory Job.fromJson(Map<String, dynamic> parsedJson) => Job(
        id: parsedJson["id"],
        title: parsedJson["title"],
        position: parsedJson["position"],
        location: parsedJson["location"],
        salary: parsedJson["salary"],
        experience: parsedJson["experience"],
        userId: parsedJson["user_id"],
        industryId: parsedJson["industry_id"],
        schedule: parsedJson["schedule"],
        keywords: parsedJson["keywords"],
        jobType: parsedJson["job_type"],
        description: parsedJson["description"],
        status: parsedJson["status"],
        postedDate: DateTime.parse(parsedJson["posted_date"]),
        createdAt: DateTime.parse(parsedJson["created_at"]),
        updatedAt: DateTime.parse(parsedJson["updated_at"]),
        city: parsedJson["city"],
        state: parsedJson["state"],
        zipCode: parsedJson["zip_code"],
        deletedAt: parsedJson["deleted_at"],
      );
}
