// To parse this JSON data, do
//
//     final availabilityData = availabilityDataFromJson(jsonString);

import 'dart:convert';

AvailabilityData availabilityDataFromJson(String str) => AvailabilityData.fromJson(json.decode(str));

String availabilityDataToJson(AvailabilityData data) => json.encode(data.toJson());

class AvailabilityData {
  AvailabilityData({
    this.status,
    this.data,
    this.startDateRange,
    this.endDateRange,
  });

  String? status;
  Data? data;
  String? startDateRange;
  String? endDateRange;

  factory AvailabilityData.fromJson(Map<String, dynamic> json) => AvailabilityData(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    startDateRange:json["start_date_range"]==null?null:json["start_date_range"],
    endDateRange:json["end_date_range"]==null?null:json["end_date_range"]
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
    "start_date_range":startDateRange,
    "end_date_range":endDateRange,
  };
}

class Data {
  Data({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  List<Day>? monday;
  List<Day>? tuesday;
  List<Day>? wednesday;
  List<Day>? thursday;
  List<Day>? friday;
  List<Day>? saturday;
  List<Day>? sunday;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    monday: List<Day>.from(json["monday"].map((x) => Day.fromJson(x))),
    tuesday: List<Day>.from(json["tuesday"].map((x) => Day.fromJson(x))),
    wednesday: List<Day>.from(json["wednesday"].map((x) => Day.fromJson(x))),
    thursday: List<Day>.from(json["thursday"].map((x) => Day.fromJson(x))),
    friday: List<Day>.from(json["friday"].map((x) => Day.fromJson(x))),
    saturday: List<Day>.from(json["saturday"].map((x) => Day.fromJson(x))),
    sunday: List<Day>.from(json["sunday"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "monday": List<dynamic>.from(monday!.map((x) => x.toJson())),
    "tuesday": List<dynamic>.from(tuesday!.map((x) => x.toJson())),
    "wednesday": List<dynamic>.from(wednesday!.map((x) => x.toJson())),
    "thursday": List<dynamic>.from(thursday!.map((x) => x.toJson())),
    "friday": List<dynamic>.from(friday!.map((x) => x.toJson())),
    "saturday": List<dynamic>.from(saturday!.map((x) => x.toJson())),
    "sunday": List<dynamic>.from(sunday!.map((x) => x.toJson())),
  };
}

class Day {
  Day({
    this.from,
    this.fromTime,
    this.to,
    this.toTime,
  });

  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    from: json["from"],
    fromTime: json["from_time"],
    to: json["to"],
    toTime: json["to_time"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "from_time": fromTime,
    "to": to,
    "to_time": toTime,
  };
}


class Monday {
  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  Monday({this.from, this.fromTime, this.to, this.toTime});

  factory Monday.fromJson(Map<String, dynamic> json) => Monday(
      from: json['from'],
      fromTime: json['from_time'],
      to: json['to'],
      toTime: json['to_time']);
}

class Tuesday {
  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  Tuesday({this.from, this.fromTime, this.to, this.toTime});

  factory Tuesday.fromJson(Map<String, dynamic> json) => Tuesday(
      from: json['from'],
      fromTime: json['from_time'],
      to: json['to'],
      toTime: json['to_time']);
}

class Wednesday {
  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  Wednesday({this.from, this.fromTime, this.to, this.toTime});

  factory Wednesday.fromJson(Map<String, dynamic> json) => Wednesday(
      from: json['from'],
      fromTime: json['from_time'],
      to: json['to'],
      toTime: json['to_time']);
}

class Thursday {
  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  Thursday({this.from, this.fromTime, this.to, this.toTime});

  factory Thursday.fromJson(Map<String, dynamic> json) => Thursday(
      from: json['from'],
      fromTime: json['from_time'],
      to: json['to'],
      toTime: json['to_time']);
}

class Friday {
  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  Friday({this.from, this.fromTime, this.to, this.toTime});

  factory Friday.fromJson(Map<String, dynamic> json) => Friday(
      from: json['from'],
      fromTime: json['from_time'],
      to: json['to'],
      toTime: json['to_time']);
}

class Saturday {
  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  Saturday({this.from, this.fromTime, this.to, this.toTime});

  factory Saturday.fromJson(Map<String, dynamic> json) => Saturday(
      from: json['from'],
      fromTime: json['from_time'],
      to: json['to'],
      toTime: json['to_time']);
}

class Sunday {
  String? from;
  String? fromTime;
  String? to;
  String? toTime;

  Sunday({this.from, this.fromTime, this.to, this.toTime});

  factory Sunday.fromJson(Map<String, dynamic> json) => Sunday(
      from: json['from'],
      fromTime: json['from_time'],
      to: json['to'],
      toTime: json['to_time']);
}
