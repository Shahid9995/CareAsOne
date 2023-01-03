class PlanModel {
  PlanModel(
      {this.id,
      this.name,
      this.slug,
      this.stripeProductId,
      this.stripeProductName,
      this.stripePlanId,
      this.stripePlanName,
      this.cost,
      this.planId,
      this.duration,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.squarePlanId,
      this.squarePlanName,
      this.braintreePlanId,
      this.value1,
      this.value2});

  int? id;
  String? name;
  String? slug;
  String? stripeProductId;
  dynamic stripeProductName;
  String? stripePlanId;
  dynamic stripePlanName;
  int? cost;
  int? planId;
  String? duration;
  dynamic description;
  String? createdAt;
  String? updatedAt;
  String? squarePlanId;
  String? squarePlanName;
  String? braintreePlanId;
  bool? value1 = false;
  bool? value2 = false;

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        stripeProductId: json["stripe_product_id"],
        stripeProductName: json["stripe_product_name"],
        stripePlanId: json["stripe_plan_id"],
        stripePlanName: json["stripe_plan_name"],
        cost: json["cost"],
        planId: json["plan_id"],
        duration: json["duration"],
        description: json["description"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        squarePlanId: json["square_plan_id"],
        squarePlanName: json["square_plan_name"],
        value1: false,
        value2: false,
        braintreePlanId: json["braintree_plan_id"] == null
            ? null
            : json["braintree_plan_id"],
      );
}
