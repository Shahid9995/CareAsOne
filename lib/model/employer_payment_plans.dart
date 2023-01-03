// To parse this JSON data, do
//
//     final employerPlans = employerPlansFromJson(jsonString);

import 'dart:convert';

EmployerPlans employerPlansFromJson(String str) => EmployerPlans.fromJson(json.decode(str));

String employerPlansToJson(EmployerPlans data) => json.encode(data.toJson());

class EmployerPlans {
  EmployerPlans({
    this.message,
    this.data,
  });

  String? message;
  List<Plans>? data;

  factory EmployerPlans.fromJson(Map<String, dynamic> json) => EmployerPlans(
    message: json["message"],
    data: List<Plans>.from(json["data"].map((x) => Plans.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Plans {
  Plans({
    this.id,
    this.name,
    this.slug,
    this.stripeProductId,
    this.stripeProductName,
    this.stripePlanId,
    this.stripePlanName,
    this.squarePlanId,
    this.squarePlanName,
    this.cost,
    this.planId,
    this.duration,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.braintreePlanId,
  });

  int? id;
  String? name;
  String? slug;
  String? stripeProductId;
  dynamic stripeProductName;
  String? stripePlanId;
  dynamic stripePlanName;
  String? squarePlanId;
  String? squarePlanName;
  int? cost;
  int? planId;
  String? duration;
  dynamic description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? braintreePlanId;

  factory Plans.fromJson(Map<String, dynamic> json) => Plans(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    stripeProductId: json["stripe_product_id"],
    stripeProductName: json["stripe_product_name"],
    stripePlanId: json["stripe_plan_id"],
    stripePlanName: json["stripe_plan_name"],
    squarePlanId: json["square_plan_id"],
    squarePlanName: json["square_plan_name"],
    cost: json["cost"],
    planId: json["plan_id"],
    duration: json["duration"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    braintreePlanId: json["braintree_plan_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "stripe_product_id": stripeProductId,
    "stripe_product_name": stripeProductName,
    "stripe_plan_id": stripePlanId,
    "stripe_plan_name": stripePlanName,
    "square_plan_id": squarePlanId,
    "square_plan_name": squarePlanName,
    "cost": cost,
    "plan_id": planId,
    "duration": duration,
    "description": description,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "braintree_plan_id": braintreePlanId,
  };
}
