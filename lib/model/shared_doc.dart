class SharedDoc {
  SharedDoc({
    this.id,
    this.uploadedBy,
    this.name,
    this.extension,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.documentUrl,
    this.employeeDoc,
  });

  int? id;
  int? uploadedBy;
  String? name;
  String? extension;
  String? type;
 String? createdAt;
String? updatedAt;
  dynamic deletedAt;
  String? documentUrl;
  List<EmployeeDoc>? employeeDoc;
  bool isSelected = false;

  factory SharedDoc.fromJson(Map<String, dynamic> json) => SharedDoc(
        id: json["id"],
        uploadedBy: json["uploaded_by"],
        name: json["name"],
        extension: json["extension"],
        type: json["type"],
        createdAt:json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        documentUrl: json["document_url"],
        employeeDoc: List<EmployeeDoc>.from(
            json["employee_doc"].map((x) => EmployeeDoc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uploaded_by": uploadedBy,
        "name": name,
        "extension": extension,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "document_url": documentUrl,
        "employee_doc": List<dynamic>.from(employeeDoc!.map((x) => x.toJson())),
      };
}

class EmployeeDoc {
  EmployeeDoc({
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
String? emailVerifiedAt;
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

  factory EmployeeDoc.fromJson(Map<String, dynamic> json) => EmployeeDoc(
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
        // "dob": dob.toIso8601String(),
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
