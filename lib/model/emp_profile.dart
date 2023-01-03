class EmpProfileModel {
  EmpProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.address,
    this.profileImage,
    this.passwordResetToken,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.verifiedAt,
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
    this.profileImageUrl,
    this.fullName,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;
  String? gender;
  String? verifiedAt;
  String? phoneNumber;
  String? address;
  String? profileImage;
  dynamic passwordResetToken;
  String? userType;
  String? createdAt;
  String? updatedAt;
  dynamic stripeId;
  String? cardBrand;
  String? cardLastFour;
  dynamic trialEndsAt;
  int? confirmed;
  int? allowedJobLimit;
  dynamic city;
  dynamic state;
  dynamic zipCode;
  dynamic addressOptional;
  dynamic deletedAt;
  dynamic ipAddress;
  String? braintreeId;
  dynamic paypalEmail;
  String? apiToken;
  String? profileImageUrl;
  String? fullName;

  factory EmpProfileModel.fromJson(Map<String, dynamic> json) =>
      EmpProfileModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        dob: json["dob"],
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        profileImage: json["profile_image"],
        verifiedAt: json["email_verified_at"],
        passwordResetToken: json["password_reset_token"],
        userType: json["user_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "password_reset_token": passwordResetToken,
        "user_type": userType,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
        "profile_image_url": profileImageUrl,
        "full_name": fullName,
      };
}
