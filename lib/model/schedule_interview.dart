class ScheduleInterviews {
  ScheduleInterviews({
    this.interviewDate,
    this.meetingId,
    this.firstName,
    this.email,
    this.formatedInterviewDate
  });

  DateTime? interviewDate;
  String? meetingId;
  String? firstName;
  String? email;
  String? formatedInterviewDate;

  factory ScheduleInterviews.fromJson(Map<String, dynamic> json) =>
      ScheduleInterviews(
        interviewDate: DateTime.parse(json["interview_date"]),
        meetingId: json["meeting_id"],
        firstName: json["first_name"],
        email:json["email"],
        formatedInterviewDate: json['interview_date_formatted']
      );

  Map<String, dynamic> toJson() => {
        "interview_date": interviewDate,
        "meeting_id": meetingId,
        "first_name": firstName,
      };
}
