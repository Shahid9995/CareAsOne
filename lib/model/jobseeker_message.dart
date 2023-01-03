// To parse this JSON data, do
//
//     final allAppliedJobs = allAppliedJobsFromJson(jsonString);

import 'dart:convert';

AllAppliedJobs allAppliedJobsFromJson(String str) => AllAppliedJobs.fromJson(json.decode(str));

String allAppliedJobsToJson(AllAppliedJobs data) => json.encode(data.toJson());

class AllAppliedJobs {
  AllAppliedJobs({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory AllAppliedJobs.fromJson(Map<String, dynamic> json) => AllAppliedJobs(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.companyApplicants,
    this.userId,
  });

  List<CompanyApplicant>? companyApplicants;
  int? userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    companyApplicants: List<CompanyApplicant>.from(json["companyApplicants"].map((x) => CompanyApplicant.fromJson(x))),
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "companyApplicants": List<dynamic>.from(companyApplicants!.map((x) => x.toJson())),
    "user_id": userId,
  };
}

class CompanyApplicant {
  CompanyApplicant({
    this.id,
    this.jobId,
    this.applicantId,
    this.appliedOn,
    this.status,
    this.scheduled,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSurveyDone,
    this.qualificationSurvey,
    this.smsCount,
    this.msgCreatedAt,
    this.jobTitle,
    this.job,
    this.applicant,
  });

  int? id;
  int? jobId;
  int? applicantId;
  DateTime? appliedOn;
  String? status;
  int? scheduled;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? isSurveyDone;
  dynamic qualificationSurvey;
  int? smsCount;
  DateTime? msgCreatedAt;
  String? jobTitle;
  AllMessageJob? job;
  Applicant? applicant;

