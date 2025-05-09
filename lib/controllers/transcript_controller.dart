import 'package:flutter/material.dart';
import '../models/transcript_model.dart';

class TranscriptController with ChangeNotifier {
  List<TranscriptRequest> _requests = [];
  List<TranscriptPayment> _pendingPayments = [];
  List<Transcript> _transcripts = [];

  List<TranscriptRequest> get requests => _requests;
  List<TranscriptPayment> get pendingPayments => _pendingPayments;
  List<Transcript> get transcripts => _transcripts;

  // Sample initial data
  TranscriptController() {
    _requests = [
      TranscriptRequest(
        studentId: 'ST001',
        studentName: 'Ali Khan',
        semester: 'Fall 2023',
        requestDate: '2023-10-15',
      ),
      TranscriptRequest(
        studentId: 'ST002',
        studentName: 'Sara Ahmed',
        semester: 'Spring 2023',
        requestDate: '2023-10-16',
      ),
    ];
  }

  void generateChallan(int requestIndex, double amount, String dueDate) {
    final request = _requests[requestIndex];
    final challanNumber = 'CH${DateTime.now().millisecondsSinceEpoch}';

    _pendingPayments.add(
      TranscriptPayment(
        studentId: request.studentId,
        studentName: request.studentName,
        semester: request.semester,
        amount: amount,
        dueDate: dueDate,
        challanNumber: challanNumber,
      ),
    );

    _requests.removeAt(requestIndex);
    notifyListeners();
  }

  void approveRequest(int paymentIndex) {
    final payment = _pendingPayments[paymentIndex];
    final transcriptId = 'TR${DateTime.now().millisecondsSinceEpoch}';

    _transcripts.add(
      Transcript(
        studentId: payment.studentId,
        studentName: payment.studentName,
        semester: payment.semester,
        issueDate: DateTime.now().toString().split(' ')[0],
        transcriptId: transcriptId,
      ),
    );

    _pendingPayments.removeAt(paymentIndex);
    notifyListeners();
  }

  void rejectRequest(int requestIndex) {
    _requests.removeAt(requestIndex);
    notifyListeners();
  }

  // For testing - mark payment as paid
  void markAsPaid(int paymentIndex) {
    _pendingPayments[paymentIndex].isPaid = true;
    notifyListeners();
  }
}