class JobApplicantModel {
  JobApplicantModel({
    this.id,
    this.jobId,
    this.applicantId,
    this.appliedOn,
    this.status,
    this.scheduled,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.startDateRange,
    this.endDateRange,
    this.applicant,
  });

  int? id;
  int? jobId;
  int? applicantId;
  DateTime? appliedOn;
  String? status;
  String? startDateRange;
  String? endDateRange;

  int? scheduled;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Applicant? applicant;

  factory JobApplicantModel.fromJson(Map<String, dynamic> json) =>
      JobApplicantModel(
        id: json["id"],
        jobId: json["job_id"],
        applicantId: json["applicant_id"],
        appliedOn: DateTime.parse(json["applied_on"]),
        status: json["status"],
        scheduled: json["scheduled"],
        startDateRange:json["start_date_range"]==null?null:json["start_date_range"],
        endDateRange:json["end_date_range"]==null?null:json["end_date_range"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        applicant: Applicant.fromJson(json["applicant"]),
      );

// Map<String, dynamic> toJson() => {
//     "id": id,
//     "job_id": jobId,
//     "applicant_id": applicantId,
//     "applied_on": appliedOn.toIso8601String(),
//     "status": status,
//     "scheduled": scheduled,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "deleted_at": deletedAt,
//     "applicant": applicant.toJson(),
// };
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
    this.status,
    this.jobSeekerDetails,
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
  String? profileImageUrl;
  String? fullName;
  String? status;
  JobSeekerDetails? jobSeekerDetails;

  factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        dob: json["dob"]!=null?json["dob"]:'',
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
        // emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        emailVerificationToken: json["email_verification_token"] == null
            ? null
            : json["email_verification_token"],
        passwordResetToken: json["password_reset_token"],
        userType: json["user_type"],
        status: json["status"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
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
        ipAddress: json["ip_address"] == null ? null : json["ip_address"],
        braintreeId: json["braintree_id"],
        paypalEmail: json["paypal_email"],
        apiToken: json["api_token"] == null ? null : json["api_token"],
        deviceToken: json["device_token"],
        profileImageUrl: json["profile_image_url"],
        fullName: json["full_name"],
        jobSeekerDetails: JobSeekerDetails.fromJson(json["job_seeker_details"]),
      );

// Map<String, dynamic> toJson() => {
//     "id": id,
//     "first_name": firstName,
//     "last_name": lastName,
//     "email": email,
//     "dob": dob.toIso8601String(),
//     "gender": gender,
//     "phone_number": phoneNumber,
//     "address": address,
//     "profile_image": profileImage == null ? null : profileImage,
//     "email_verified_at": emailVerifiedAt.toIso8601String(),
//     "email_verification_token": emailVerificationToken == null ? null : emailVerificationToken,
//     "password_reset_token": passwordResetToken,
//     "user_type": userType,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "stripe_id": stripeId,
//     "card_brand": cardBrand,
//     "card_last_four": cardLastFour,
//     "trial_ends_at": trialEndsAt,
//     "confirmed": confirmed,
//     "allowed_job_limit": allowedJobLimit,
//     "city": city,
//     "state": state,
//     "zip_code": zipCode,
//     "address_optional": addressOptional,
//     "deleted_at": deletedAt,
//     "ip_address": ipAddress == null ? null : ipAddress,
//     "braintree_id": braintreeId,
//     "paypal_email": paypalEmail,
//     "api_token": apiToken == null ? null : apiToken,
//     "device_token": deviceToken,
//     "profile_image_url": profileImageUrl,
//     "full_name": fullName,
//     "job_seeker_details": jobSeekerDetails.toJson(),
// };
}

class JobSeekerDetails {
  JobSeekerDetails({
    this.id,
    this.userId,
    this.yearOfExperience,
    this.companyDetails,
    this.references,
    this.highestQualification,
    this.educationDetails,
    this.availability,
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
  List<CompanyDetail>? companyDetails;
  List<Reference>? references;
  String? highestQualification;
  EducationDetails? educationDetails;
AvailabilityData? availability;
  String? coverLetter;
  String? resume;
  String? certifications;
  String? registry;
  dynamic aboutYourself;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic aboutYourselfUrl;
  String? resumeUrl;
  String? coverLetterUrl;

  factory JobSeekerDetails.fromJson(Map<String, dynamic> json) =>
      JobSeekerDetails(
        id: json["id"],
        userId: json["user_id"],
        yearOfExperience: json["year_of_experience"],
        companyDetails: json["company_details"] != null
            ? List<CompanyDetail>.from(
                json["company_details"].map((x) => CompanyDetail.fromJson(x)))
            : null,
        references: json["references"] != null
            ? List<Reference>.from(
                json["references"].map((x) => Reference.fromJson(x)))
            : null,
        highestQualification: json["highest_qualification"] == null
            ? null
            : json["highest_qualification"],
        educationDetails: json["education_details"] == null
            ? null
            : EducationDetails.fromJson(json["education_details"]),
    availability: json['availability']==null?null:AvailabilityData.fromJson(json["availability"]),
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

// Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "year_of_experience": yearOfExperience,
//     "company_details": List<dynamic>.from(companyDetails.map((x) => x.toJson())),
//     "references": List<dynamic>.from(references.map((x) => x.toJson())),
//     "highest_qualification": highestQualification == null ? null : highestQualification,
//     "education_details": educationDetails == null ? null : educationDetails.toJson(),
//     "availability": availability.toJson(),
//     "cover_letter": coverLetter,
//     "resume": resume,
//     "certifications": certifications,
//     "registry": registry,
//     "about_yourself": aboutYourself,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "deleted_at": deletedAt,
//     "about_yourself_url": aboutYourselfUrl,
//     "resume_url": resumeUrl,
//     "cover_letter_url": coverLetterUrl,
// };
}

class AvailabilityData {
  AvailabilityData({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,

  });

  List<Day>? monday;
  List<Day>? tuesday;
  List<Day>? wednesday;
  List<Day>? thursday;
  List<Day>? friday;
  List<Day>? saturday;
  List<Day>? sunday;


  factory AvailabilityData.fromJson(Map<String, dynamic> json) =>
      AvailabilityData(
        monday: json["monday"]!=null?List<Day>.from(json["monday"].map((x) => Day.fromJson(x))):null,
        tuesday: json["tuesday"]!=null?List<Day>.from(json["tuesday"].map((x) => Day.fromJson(x))):null,
        wednesday: json ["wednesday"]!=null?
        List<Day>.from(json["wednesday"].map((x) => Day.fromJson(x))):null,
        thursday: json["thursday"]!=null?List<Day>.from(json["thursday"].map((x) => Day.fromJson(x))):null,
        friday: json["friday"]!=null? List<Day>.from(json["friday"].map((x) => Day.fromJson(x))):null,
        saturday:json["saturday"]!=null? List<Day>.from(json["saturday"].map((x) => Day.fromJson(x))):null,
        sunday:json["sunday"]!=null? List<Day>.from(json["sunday"].map((x) => Day.fromJson(x))):null,

      );


}

class Day {
  Day({
    this.from,
    this.fromTime,
    this.to,
    this.toTime,
  });

  String? from;
  Time? fromTime;
  String? to;
  Time? toTime;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    from: json["from"],
    fromTime: timeValues.map![json["from_time"]],
    to: json["to"],
    toTime: timeValues.map![json["to_time"]],
  );


}

enum Time { AM, PM }

final timeValues = EnumValues({"AM": Time.AM, "PM": Time.PM});

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

// Map<String, dynamic> toJson() => {
//     "from": from,
//     "from_time": fridayTimeValues.reverse[fromTime],
//     "to": to,
//     "to_time": fridayTimeValues.reverse[toTime],
// };
}

enum FridayTime { PM, AM }

final fridayTimeValues = EnumValues({"AM": FridayTime.AM, "PM": FridayTime.PM});

class CompanyDetail {
  CompanyDetail({
    this.designation,
    this.location,
    this.skills,
    this.workingSince,
    this.company,
    this.state
  });

