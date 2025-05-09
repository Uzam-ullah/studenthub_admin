import 'package:flutter/material.dart';
import '../models/enrollment_model.dart';

class EnrollmentController with ChangeNotifier {
  List<Course> _availableCourses = [
    Course(code: 'CS101', name: 'Introduction to Programming', creditHours: 3, semester: 'Fall 2023'),
    Course(code: 'MATH201', name: 'Calculus II', creditHours: 4, semester: 'Fall 2023'),
    Course(code: 'ENG102', name: 'Academic Writing', creditHours: 3, semester: 'Fall 2023'),
  ];

  List<Enrollment> _enrollments = [
    Enrollment(
      studentId: 'ST001',
      studentName: 'Ali Khan',
      courseId: 'CS101',
      courseName: 'Introduction to Programming',
      semester: 'Fall 2023',
      creditHours: 3,
    ),
  ];

  List<EnrollmentRequest> _pendingRequests = [
    EnrollmentRequest(
      studentId: 'ST002',
      studentName: 'Sara Ahmed',
      courseId: 'MATH201',
      courseName: 'Calculus II',
      semester: 'Fall 2023',
      creditHours: 4,
      type: 'add',
      currentCreditHours: 9,
      maxCreditHours: 18,
      reason: 'Required for major',
    ),
  ];

  List<Course> get availableCourses => _availableCourses;
  List<Enrollment> get enrollments => _enrollments;
  List<EnrollmentRequest> get pendingRequests => _pendingRequests;

  void addCourse(Course course) {
    _availableCourses.add(course);
    notifyListeners();
  }

  void removeCourse(int index) {
    _availableCourses.removeAt(index);
    notifyListeners();
  }

  void approveRequest(int index) {
    final request = _pendingRequests[index];

    if (request.type == 'add') {
      _enrollments.add(
        Enrollment(
          studentId: request.studentId,
          studentName: request.studentName,
          courseId: request.courseId,
          courseName: request.courseName,
          semester: request.semester,
          creditHours: request.creditHours,
        ),
      );
    } else {
      // Handle drop requests
      final enrollment = _enrollments.firstWhere(
            (e) => e.studentId == request.studentId && e.courseId == request.courseId,
      );
      enrollment.status = 'Dropped';
    }

    _pendingRequests.removeAt(index);
    notifyListeners();
  }

  void rejectRequest(int index, String reason) {
    _pendingRequests[index].rejectionReason = reason;
    _pendingRequests.removeAt(index);
    notifyListeners();
  }

  void dropEnrollment(int index) {
    _enrollments[index].status = 'Dropped';
    notifyListeners();
  }

  bool validateRequest(int index) {
    final request = _pendingRequests[index];
    if (request.type == 'add') {
      return (request.currentCreditHours + request.creditHours) <= request.maxCreditHours;
    }
    return true; // Drop requests are always valid
  }
}