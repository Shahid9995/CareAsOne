class CompanyProfile {
  CompanyProfile({
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
    this.presonLastName,
    // this.createdAt,
    // this.updatedAt,
    this.deletedAt,
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
  String? presonLastName;

  // DateTime createdAt;
  // DateTime updatedAt;
  dynamic deletedAt;

  factory CompanyProfile.fromJson(Map<String, dynamic> json) => CompanyProfile(
        id: json["id"],
        userId: json["user_id"],
        companyTypeId: json["company_type_id"],
        logo: json["logo"]==null?null:json["logo"],
        name: json["name"]==null?null:json["name"],
        address: json["address"]==null?null:json["address"],
        phoneNumber: json["phone_number"]==null?null:json["phone_number"],
        city: json["city"]==null?null:json["city"],
        zipcode: json["zipcode"]==null?null:json["zipcode"],
        state: json["state"]==null?null:json["state"],
        country: json["country"]==null?null:json["country"],
        contactPerson: json["contact_person"]==null?null:json["contact_person"],
        presonLastName: json["preson_last_name"]==null?null:json["preson_last_name"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
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
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
