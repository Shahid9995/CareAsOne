// To parse this JSON data, do
//
//     final jobSeekerAvailability = jobSeekerAvailabilityFromJson(jsonString);

import 'dart:convert';

JobSeekerAvailability jobSeekerAvailabilityFromJson(String str) => JobSeekerAvailability.fromJson(json.decode(str));

String jobSeekerAvailabilityToJson(JobSeekerAvailability data) => json.encode(data.toJson());

class JobSeekerAvailability {
  JobSeekerAvailability({
    this.message,
    this.jobseekerDateRange,
    this.data,
  });

  String? message;
  String? jobseekerDateRange;
  List<Datum>? data;

  factory JobSeekerAvailability.fromJson(Map<String, dynamic> json) => JobSeekerAvailability(
    message: json["message"],
    jobseekerDateRange: json["availability_date"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
    this.startEnd,
    this.days,
  });

  int? id;
  String? startTime;
  String? endTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? startEnd;
  List<DayElement>? days;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    startEnd: json["start_end"],
    days: List<DayElement>.from(json["days"].map((x) => DayElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_time": startTime,
    "end_time": endTime,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "start_end": startEnd,
    "days": List<dynamic>.from(days!.map((x) => x.toJson())),
  };
}

class DayElement {
  DayElement({
    this.id,
    this.name,
    this.timeId,
    this.createdAt,
    this.updatedAt,
    this.jobSeekerDetails,
  });

  int? id;
  String? name;
  int? timeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<JobSeekerDetail>? jobSeekerDetails;

  factory DayElement.fromJson(Map<String, dynamic> json) => DayElement(
    id: json["id"],
    name: json["name"],
    timeId: json["time_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    jobSeekerDetails: List<JobSeekerDetail>.from(json["job_seeker_details"].map((x) => JobSeekerDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "time_id": timeId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "job_seeker_details": List<dynamic>.from(jobSeekerDetails!.map((x) => x.toJson())),
  };
}

class JobSeekerDetail {
  JobSeekerDetail({
    this.id,
    this.userId,
    this.yearOfExperience,
    this.companyDetails,
    this.references,
    this.highestQualification,
    this.educationDetails,
    this.availability,
    this.dateRange,
    this.coverLetter,
    this.resume,
    this.certifications,
    this.registry,
    this.aboutYourself,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.aboutYourselfUrl,
    this.resumeUrl,
    this.coverLetterUrl,
    this.pivot,
  });

  int? id;
  int? userId;
  String? yearOfExperience;
  List<CompanyDetail>? companyDetails;
  List<Reference>? references;
  String? highestQualification;
  EducationDetails? educationDetails;
  Availability? availability;
  dynamic dateRange;
  String? coverLetter;
  String? resume;
  dynamic certifications;
  dynamic registry;
  dynamic aboutYourself;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic aboutYourselfUrl;
  String? resumeUrl;
  String? coverLetterUrl;
  Pivot? pivot;

