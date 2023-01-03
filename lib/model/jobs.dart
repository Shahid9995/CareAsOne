import 'package:careAsOne/model/company_profile.dart';

class JobsModel {
  JobsModel({
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
    // this.user,
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

  //List<KeywordClass> keywords;

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

  // User user;

  factory JobsModel.fromJson(Map<String, dynamic> parsedJson) => JobsModel(
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
        /* keywords: List<KeywordClass>.from(
            parsedJson["keywords"].map((x) => KeywordClass.fromJson(x))),*/
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
        // user: User.fromJson(parsedJson["user"])
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
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;
  String? gender;
  String? phoneNumber;
  String? address;
  String? profileImage;
  String? emailVerifiedAt;
  String? emailVerificationToken;
  String? passwordResetToken;
  String? userType;
  String? createdAt;
  String? updatedAt;
  String? stripeId;
  String? cardBrand;
  String? cardLastFour;
  String? trialEndsAt;
  int? confirmed;
  int? allowedJobLimit;
  String? city;
  String? state;
  String? zipCode;
  String? addressOptional;
  String? deletedAt;
  String? ipAddress;
  String? braintreeId;
  String? paypalEmail;
  String? apiToken;
  String? deviceToken;
  String? socialId;
  String? profileImageUrl;
  String? fullName;
  List<KeywordClass>? keywords;
  CompanyProfile? companyProfile;

  User(
      {this.id,
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
      this.socialId,
      this.profileImageUrl,
      this.fullName,
      this.companyProfile,
      this.keywords});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      dob: json['dob'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      profileImage: json['profile_image'],
      emailVerifiedAt: json['email_verified_at'],
      emailVerificationToken: json['email_verification_token'],
      passwordResetToken: json['password_reset_token'],
      userType: json['user_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      stripeId: json['stripe_id'],
      cardBrand: json['card_brand'],
      // keywords: List<KeywordClass>.from(
      //    json["keywords"].map((x) => KeywordClass.fromJson(x))),
      cardLastFour: json['card_last_four'],
      trialEndsAt: json['trial_ends_at'],
      confirmed: json['confirmed'],
      allowedJobLimit: json['allowed_job_limit'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      addressOptional: json['address_optional'],
      deletedAt: json['deleted_at'],
      ipAddress: json['ip_address'],
      braintreeId: json['braintree_id'],
      paypalEmail: json['paypal_email'],
      apiToken: json['api_token'],
      deviceToken: json['device_token'],
      socialId: json['social_id'],
      profileImageUrl: json['profile_image_url'],
      fullName: json['full_name'],
      companyProfile: CompanyProfile.fromJson(json['company_detail']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'dob': dob,
        'gender': gender,
        'phone_number': phoneNumber,
        'address': address,
        'profile_image': profileImage,
        'email_verified_at': emailVerifiedAt,
        'email_verification_token': emailVerificationToken,
        'password_reset_token': passwordResetToken,
        'user_type': userType,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'stripe_id': stripeId,
        'card_brand': cardBrand,
        'card_last_four': cardLastFour,
        'trial_ends_at': trialEndsAt,
        'confirmed': confirmed,
        'allowed_job_limit': allowedJobLimit,
        'city': city,
        'state': state,
        'keywords': keywords,
        'zip_code': zipCode,
        'address_optional': addressOptional,
        'deleted_at': deletedAt,
        'ip_address': ipAddress,
        'braintree_id': braintreeId,
        'paypal_email': paypalEmail,
        'api_token': apiToken,
        'device_token': deviceToken,
        'social_id': socialId,
        'profile_image_url': profileImageUrl,
        'full_name': fullName,
      };
}

class KeywordClass {
  final String? value;

  KeywordClass({this.value});

  factory KeywordClass.fromJson(Map<String, String> json) => KeywordClass(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "keywords": value,
      };
}
