class Datam {
  Datam({
    this.userRecord,
    this.userEducationRecord,
    this.userEmploymentDetail,
  });

  UserRecord? userRecord;
  UserE? userEducationRecord;
  UserE? userEmploymentDetail;

  factory Datam.fromJson(Map<String, dynamic> json) => Datam(
        userRecord: UserRecord.fromJson(json["user_record"]),
        userEducationRecord: UserE.fromJson(json["user_education_record"]),
        userEmploymentDetail: UserE.fromJson(json["user_employment_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "user_record": userRecord!.toJson(),
        "user_education_record": userEducationRecord!.toJson(),
        "user_employment_detail": userEmploymentDetail!.toJson(),
      };
}

class UserE {
  UserE({
    this.id,
    this.userId,
    this.yearOfExperience,
    this.companyDetails,
    this.references,
    this.highestQualification,
    this.educationDetails,
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
  });

  int? id;
  int? userId;
  String? yearOfExperience;
  dynamic companyDetails;
  dynamic references;
  dynamic highestQualification;
  dynamic educationDetails;

  dynamic coverLetter;
  dynamic resume;
  dynamic certifications;
  dynamic registry;
  dynamic aboutYourself;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic aboutYourselfUrl;
  dynamic resumeUrl;
  dynamic coverLetterUrl;

  factory UserE.fromJson(Map<String, dynamic> json) => UserE(
        id: json["id"],
        userId: json["user_id"],
        yearOfExperience: json["year_of_experience"],
        companyDetails: json["company_details"],
        references: json["references"],
        highestQualification: json["highest_qualification"],
        educationDetails: json["education_details"],
        coverLetter: json["cover_letter"],
        resume: json["resume"],
        certifications: json["certifications"],
        registry: json["registry"],
        aboutYourself: json["about_yourself"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        aboutYourselfUrl: json["about_yourself_url"],
        resumeUrl: json["resume_url"],
        coverLetterUrl: json["cover_letter_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "year_of_experience": yearOfExperience,
        "company_details": companyDetails,
        "references": references,
        "highest_qualification": highestQualification,
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
      };
}

class UserRecord {
  UserRecord({
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
    this.profileImageUrl,
    this.fullName,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  dynamic dob;
  dynamic gender;
  String? phoneNumber;
  String? address;
  dynamic profileImage;
  dynamic emailVerifiedAt;
  String? emailVerificationToken;
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
  dynamic paymentMethod;
  dynamic city;
  dynamic state;
  dynamic zipCode;
  dynamic addressOptional;
  dynamic deletedAt;
  String? ipAddress;
  dynamic braintreeId;
  dynamic paypalEmail;
  String? apiToken;
  String? deviceToken;
  String? socialId;
  String? profileImageUrl;
  String? fullName;

  factory UserRecord.fromJson(Map<String, dynamic> json) => UserRecord(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        dob: json["dob"],
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        profileImage: json["profile_image"],
        emailVerifiedAt: json["email_verified_at"],
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
        paymentMethod: json["payment_method"],
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
        socialId: json["social_id"],
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
        "email_verified_at": emailVerifiedAt,
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
        "payment_method": paymentMethod,
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
        "social_id": socialId,
        "profile_image_url": profileImageUrl,
        "full_name": fullName,
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
