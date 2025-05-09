class Course {
  final String code;
  final String name;
  final int creditHours;
  final String semester;

  Course({
    required this.code,
    required this.name,
    required this.creditHours,
    required this.semester,
  });
}

class Enrollment {
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseName;
  final String semester;
  final int creditHours;
  String status; // Active, Dropped, Completed

  Enrollment({
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseName,
    required this.semester,
    required this.creditHours,
    this.status = 'Active',
  });
}

class EnrollmentRequest {
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseName;
  final String semester;
  final int creditHours;
  final String type; // 'add' or 'drop'
  final int currentCreditHours;
  final int maxCreditHours;
  String? reason;
  String? rejectionReason;

  EnrollmentRequest({
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseName,
    required this.semester,
    required this.creditHours,
    required this.type,
    required this.currentCreditHours,
    required this.maxCreditHours,
    this.reason,
    this.rejectionReason,
  });
}