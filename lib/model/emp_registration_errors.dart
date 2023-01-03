import 'dart:convert';

EmployerErrors employerPlansFromJson(String str) => EmployerErrors.fromJson(json.decode(str));

String employerPlansToJson(EmployerErrors data) => json.encode(data.toJson());

class EmployerErrors {
  EmployerErrors({
    this.message,
    this.errors,
  });

  String? message;
  Map<String, List<String>>? errors;

  factory EmployerErrors.fromJson(Map<String, dynamic> json) => EmployerErrors(
    message: json["message"],
    errors: Map.from(json["errors"]).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "errors": Map.from(errors!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
  };
}
