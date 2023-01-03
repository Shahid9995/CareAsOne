class SeekerEmploymentDetails {
  int? id;
  int? userId;
  String? experience;
  String? highestQualification;

  List<CompanyDetails>? companyDetails;
  List<References>? references;

  SeekerEmploymentDetails({
    this.id,
    this.userId,
    this.experience,
    this.companyDetails,
    this.highestQualification,
    this.references,
  });

  factory SeekerEmploymentDetails.fromJson(Map<String, dynamic> json) =>
      SeekerEmploymentDetails(
        id: json['id'],
        userId: json['user_id'],
        experience: json['year_of_experience'],
        highestQualification: json['highest_qualification'],
        companyDetails:json["company_details"]!=null?List<CompanyDetails>.from(
            json["company_details"].map((x) => CompanyDetails.fromJson(x))):[],
        references: json["references"]!=null?List<References>.from(
            json["references"].map((x) => References.fromJson(x))):[],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "year_of_experience": experience,
        "company_details":
            List<dynamic>.from(companyDetails!.map((x) => x.toJson())),
        "references": List<dynamic>.from(references!.map((x) => x.toJson())),
        "highest_qualification": highestQualification,
      };
}

class CompanyDetails {
  String? designation;
  String? location;
  String? skills;
  String? state;
  String? workingSince;
  String? companyName;

  CompanyDetails(
      {this.designation,
      this.location,
      this.skills,
      this.workingSince,
      this.companyName,
      this.state});

  factory CompanyDetails.fromJson(Map<String, dynamic> json) => CompanyDetails(
        designation: json['Designation'],
        location: json['Location'],
        skills: json['Skills'],
        state: json['State'],
        workingSince: json['WorkingSince'],
        companyName: json['Company'],
      );

  Map<String, dynamic> toJson() => {
        "Designation": designation,
        "Location": location,
        "Skills": skills,
        "WorkingSince": workingSince,
        "Company": companyName,
        "State": state,
      };
}

class References {
  String? referralPersonName;
  String? companyName;
  String? phoneNumber;
  String? email;

  References(
      {this.referralPersonName,
      this.companyName,
      this.phoneNumber,
      this.email});

  factory References.fromJson(Map<String, dynamic> json) => References(
      referralPersonName: json['ReferralPersonName'],
      companyName: json['CompanyName'],
      phoneNumber: json['PhoneNumber'],
      email: json['Email']);

  Map<String, dynamic> toJson() => {
        "ReferralPersonName": referralPersonName,
        "CompanyName": companyName,
        "PhoneNumber": phoneNumber,
        "Email": email,
      };
}

class EducationDetail {
  String? majorDegree;
  String? specialization;
  String? university;
  String? graduation;

  EducationDetail(
      {this.majorDegree,
      this.specialization,
      this.university,
      this.graduation});

  factory EducationDetail.fromJson(Map<String, dynamic> json) =>
      EducationDetail(
        majorDegree: json['MajorDegree'],
        specialization: json['Specialization'],
        university: json['University'],
        graduation: json['graduation'],
      );
}
