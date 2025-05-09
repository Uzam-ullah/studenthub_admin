class TranscriptRequest {
  final String studentId;
  final String studentName;
  final String semester;
  final String requestDate;

  TranscriptRequest({
    required this.studentId,
    required this.studentName,
    required this.semester,
    required this.requestDate,
  });
}

class TranscriptPayment {
  final String studentId;
  final String studentName;
  final String semester;
  final double amount;
  final String dueDate;
  final String challanNumber;
  bool isPaid;

  TranscriptPayment({
    required this.studentId,
    required this.studentName,
    required this.semester,
    required this.amount,
    required this.dueDate,
    required this.challanNumber,
    this.isPaid = false,
  });
}

class Transcript {
  final String studentId;
  final String studentName;
  final String semester;
  final String issueDate;
  final String transcriptId;

  Transcript({
    required this.studentId,
    required this.studentName,
    required this.semester,
    required this.issueDate,
    required this.transcriptId,
  });
}