  factory JobSeekerDetail.fromJson(Map<String, dynamic> json) => JobSeekerDetail(
    id: json["id"],
    userId: json["user_id"],
    yearOfExperience: json["year_of_experience"],
    companyDetails: json["company_details"]==null?[]:List<CompanyDetail>.from(json["company_details"].map((x) => CompanyDetail.fromJson(x))),
    references: json["references"]==null?[]:List<Reference>.from(json["references"].map((x) => Reference.fromJson(x))),
    highestQualification: json["highest_qualification"],
    educationDetails: json["education_details"]==null?null:EducationDetails.fromJson(json["education_details"]),
    availability: json["availability"]==null?null:Availability.fromJson(json["availability"]),
    dateRange: json["date_range"],
    coverLetter: json["cover_letter"]==null?"":json["cover_letter"],
    resume: json["resume"]==null?"":json["resume"],
    certifications: json["certifications"]==null?"":json["certifications"],
    registry: json["registry"]==null?"":json["registry"],
    aboutYourself: json["about_yourself"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    aboutYourselfUrl: json["about_yourself_url"],
    resumeUrl: json["resume_url"],
    coverLetterUrl: json["cover_letter_url"],
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "year_of_experience": yearOfExperience,
    "company_details": List<dynamic>.from(companyDetails!.map((x) => x.toJson())),
    "references": List<dynamic>.from(references!.map((x) => x.toJson())),
    "highest_qualification": highestQualification,
    "education_details": educationDetails!.toJson(),
    "availability": availability!.toJson(),
    "date_range": dateRange,
    "cover_letter": coverLetter,
    "resume": resume,
    "certifications": certifications,
    "registry": registry,
    "about_yourself": aboutYourself,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "about_yourself_url": aboutYourselfUrl,
    "resume_url": resumeUrl,
    "cover_letter_url": coverLetterUrl,
    "pivot": pivot!.toJson(),
  };
}

class Availability {
  Availability({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  List<FridayElement>? monday;
  List<FridayElement>? tuesday;
  List<FridayElement>? wednesday;
  List<FridayElement>? thursday;
  List<FridayElement>? friday;
  List<FridayElement>? saturday;
  List<FridayElement>? sunday;

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    monday: List<FridayElement>.from(json["monday"].map((x) => FridayElement.fromJson(x))),
    tuesday: List<FridayElement>.from(json["tuesday"].map((x) => FridayElement.fromJson(x))),
    wednesday: List<FridayElement>.from(json["wednesday"].map((x) => FridayElement.fromJson(x))),
    thursday: List<FridayElement>.from(json["thursday"].map((x) => FridayElement.fromJson(x))),
    friday: List<FridayElement>.from(json["friday"].map((x) => FridayElement.fromJson(x))),
    saturday: List<FridayElement>.from(json["saturday"].map((x) => FridayElement.fromJson(x))),
    sunday: List<FridayElement>.from(json["sunday"].map((x) => FridayElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "monday": List<dynamic>.from(monday!.map((x) => x.toJson())),
    "tuesday": List<dynamic>.from(tuesday!.map((x) => x.toJson())),
    "wednesday": List<dynamic>.from(wednesday!.map((x) => x.toJson())),
    "thursday": List<dynamic>.from(thursday!.map((x) => x.toJson())),
    "friday": List<dynamic>.from(friday!.map((x) => x.toJson())),
    "saturday": List<dynamic>.from(saturday!.map((x) => x.toJson())),
    "sunday": List<dynamic>.from(sunday!.map((x) => x.toJson())),
  };
}

class FridayElement {
  FridayElement({
    this.from,
    this.fromTime,
    this.to,
    this.toTime,
  });

  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  factory FridayElement.fromJson(Map<String, dynamic> json) => FridayElement(
    from: json["from"],
    fromTime: json["from_time"],
    to: json["to"],
    toTime: json["to_time"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "from_time": fromTime,
    "to": to,
    "to_time": toTime,
  };
}

class CompanyDetail {
  CompanyDetail({
    this.designation,
    this.location,
    this.state,
    this.skills,
    this.workingSince,
    this.company,
  });

  String? designation;
  String? location;
  String? state;
  String? skills;
  DateTime? workingSince;
  String? company;

  factory CompanyDetail.fromJson(Map<String, dynamic> json) => CompanyDetail(
    designation: json["Designation"],
    location: json["Location"],
    state: json["State"],
    skills: json["Skills"],
    workingSince: DateTime.parse(json["WorkingSince"]),
    company: json["Company"],
  );

  Map<String, dynamic> toJson() => {
    "Designation": designation,
    "Location": location,
    "State": state,
    "Skills": skills,
    "WorkingSince": "${workingSince!.year.toString().padLeft(4, '0')}-${workingSince!.month.toString().padLeft(2, '0')}-${workingSince!.day.toString().padLeft(2, '0')}",
    "Company": company,
  };
}

class EducationDetails {
  EducationDetails({
    this.majorDegree,
    this.specialization,
    this.university,
    this.graduation,
  });

  String? majorDegree;
  String? specialization;
  String? university;
  DateTime? graduation;

  factory EducationDetails.fromJson(Map<String, dynamic> json) => EducationDetails(
    majorDegree: json["MajorDegree"],
    specialization: json["Specialization"],
    university: json["University"],
    graduation: DateTime.parse(json["graduation"]),
  );

  Map<String, dynamic> toJson() => {
    "MajorDegree": majorDegree,
    "Specialization": specialization,
    "University": university,
    "graduation": "${graduation!.year.toString().padLeft(4, '0')}-${graduation!.month.toString().padLeft(2, '0')}-${graduation!.day.toString().padLeft(2, '0')}",
  };
}

class Pivot {
  Pivot({
    this.dayId,
    this.jobSeekerDetailId,
  });

  int? dayId;
  int? jobSeekerDetailId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    dayId: json["day_id"],
    jobSeekerDetailId: json["job_seeker_detail_id"],
  );

  Map<String, dynamic> toJson() => {
    "day_id": dayId,
    "job_seeker_detail_id": jobSeekerDetailId,
  };
}

class Reference {
  Reference({
    this.referralPersonName,
    this.companyName,
    this.phoneNo,
    this.email,
  });

  String? referralPersonName;
  String? companyName;
  String? phoneNo;
  String? email;

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
    referralPersonName: json["ReferralPersonName"],
    companyName: json["CompanyName"],
    phoneNo: json["PhoneNo"],
    email: json["Email"],
  );

  Map<String, dynamic> toJson() => {
    "ReferralPersonName": referralPersonName,
    "CompanyName": companyName,
    "PhoneNo": phoneNo,
    "Email": email,
  };
}