  String? designation;
  String? location;
  String? skills;
  String? workingSince;
  String? company;
  String? state;

  factory CompanyDetail.fromJson(Map<String, dynamic> json) => CompanyDetail(
        designation: json["Designation"],
        location: json["Location"],
        skills: json["Skills"],
        workingSince: json["WorkingSince"],
        state:json["State"],
        company: json["Company"],
      );

  Map<String, dynamic> toJson() => {
        "Designation": designation,
        "Location": location,
        "Skills": skills,
    "State":state,
        "WorkingSince": workingSince,
        "Company": company,
      };
}

class EducationDetails {
  EducationDetails({
    this.token,
    this.method,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.dob,
    this.phoneNumber,
    this.city,
    this.state,
    this.zipCode,
    this.currentPassword,
    this.newPassword,
    this.passwordConfirm,
    this.yearOfExperience,
    this.jobTitle,
    this.companyName,
    this.date,
    this.skillset,
    this.txtName,
    this.txtCompany,
    this.txtPhoneNumber,
    this.txtEmail,
    this.majorDegree,
    this.specialization,
    this.university,
    this.graduation,
  });

  String? token;
  String? method;
  String? userId;
  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? dob;
  String? phoneNumber;
  String? city;
  String? state;
  String? zipCode;
  String? currentPassword;
  String? newPassword;
  String? passwordConfirm;
  String? yearOfExperience;
  String? jobTitle;
  String? companyName;
  String? date;
  String? skillset;
  String? txtName;
  String? txtCompany;
  String? txtPhoneNumber;
  String? txtEmail;
  String? majorDegree;
  String? specialization;
  String? university;
  String? graduation;

