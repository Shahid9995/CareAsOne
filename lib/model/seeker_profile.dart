class SeekerProfileModel {
  SeekerProfileModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.dob,
      this.gender,
      this.phoneNumber,
      this.address,
      this.city,
      this.state,
      this.zipCode,
      this.profileImage,
      this.emailVerifiedAt,
      this.emailVerificationToken,
      this.passwordResetToken,
      this.userType});

  int? id;
  var profileImage;
  String? firstName;
  String? address;
  String? emailVerifiedAt;
  String? gender;
  dynamic passwordResetToken;
  String? lastName;
  var userType;
  var dob;
  dynamic emailVerificationToken;
  String? email;
  String? city;
  String? state;
  String? zipCode;
  String? phoneNumber;

  factory SeekerProfileModel.fromJson(Map<String, dynamic> json) =>
      SeekerProfileModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        dob: json["dob"]==null?null:json["dob"],
        gender: json["gender"]==null?null:json["gender"],
        phoneNumber: json["phone_number"]==null?null:json["phone_number"],
        address: json["address"]==null?null:json["address"],
        profileImage: json["profile_image"]==null?null:json["profile_image"],
        city: json["city"]==null?null:json["city"],
        state: json["state"]==null?null:json["state"],
        zipCode: json["zip_code"]==null?null:json["zip_code"],
        emailVerifiedAt: json["email_verified_at"],
        emailVerificationToken: json["email_verification_token"],
        passwordResetToken: json["password_reset_token"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "dob": dob,
        "gender": gender,
        "phone_number": phoneNumber,
        "address": address,
        "profile_image": profileImage,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "email_verification_at": emailVerifiedAt,
        "email_verification_token": emailVerificationToken,
        "password_reset_token": passwordResetToken,
        "user_type": userType,
      };
}
