class ViewInterviewModel {
  ViewInterviewModel({
    this.id,
    this.jobId,
    this.applicantId,
    this.interviewDate,
    this.scheduledBy,
    this.meetingId,
    this.status,
    this.deletedAt,
    this.job,
    this.applicant,
  });

  int? id;
  int? jobId;
  int? applicantId;
  String? interviewDate;
  int? scheduledBy;
  String? meetingId;
  String? status;
  dynamic deletedAt;
  Job? job;
  Applicant? applicant;

  factory ViewInterviewModel.fromJson(Map<String, dynamic> json) =>
      ViewInterviewModel(
        id: json["id"],
        jobId: json["job_id"],
        applicantId: json["applicant_id"],
        interviewDate: json["interview_date"],
        scheduledBy: json["scheduled_by"],
        meetingId: json["meeting_id"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        job: Job.fromJson(json["job"]),
        applicant: Applicant.fromJson(json["applicant"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "applicant_id": applicantId,
        "interview_date": interviewDate,
        "scheduled_by": scheduledBy,
        "meeting_id": meetingId,
        "status": status,
        "deleted_at": deletedAt,
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
    this.profileImageUrl,
    this.fullName,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;
  String? gender;
  String? phoneNumber;
  String? address;
  String? profileImage;
  DateTime? emailVerifiedAt;
  dynamic emailVerificationToken;
  dynamic passwordResetToken;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic stripeId;
  dynamic cardBrand;
  dynamic cardLastFour;
  dynamic trialEndsAt;
  int? confirmed;
  int? allowedJobLimit;
  String? city;
  String? state;
  String? zipCode;
  dynamic addressOptional;
  dynamic deletedAt;
  dynamic ipAddress;
  dynamic braintreeId;
  dynamic paypalEmail;
  String? apiToken;
  dynamic deviceToken;
  String? profileImageUrl;
  String? fullName;

  factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        dob: json["dob"],
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        profileImage: json["profile_image"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        emailVerificationToken: json["email_verification_token"],
        passwordResetToken: json["password_reset_token"],
        userType: json["user_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        stripeId: json["stripe_id"],
        cardBrand: json["card_brand"],
        cardLastFour: json["card_last_four"],
        trialEndsAt: json["trial_ends_at"],
        confirmed: json["confirmed"],
        allowedJobLimit: json["allowed_job_limit"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        addressOptional: json["address_optional"],
        deletedAt: json["deleted_at"],
        ipAddress: json["ip_address"],
        braintreeId: json["braintree_id"],
        paypalEmail: json["paypal_email"],
        apiToken: json["api_token"],
        deviceToken: json["device_token"],
        profileImageUrl: json["profile_image_url"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "dob": dob,
        "gender": gender,
        "phone_number": phoneNumber,
        "address": address,
        "profile_image": profileImage,
        "email_verified_at": emailVerifiedAt!.toIso8601String(),
        "email_verification_token": emailVerificationToken,
        "password_reset_token": passwordResetToken,
        "user_type": userType,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "stripe_id": stripeId,
        "card_brand": cardBrand,
        "card_last_four": cardLastFour,
        "trial_ends_at": trialEndsAt,
        "confirmed": confirmed,
        "allowed_job_limit": allowedJobLimit,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "address_optional": addressOptional,
        "deleted_at": deletedAt,
        "ip_address": ipAddress,
        "braintree_id": braintreeId,
        "paypal_email": paypalEmail,
        "api_token": apiToken,
        "device_token": deviceToken,
        "profile_image_url": profileImageUrl,
        "full_name": fullName,
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
  Company? company;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
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
