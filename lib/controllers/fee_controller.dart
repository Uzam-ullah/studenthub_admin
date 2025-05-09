import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/fee_model.dart';

class FeeController with ChangeNotifier {
  List<FeeRequest> _feeRequests = [
    FeeRequest(
      studentId: 'ST001',
      studentName: 'Ali Khan',
      amount: 50000,
      isInstallment: false,
      requestDate: '2023-10-15',
      reason: 'Financial difficulties',
    ),
    FeeRequest(
      studentId: 'ST002',
      studentName: 'Sara Ahmed',
      amount: 50000,
      isInstallment: true,
      requestDate: '2023-10-16',
      reason: 'Requesting installment plan',
    ),
  ];

  List<InstallmentPlan> _installmentPlans = [];
  List<FeePayment> _payments = [];

  List<FeeRequest> get feeRequests => _feeRequests;
  List<InstallmentPlan> get installmentPlans => _installmentPlans;
  List<FeePayment> get payments => _payments;

  void approveRequest(int index, double amount, String dueDate) {
    final request = _feeRequests[index];

    if (request.isInstallment) {
      // Create installment plan (2 installments with 1 month gap)
      final firstDue = DateTime.parse(dueDate);
      final secondDue = DateTime(firstDue.year, firstDue.month + 1, firstDue.day);

      _installmentPlans.add(
        InstallmentPlan(
          id: 'IP${DateTime.now().millisecondsSinceEpoch}',
          studentId: request.studentId,
          studentName: request.studentName,
          totalAmount: amount,
          installments: [
            Installment(
              id: 'I${DateTime.now().millisecondsSinceEpoch}1',
              amount: amount / 2,
              dueDate: DateFormat('yyyy-MM-dd').format(firstDue),
            ),
            Installment(
              id: 'I${DateTime.now().millisecondsSinceEpoch}2',
              amount: amount / 2,
              dueDate: DateFormat('yyyy-MM-dd').format(secondDue),
            ),
          ],
        ),
      );
    } else {
      // For urgent requests, just add to payments
      _payments.add(
        FeePayment(
          studentId: request.studentId,
          studentName: request.studentName,
          amount: amount,
          date: dueDate,
          receiptNumber: 'R${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
    }

    _feeRequests.removeAt(index);
    notifyListeners();
  }

  void rejectRequest(int index, String reason) {
    _feeRequests[index].rejectionReason = reason;
    _feeRequests.removeAt(index);
    notifyListeners();
  }

  void addPayment(String studentName, double amount, {String? receiptNumber, String? paymentMethod}) {
    _payments.add(
      FeePayment(
        studentId: 'ST${_payments.length + 1}',
        studentName: studentName,
        amount: amount,
        date: DateTime.now().toString().split(' ')[0],
        receiptNumber: receiptNumber ?? 'R${DateTime.now().millisecondsSinceEpoch}',
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
  }

  void recordInstallmentPayment(String planId, String installmentId, double amount, {String? receiptNumber}) {
    final plan = _installmentPlans.firstWhere((p) => p.id == planId);
    final installment = plan.installments.firstWhere((i) => i.id == installmentId);

    installment.isPaid = true;
    installment.paymentDate = DateTime.now().toString().split(' ')[0];
    installment.receiptNumber = receiptNumber ?? 'R${DateTime.now().millisecondsSinceEpoch}';

    // Add to payments list
    _payments.add(
      FeePayment(
        studentId: plan.studentId,
        studentName: plan.studentName,
        amount: amount,
        date: installment.paymentDate!,
        receiptNumber: installment.receiptNumber!,
        paymentMethod: 'Installment',
      ),
    );

    notifyListeners();
  }
}