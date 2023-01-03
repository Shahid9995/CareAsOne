class AllEmployer {
  AllEmployer({
    this.id,
    this.firstName,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.fullName,
  });

  int? id;
  String? firstName;
  String? email;
  String? phoneNumber;
  String? profileImageUrl;
  String? fullName;
  bool isSelected = false;

  factory AllEmployer.fromJson(Map<String, dynamic> json) => AllEmployer(
    id: json["id"],
    firstName: json["first_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    profileImageUrl: json["profile_image_url"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "email": email,
    "phone_number": phoneNumber,
    "profile_image_url": profileImageUrl,
    "full_name": fullName,
  };
}
