class FeeRequest {
  final String studentId;
  final String studentName;
  final double amount;
  final bool isInstallment;
  final String requestDate;
  String? reason;
  String? rejectionReason;

  FeeRequest({
    required this.studentId,
    required this.studentName,
    required this.amount,
    required this.isInstallment,
    required this.requestDate,
    this.reason,
    this.rejectionReason,
  });
}

class Installment {
  final String id;
  final double amount;
  final String dueDate;
  bool isPaid;
  String? paymentDate;
  String? receiptNumber;

  Installment({
    required this.id,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.paymentDate,
    this.receiptNumber,
  });
}

class InstallmentPlan {
  final String id;
  final String studentId;
  final String studentName;
  final double totalAmount;
  final List<Installment> installments;

  InstallmentPlan({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.totalAmount,
    required this.installments,
  });
}

class FeePayment {
  final String studentId;
  final String studentName;
  final double amount;
  final String date;
  final String receiptNumber;
  final String? paymentMethod;

  FeePayment({
    required this.studentId,
    required this.studentName,
    required this.amount,
    required this.date,
    required this.receiptNumber,
    this.paymentMethod,
  });
}