class Complaint {
  final String studentName;
  final String title;
  final String description;
  final String date;
  bool resolved;
  String? response;

  Complaint({
    required this.studentName,
    required this.title,
    required this.description,
    required this.date,
    this.resolved = false,
    this.response,
  });
}