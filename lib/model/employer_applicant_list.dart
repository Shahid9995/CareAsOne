// To parse this JSON data, do
//
//     final employerApplicantsMessageList = employerApplicantsMessageListFromJson(jsonString);

import 'dart:convert';

EmployerApplicantsMessageList employerApplicantsMessageListFromJson(String str) => EmployerApplicantsMessageList.fromJson(json.decode(str));

String employerApplicantsMessageListToJson(EmployerApplicantsMessageList data) => json.encode(data.toJson());

class EmployerApplicantsMessageList {
  EmployerApplicantsMessageList({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory EmployerApplicantsMessageList.fromJson(Map<String, dynamic> json) => EmployerApplicantsMessageList(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.employeeList,
    this.userJob,
  });

  List<EmployeeList>? employeeList;
  List<UserJob>? userJob;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    employeeList: List<EmployeeList>.from(json["employeeList"].map((x) => EmployeeList.fromJson(x))),
    userJob: List<UserJob>.from(json["userJob"].map((x) => UserJob.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "employeeList": List<dynamic>.from(employeeList!.map((x) => x.toJson())),
    "userJob": List<dynamic>.from(userJob!.map((x) => x.toJson())),
  };
}

class EmployeeList {
  EmployeeList({
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
    this.jobId,
    this.smsCount,
  });

  int? id;
  String? name;
  String? jobTitle;
  String? email;
  int? salary;
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
  String? lastName;
  int? jobId;
  int? smsCount;

  factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
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
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    signatureRequestId: json["signature_request_id"],
    signatureId: json["signature_id"],
    deletedAt: json["deleted_at"],
    lastName: json["last_name"],
    jobId: json["job_id"],
    smsCount: json["sms_count"],
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
    "last_name": lastName,
    "job_id": jobId,
    "sms_count": smsCount,
  };
}


class UserJob {
  UserJob({
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
    this.company,
    this.applications,
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
  Company? company;
  List<Application>? applications;

  factory UserJob.fromJson(Map<String, dynamic> json) => UserJob(
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
    company: Company.fromJson(json["company"]),
    applications: List<Application>.from(json["applications"].map((x) => Application.fromJson(x))),
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
    "posted_date": postedDate!.toIso8601String(),
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "city": city,
    "state": state,
    "zip_code": zipCode,
    "deleted_at": deletedAt,
    "company": company!.toJson(),
    "applications": List<dynamic>.from(applications!.map((x) => x.toJson())),
  };
}

class Application {
  Application({
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
    this.companyId,
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
  String? qualificationSurvey;
  int? smsCount;
  DateTime? msgCreatedAt;
  String? jobTitle;
  int? companyId;
  Applicant? applicant;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
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
    qualificationSurvey: json["qualification_survey"] == null ? null : json["qualification_survey"],
    smsCount: json["sms_count"],
    msgCreatedAt: json["msg_created_at"] == null ? null : DateTime.parse(json["msg_created_at"]),
    jobTitle: json["job_title"],
    companyId: json["company_id"],
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
    "qualification_survey": qualificationSurvey == null ? null : qualificationSurvey,
    "sms_count": smsCount,
    "msg_created_at": msgCreatedAt == null ? null : msgCreatedAt!.toIso8601String(),
    "job_title": jobTitle,
    "company_id": companyId,
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
  dynamic stripeId;
  dynamic cardBrand;
  dynamic cardLastFour;
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
  dynamic braintreeId;
  dynamic paypalEmail;
  String? apiToken;
  dynamic deviceToken;
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
    emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
    emailVerificationToken: json["email_verification_token"],
    passwordResetToken: json["password_reset_token"] == null ? null : json["password_reset_token"],
    userType: json["user_type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    stripeId: json["stripe_id"],
    cardBrand: json["card_brand"],
    cardLastFour: json["card_last_four"],
    trialEndsAt: json["trial_ends_at"],
    confirmed: json["confirmed"],
    allowedJobLimit: json["allowed_job_limit"],
    paymentMethod: json["payment_method"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    zipCode: json["zip_code"] == null ? null : json["zip_code"],
    addressOptional: json["address_optional"],
    deletedAt: json["deleted_at"],
    ipAddress:json["ip_address"],
    braintreeId: json["braintree_id"],
    paypalEmail: json["paypal_email"],
    apiToken: json["api_token"] == null ? null : json["api_token"],
    deviceToken: json["device_token"],
    socialId: json["social_id"],
    status: json["status"],
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
    "email_verified_at": emailVerifiedAt!.toIso8601String(),
    "email_verification_token": emailVerificationToken,
    "password_reset_token": passwordResetToken == null ? null : passwordResetToken,
    "user_type": userType,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "stripe_id": stripeId,
    "card_brand": cardBrand,
    "card_last_four": cardLastFour,
    "trial_ends_at": trialEndsAt,
    "confirmed": confirmed,
    "allowed_job_limit": allowedJobLimit,
    "payment_method": paymentMethod,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "zip_code": zipCode == null ? null : zipCode,
    "address_optional": addressOptional,
    "deleted_at": deletedAt,
    "ip_address": ipAddress,
    "braintree_id": braintreeId,
    "paypal_email": paypalEmail,
    "api_token": apiToken == null ? null : apiToken,
    "device_token": deviceToken,
    "social_id": socialId,
    "status": status,
    "profile_image_url": profileImageUrl,
    "full_name": fullName,
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
  dynamic logo;
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
    logo: json["logo"],
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
    "logo": logo,
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

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}