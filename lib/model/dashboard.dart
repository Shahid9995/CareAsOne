class EmpDashboardModel {
  EmpDashboardModel({
    this.result,
    this.totalJobs,
    this.totalHire,
    this.remainingJobPosts,
    this.totalApplicants,
  });

  Result? result;
  int? totalJobs;
  int? totalHire;
  int? remainingJobPosts;
  int? totalApplicants;

  factory EmpDashboardModel.fromJson(Map<String, dynamic> json) =>
      EmpDashboardModel(
        result: Result.fromJson(json["result"]),
        totalJobs: json["total_jobs"],
        totalHire: json["total_hire"],
        remainingJobPosts: json["remaining_job_posts"],
        totalApplicants: json["total_applicants"],
      );

// Map<String, dynamic> toJson() => {
//     "result": result.toJson(),
//     "total_jobs": totalJobs,
//     "total_hire": totalHire,
//     "remaining_job_posts": remainingJobPosts,
//     "total_applicants": totalApplicants,
// };
}

class Result {
  Result({
    this.plan,
    this.addOnDoc,
    this.addOnTraining
  });

  String? plan;
  String? addOnDoc;
  String? addOnTraining;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        plan: json["0"],
        addOnDoc: json["1"],
        addOnTraining: json["2"],
      );

  Map<String, dynamic> toJson() => {
        "0": plan,
      };
}