  factory EducationDetails.fromJson(Map<String, dynamic> json) =>
      EducationDetails(
        token: json["_token"],
        method: json["_method"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        email: json["email"],
        dob: json["dob"],
        phoneNumber: json["phone_number"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        currentPassword: json["current_password"],
        newPassword: json["new_password"],
        passwordConfirm: json["password_confirm"],
        yearOfExperience: json["year_of_experience"],
        jobTitle: json["job_title"],
        companyName: json["company_name"],
        date: json["date"],
        skillset: json["skillset"],
        txtName: json["txtName"],
        txtCompany: json["txtCompany"],
        txtPhoneNumber: json["txtPhoneNumber"],
        txtEmail: json["txtEmail"],
        majorDegree: json["MajorDegree"],
        specialization: json["Specialization"],
        university: json["University"],
        graduation: json["graduation"],
      );

  Map<String, dynamic> toJson() => {
        "_token": token,
        "_method": method,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "email": email,
        "dob": dob,
        "phone_number": phoneNumber,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "current_password": currentPassword,
        "new_password": newPassword,
        "password_confirm": passwordConfirm,
        "year_of_experience": yearOfExperience,
        "job_title": jobTitle,
        "company_name": companyName,
        "date": date,
        "skillset": skillset,
        "txtName": txtName,
        "txtCompany": txtCompany,
        "txtPhoneNumber": txtPhoneNumber,
        "txtEmail": txtEmail,
        "MajorDegree": majorDegree,
        "Specialization": specialization,
        "University": university,
        "graduation": graduation,
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
        referralPersonName: json["ReferralPersonName"] == null
            ? null
            : json["ReferralPersonName"],
        companyName: json["CompanyName"] == null ? null : json["CompanyName"],
        phoneNo: json["PhoneNo"] == null ? null : json["PhoneNo"],
        email: json["Email"] == null ? null : json["Email"],
      );

  Map<String, dynamic> toJson() => {
        "ReferralPersonName":
            referralPersonName == null ? null : referralPersonName,
        "CompanyName": companyName == null ? null : companyName,
        "PhoneNumber": phoneNo == null ? null : phoneNo,
        "Email": email == null ? null : email,
      };
}



// class JobApplicantModel {
//     JobApplicantModel({
//         this.id,
//         this.jobId,
//         this.applicantId,
//         this.appliedOn,
//         this.status,
//         this.scheduled,
//         this.createdAt,
//         this.updatedAt,
//         this.deletedAt,
//         this.applicant,
//     });

//     int id;
//     int jobId;
//     int applicantId;
//     DateTime appliedOn;
//     String status;
//     int scheduled;
//     DateTime createdAt;
//     DateTime updatedAt;
//     dynamic deletedAt;
//     Applicant applicant;

//     factory JobApplicantModel.fromJson(Map<String, dynamic> json) => JobApplicantModel(
//         id: json["id"],
//         jobId: json["job_id"],
//         applicantId: json["applicant_id"],
//         appliedOn: DateTime.parse(json["applied_on"]),
//         status: json["status"],
//         scheduled: json["scheduled"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//         applicant: Applicant.fromJson(json["applicant"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "job_id": jobId,
//         "applicant_id": applicantId,
//         "applied_on": appliedOn.toIso8601String(),
//         "status": status,
//         "scheduled": scheduled,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "deleted_at": deletedAt,
//         "applicant": applicant.toJson(),
//     };
// }

// class Applicant {
//     Applicant({
//         this.id,
//         this.firstName,
//         this.lastName,
//         this.email,
//         this.dob,
//         this.gender,
//         this.phoneNumber,
//         this.address,
//         this.profileImage,
//         this.emailVerifiedAt,
//         this.emailVerificationToken,
//         this.passwordResetToken,
//         this.userType,
//         this.createdAt,
//         this.updatedAt,
//         this.stripeId,
//         this.cardBrand,
//         this.cardLastFour,
//         this.trialEndsAt,
//         this.confirmed,
//         this.allowedJobLimit,
//         this.city,
//         this.state,
//         this.zipCode,
//         this.addressOptional,
//         this.deletedAt,
//         this.ipAddress,
//         this.braintreeId,
//         this.paypalEmail,
//         this.apiToken,
//         this.deviceToken,
//         this.profileImageUrl,
//         this.fullName,
//         this.jobSeekerDetails,
//     });

//     int id;
//     String firstName;
//     String lastName;
//     String email;
//     DateTime dob;
//     String gender;
//     String phoneNumber;
//     String address;
//     dynamic profileImage;
//     DateTime emailVerifiedAt;
//     String emailVerificationToken;
//     dynamic passwordResetToken;
//     String userType;
//     DateTime createdAt;
//     DateTime updatedAt;
//     dynamic stripeId;
//     dynamic cardBrand;
//     dynamic cardLastFour;
//     dynamic trialEndsAt;
//     int confirmed;
//     int allowedJobLimit;
//     String city;
//     String state;
//     String zipCode;
//     String addressOptional;
//     dynamic deletedAt;
//     dynamic ipAddress;
//     dynamic braintreeId;
//     dynamic paypalEmail;
//     dynamic apiToken;
//     dynamic deviceToken;
//     String profileImageUrl;
//     String fullName;
//     JobSeekerDetails jobSeekerDetails;

//     factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
//         id: json["id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         email: json["email"],
//         dob: DateTime.parse(json["dob"]),
//         gender: json["gender"],
//         phoneNumber: json["phone_number"],
//         address: json["address"],
//         profileImage: json["profile_image"],
//         emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
//         emailVerificationToken: json["email_verification_token"],
//         passwordResetToken: json["password_reset_token"],
//         userType: json["user_type"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         stripeId: json["stripe_id"],
//         cardBrand: json["card_brand"],
//         cardLastFour: json["card_last_four"],
//         trialEndsAt: json["trial_ends_at"],
//         confirmed: json["confirmed"],
//         allowedJobLimit: json["allowed_job_limit"],
//         city: json["city"] == null ? null : json["city"],
//         state: json["state"] == null ? null : json["state"],
//         zipCode: json["zip_code"] == null ? null : json["zip_code"],
//         addressOptional: json["address_optional"] == null ? null : json["address_optional"],
//         deletedAt: json["deleted_at"],
//         ipAddress: json["ip_address"],
//         braintreeId: json["braintree_id"],
//         paypalEmail: json["paypal_email"],
//         apiToken: json["api_token"],
//         deviceToken: json["device_token"],
//         profileImageUrl: json["profile_image_url"],
//         fullName: json["full_name"],
//         jobSeekerDetails: JobSeekerDetails.fromJson(json["job_seeker_details"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "first_name": firstName,
//         "last_name": lastName,
//         "email": email,
//         "dob": dob.toIso8601String(),
//         "gender": gender,
//         "phone_number": phoneNumber,
//         "address": address,
//         "profile_image": profileImage,
//         "email_verified_at": emailVerifiedAt.toIso8601String(),
//         "email_verification_token": emailVerificationToken,
//         "password_reset_token": passwordResetToken,
//         "user_type": userType,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "stripe_id": stripeId,
//         "card_brand": cardBrand,
//         "card_last_four": cardLastFour,
//         "trial_ends_at": trialEndsAt,
//         "confirmed": confirmed,
//         "allowed_job_limit": allowedJobLimit,
//         "city": city == null ? null : city,
//         "state": state == null ? null : state,
//         "zip_code": zipCode == null ? null : zipCode,
//         "address_optional": addressOptional == null ? null : addressOptional,
//         "deleted_at": deletedAt,
//         "ip_address": ipAddress,
//         "braintree_id": braintreeId,
//         "paypal_email": paypalEmail,
//         "api_token": apiToken,
//         "device_token": deviceToken,
//         "profile_image_url": profileImageUrl,
//         "full_name": fullName,
//         "job_seeker_details": jobSeekerDetails.toJson(),
//     };
// }

// class JobSeekerDetails {
//     JobSeekerDetails({
//         this.id,
//         this.userId,
//         this.yearOfExperience,
//         this.companyDetails,
//         this.references,
//         this.highestQualification,
//         this.educationDetails,
//         this.availability,
//         this.coverLetter,
//         this.resume,
//         this.certifications,
//         this.registry,
//         this.aboutYourself,
//         this.createdAt,
//         this.updatedAt,
//         this.deletedAt,
//         this.aboutYourselfUrl,
//         this.resumeUrl,
//         this.coverLetterUrl,
//     });

//     int id;
//     int userId;
//     String yearOfExperience;
//     List<CompanyDetail> companyDetails;
//     List<Reference> references;
//     String highestQualification;
//     EducationDetails educationDetails;
//     Availability availability;
//     dynamic coverLetter;
//     String resume;
//     String certifications;
//     dynamic registry;
//     dynamic aboutYourself;
//     DateTime createdAt;
//     DateTime updatedAt;
//     dynamic deletedAt;
//     dynamic aboutYourselfUrl;
//     String resumeUrl;
//     dynamic coverLetterUrl;

//     factory JobSeekerDetails.fromJson(Map<String, dynamic> json) => JobSeekerDetails(
//         id: json["id"],
//         userId: json["user_id"],
//         yearOfExperience: json["year_of_experience"],
//         companyDetails: json["company_details"] == null ? null : List<CompanyDetail>.from(json["company_details"].map((x) => CompanyDetail.fromJson(x))),
//         references: json["references"] == null ? null : List<Reference>.from(json["references"].map((x) => Reference.fromJson(x))),
//         highestQualification: json["highest_qualification"] == null ? null : json["highest_qualification"],
//         educationDetails: json["education_details"] == null ? null : EducationDetails.fromJson(json["education_details"]),
//         availability: json["availability"] == null ? null : Availability.fromJson(json["availability"]),
//         coverLetter: json["cover_letter"],
//         resume: json["resume"] == null ? null : json["resume"],
//         certifications: json["certifications"] == null ? null : json["certifications"],
//         registry: json["registry"],
//         aboutYourself: json["about_yourself"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//         aboutYourselfUrl: json["about_yourself_url"],
//         resumeUrl: json["resume_url"] == null ? null : json["resume_url"],
//         coverLetterUrl: json["cover_letter_url"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "year_of_experience": yearOfExperience,
//         "company_details": companyDetails == null ? null : List<dynamic>.from(companyDetails.map((x) => x.toJson())),
//         "references": references == null ? null : List<dynamic>.from(references.map((x) => x.toJson())),
//         "highest_qualification": highestQualification == null ? null : highestQualification,
//         "education_details": educationDetails == null ? null : educationDetails.toJson(),
//         "availability": availability == null ? null : availability.toJson(),
//         "cover_letter": coverLetter,
//         "resume": resume == null ? null : resume,
//         "certifications": certifications == null ? null : certifications,
//         "registry": registry,
//         "about_yourself": aboutYourself,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "deleted_at": deletedAt,
//         "about_yourself_url": aboutYourselfUrl,
//         "resume_url": resumeUrl == null ? null : resumeUrl,
//         "cover_letter_url": coverLetterUrl,
//     };
// }

// class Availability {
//     Availability({
//         this.token,
//         this.monday,
//         this.mondayTime,
//         this.mondayTo,
//         this.mondayTimeTo,
//         this.tuesday,
//         this.tuesdayTime,
//         this.tuesdayTo,
//         this.tuesdayTimeTo,
//         this.wednesday,
//         this.wednessdayTime,
//         this.wednessdayTo,
//         this.wednessdayTimeTo,
//         this.thursday,
//         this.thursdayTime,
//         this.thursdayTo,
//         this.thursdayTimeTo,
//         this.friday,
//         this.fridayTime,
//         this.fridayTo,
//         this.fridayTimeTo,
//         this.saturday,
//         this.saturdayTime,
//         this.saturdayTo,
//         this.saturdayTimeTo,
//         this.sunday,
//         this.sundayTime,
//         this.sundayTo,
//         this.sundayTimeTo,
//     });

//     String token;
//     String monday;
//     String mondayTime;
//     String mondayTo;
//     String mondayTimeTo;
//     String tuesday;
//     String tuesdayTime;
//     String tuesdayTo;
//     String tuesdayTimeTo;
//     String wednesday;
//     String wednessdayTime;
//     String wednessdayTo;
//     String wednessdayTimeTo;
//     String thursday;
//     String thursdayTime;
//     String thursdayTo;
//     String thursdayTimeTo;
//     String friday;
//     String fridayTime;
//     String fridayTo;
//     String fridayTimeTo;
//     String saturday;
//     String saturdayTime;
//     String saturdayTo;
//     String saturdayTimeTo;
//     String sunday;
//     String sundayTime;
//     String sundayTo;
//     String sundayTimeTo;

//     factory Availability.fromJson(Map<String, dynamic> json) => Availability(
//         token: json["_token"],
//         monday: json["monday"],
//         mondayTime: json["monday_time"],
//         mondayTo: json["monday_to"],
//         mondayTimeTo: json["monday_time_to"],
//         tuesday: json["tuesday"],
//         tuesdayTime: json["tuesday_time"],
//         tuesdayTo: json["tuesday_to"],
//         tuesdayTimeTo: json["tuesday_time_to"],
//         wednesday: json["wednesday"],
//         wednessdayTime: json["wednessday_time"],
//         wednessdayTo: json["wednessday_to"],
//         wednessdayTimeTo: json["wednessday_time_to"],
//         thursday: json["thursday"],
//         thursdayTime: json["thursday_time"],
//         thursdayTo: json["thursday_to"],
//         thursdayTimeTo: json["thursday_time_to"],
//         friday: json["friday"],
//         fridayTime: json["friday_time"],
//         fridayTo: json["friday_to"],
//         fridayTimeTo: json["friday_time_to"],
//         saturday: json["saturday"],
//         saturdayTime: json["saturday_time"],
//         saturdayTo: json["saturday_to"],
//         saturdayTimeTo: json["saturday_time_to"],
//         sunday: json["sunday"],
//         sundayTime: json["sunday_time"],
//         sundayTo: json["sunday_to"],
//         sundayTimeTo: json["sunday_time_to"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_token": token,
//         "monday": monday,
//         "monday_time": mondayTime,
//         "monday_to": mondayTo,
//         "monday_time_to": mondayTimeTo,
//         "tuesday": tuesday,
//         "tuesday_time": tuesdayTime,
//         "tuesday_to": tuesdayTo,
//         "tuesday_time_to": tuesdayTimeTo,
//         "wednesday": wednesday,
//         "wednessday_time": wednessdayTime,
//         "wednessday_to": wednessdayTo,
//         "wednessday_time_to": wednessdayTimeTo,
//         "thursday": thursday,
//         "thursday_time": thursdayTime,
//         "thursday_to": thursdayTo,
//         "thursday_time_to": thursdayTimeTo,
//         "friday": friday,
//         "friday_time": fridayTime,
//         "friday_to": fridayTo,
//         "friday_time_to": fridayTimeTo,
//         "saturday": saturday,
//         "saturday_time": saturdayTime,
//         "saturday_to": saturdayTo,
//         "saturday_time_to": saturdayTimeTo,
//         "sunday": sunday,
//         "sunday_time": sundayTime,
//         "sunday_to": sundayTo,
//         "sunday_time_to": sundayTimeTo,
//     };
// }

// class CompanyDetail {
//     CompanyDetail({
//         this.designation,
//         this.location,
//         this.skills,
//         this.workingSince,
//         this.minSalary,
//         this.maxSalary,
//         this.company,
//     });

//     String designation;
//     String location;
//     String skills;
//     String workingSince;
//     String minSalary;
//     String maxSalary;
//     String company;

//     factory CompanyDetail.fromJson(Map<String, dynamic> json) => CompanyDetail(
//         designation: json["Designation"],
//         location: json["Location"],
//         skills: json["Skills"],
//         workingSince: json["WorkingSince"],
//         minSalary: json["MinSalary"],
//         maxSalary: json["MaxSalary"],
//         company: json["Company"],
//     );

//     Map<String, dynamic> toJson() => {
//         "Designation": designation,
//         "Location": location,
//         "Skills": skills,
//         "WorkingSince": workingSince,
//         "MinSalary": minSalary,
//         "MaxSalary": maxSalary,
//         "Company": company,
//     };
// }

// class EducationDetails {
//     EducationDetails({
//         this.token,
//         this.majorDegree,
//         this.specialization,
//         this.university,
//         this.graduation,
//     });

//     String token;
//     String majorDegree;
//     String specialization;
//     String university;
//     String graduation;

//     factory EducationDetails.fromJson(Map<String, dynamic> json) => EducationDetails(
//         token: json["_token"],
//         majorDegree: json["MajorDegree"],
//         specialization: json["Specialization"],
//         university: json["University"],
//         graduation: json["graduation"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_token": token,
//         "MajorDegree": majorDegree,
//         "Specialization": specialization,
//         "University": university,
//         "graduation": graduation,
//     };
// }

// class Reference {
//     Reference({
//         this.referralPersonName,
//         this.companyName,
//         this.phoneNo,
//         this.email,
//     });

//     String referralPersonName;
//     String companyName;
//     String phoneNo;
//     String email;

//     factory Reference.fromJson(Map<String, dynamic> json) => Reference(
//         referralPersonName: json["ReferralPersonName"],
//         companyName: json["CompanyName"],
//         phoneNo: json["PhoneNo"],
//         email: json["Email"],
//     );

//     Map<String, dynamic> toJson() => {
//         "ReferralPersonName": referralPersonName,
//         "CompanyName": companyName,
//         "PhoneNo": phoneNo,
//         "Email": email,
//     };
// }