  factory CompanyApplicant.fromJson(Map<String, dynamic> json) => CompanyApplicant(
    id: json["id"],
    jobId: json["job_id"],
    applicantId: json["applicant_id"],
    appliedOn: DateTime.parse(json["applied_on"]),
    status: json["status"],
    scheduled: json["scheduled"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    isSurveyDone: json["is_survey_done"],
    qualificationSurvey: json["qualification_survey"],
    smsCount: json["sms_count"],
    msgCreatedAt: json["msg_created_at"] == null ? null : DateTime.parse(json["msg_created_at"]),
    jobTitle: json["job_title"],
    job: AllMessageJob.fromJson(json["job"]),
    applicant: Applicant.fromJson(json["applicant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId,
    "applicant_id": applicantId,
    "applied_on": appliedOn!.toIso8601String(),
    "status": status,
    "scheduled": scheduled,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "is_survey_done": isSurveyDone,
    "qualification_survey": qualificationSurvey,
    "sms_count": smsCount,
    "msg_created_at": msgCreatedAt == null ? null : msgCreatedAt!.toIso8601String(),
    "job_title": jobTitle,
    "job": job!.toJson(),
    "applicant": applicant!.toJson(),
  };
}

class Applicant {
  Applicant({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.address,
    this.profileImage,
    this.emailVerifiedAt,
    this.emailVerificationToken,
    this.passwordResetToken,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.stripeId,
    this.cardBrand,
    this.cardLastFour,
    this.trialEndsAt,
    this.confirmed,
    this.allowedJobLimit,
    this.paymentMethod,
    this.city,
    this.state,
    this.zipCode,
    this.addressOptional,
    this.deletedAt,
    this.ipAddress,
    this.braintreeId,
    this.paypalEmail,
    this.apiToken,
    this.deviceToken,
    this.socialId,
    this.status,
    this.profileImageUrl,
    this.fullName,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? dob;
  String? gender;
  String? phoneNumber;
  String? address;
  String? profileImage;
  DateTime? emailVerifiedAt;
  String? emailVerificationToken;
  String? passwordResetToken;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? stripeId;
  String? cardBrand;
  String? cardLastFour;
  dynamic trialEndsAt;
  int? confirmed;
  int? allowedJobLimit;
  dynamic paymentMethod;
  String? city;
  String? state;
  String? zipCode;
  dynamic addressOptional;
  dynamic deletedAt;
  String? ipAddress;
  String? braintreeId;
  dynamic paypalEmail;
  String? apiToken;
  String? deviceToken;
  String? socialId;
  String? status;
  String? profileImageUrl;
  String? fullName;

  factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"] == null ? null : json["gender"],
    phoneNumber: json["phone_number"],
    address: json["address"],
    profileImage: json["profile_image"] == null ? null : json["profile_image"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    emailVerificationToken: json["email_verification_token"] == null ? null : json["email_verification_token"],
    passwordResetToken: json["password_reset_token"] == null ? null : json["password_reset_token"],
    userType: json["user_type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    stripeId: json["stripe_id"] == null ? null : json["stripe_id"],
    cardBrand: json["card_brand"] == null ? null :json["card_brand"],
    cardLastFour: json["card_last_four"] == null ? null : json["card_last_four"],
    trialEndsAt: json["trial_ends_at"],
    confirmed: json["confirmed"],
    allowedJobLimit: json["allowed_job_limit"],
    paymentMethod: json["payment_method"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    zipCode: json["zip_code"] == null ? null : json["zip_code"],
    addressOptional: json["address_optional"],
    deletedAt: json["deleted_at"],
    ipAddress: json["ip_address"] == null ? null : json["ip_address"],
    braintreeId: json["braintree_id"] == null ? null : json["braintree_id"],
    paypalEmail: json["paypal_email"],
    apiToken: json["api_token"] == null ? null : json["api_token"],
    deviceToken: json["device_token"] == null ? null : json["device_token"],
    socialId: json["social_id"] == null ? null : json["social_id"],
    status: json["status"] == null ? null : json["status"],
    profileImageUrl: json["profile_image_url"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "dob": dob == null ? null : dob!.toIso8601String(),
    "gender": gender == null ? null : gender,
    "phone_number": phoneNumber,
    "address": address,
    "profile_image": profileImage == null ? null : profileImage,
    "email_verified_at": emailVerifiedAt == null ? null : emailVerifiedAt!.toIso8601String(),
    "email_verification_token": emailVerificationToken == null ? null : emailVerificationToken,
    "password_reset_token": passwordResetToken == null ? null : passwordResetToken,
    "user_type": userType,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "stripe_id": stripeId == null ? null : stripeId,
    "card_brand": cardBrand == null ? null : cardBrand,
    "card_last_four": cardLastFour == null ? null : cardLastFour,
    "trial_ends_at": trialEndsAt,
    "confirmed": confirmed,
    "allowed_job_limit": allowedJobLimit,
    "payment_method": paymentMethod,
    "city": city == null ? null : city,
    "state": state == null ? null :state,
    "zip_code": zipCode == null ? null : zipCode,
    "address_optional": addressOptional,
    "deleted_at": deletedAt,
    "ip_address": ipAddress == null ? null : ipAddress,
    "braintree_id": braintreeId == null ? null : braintreeId,
    "paypal_email": paypalEmail,
    "api_token": apiToken == null ? null : apiToken,
    "device_token": deviceToken == null ? null : deviceToken,
    "social_id": socialId == null ? null : socialId,
    "status": status == null ? null : status,
    "profile_image_url": profileImageUrl,
    "full_name": fullName,
  };
}

class AllMessageJob {
  AllMessageJob({
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
    this.user,
    this.company,
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
  Applicant? user;
  Company? company;

  factory AllMessageJob.fromJson(Map<String, dynamic> json) => AllMessageJob(
    id: json["id"],
    title: json["title"],
    position: json["position"],
    location: json["location"],
    salary: json["salary"] == null ? null : json["salary"],
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
    user: Applicant.fromJson(json["user"]),
    company: Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "position": position,
    "location": location,
    "salary": salary == null ? null : salary,
    "experience": experience,
    "user_id": userId,
    "industry_id": industryId,
    "schedule": schedule,
    "keywords": keywords,
    "job_type": jobType,
    "description": description,
    "status": status,
    "posted_date": postedDate!.toIso8601String(),
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "city": city,
    "state": state,
    "zip_code": zipCode,
    "deleted_at": deletedAt,
    "user": user!.toJson(),
    "company": company!.toJson(),
  };
}

class Company {
  Company({
    this.id,
    this.userId,
    this.companyTypeId,
    this.logo,
    this.name,
    this.address,
    this.phoneNumber,
    this.city,
    this.zipcode,
    this.state,
    this.country,
    this.contactPerson,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.presonLastName,
  });

  int? id;
  int? userId;
  dynamic companyTypeId;
  String? logo;
  String? name;
  dynamic address;
  String? phoneNumber;
  String? city;
  String? zipcode;
  String? state;
  String? country;
  String? contactPerson;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? presonLastName;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    userId: json["user_id"],
    companyTypeId: json["company_type_id"],
    logo: json["logo"] == null ? null : json["logo"],
    name: json["name"],
    address: json["address"],
    phoneNumber: json["phone_number"],
    city: json["city"],
    zipcode: json["zipcode"],
    state: json["state"],
    country: json["country"],
    contactPerson: json["contact_person"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    presonLastName: json["preson_last_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "company_type_id": companyTypeId,
    "logo": logo == null ? null : logo,
    "name": name,
    "address": address,
    "phone_number": phoneNumber,
    "city": city,
    "zipcode": zipcode,
    "state": state,
    "country": country,
    "contact_person": contactPerson,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "preson_last_name": presonLastName,
  };
}
