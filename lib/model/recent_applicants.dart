class RecentApplicants {
  RecentApplicants({
    this.appId,
    this.name,
    this.email,
    this.appliedOn,
    this.status,
  });

  int? appId;
  String? name;
  String? email;
  String? appliedOn;
  String? status;

  factory RecentApplicants.fromJson(Map<String, dynamic> json) =>
      RecentApplicants(
        appId: json["app_id"],
        name: json["name"],
        email: json["email"],
        appliedOn: json['applied_on'],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "app_id": appId,
        "name": name,
        "email": email,
        "applied_on": appliedOn,
        "status": status,
      };
}
