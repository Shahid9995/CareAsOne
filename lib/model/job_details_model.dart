class JobDetail {
  JobDetail({
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
  String? location;
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

  factory JobDetail.fromJson(Map<String, dynamic> json) => JobDetail(
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
    company:json["company"]==null?null: Company.fromJson(json["company"]),
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

class Logo {
  Logo({
    this.logo,
  });

  String? logo;

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "logo": logo,
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
