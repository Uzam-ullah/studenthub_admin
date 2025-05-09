import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/fee_controller.dart';
import '../models/fee_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_card.dart';

class FeeScreen extends StatefulWidget {
  const FeeScreen({super.key});

  @override
  State<FeeScreen> createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _installmentController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _installmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FeeController>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Fee Management'),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Urgent Requests'),
                Tab(text: 'Installments'),
                Tab(text: 'Payments'),
              ],
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUrgentRequestList(controller),
                  _buildInstallmentList(controller),
                  _buildPaymentList(controller),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddPaymentDialog(context, controller),
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildUrgentRequestList(FeeController controller) {
    final requests = controller.feeRequests
        .where((req) => req.isInstallment == false)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return CustomCard(
          child: ListTile(
            title: Text(request.studentName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: \$${request.amount.toStringAsFixed(2)}'),
                if (request.reason != null)
                  Text('Reason: ${request.reason}'),
                Text('Request Date: ${request.requestDate}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.receipt, color: Colors.blue),
                  onPressed: () => _showGenerateChallanDialog(context, controller, request),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _showRejectDialog(context, controller, request),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstallmentList(FeeController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.installmentPlans.length,
      itemBuilder: (context, index) {
        final plan = controller.installmentPlans[index];
        return CustomCard(
          child: ExpansionTile(
            title: Text(plan.studentName),
            subtitle: Text('Total Amount: \$${plan.totalAmount.toStringAsFixed(2)}'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ...plan.installments.map((installment) => ListTile(
                      title: Text('Due: ${installment.dueDate}'),
                      subtitle: Text('Amount: \$${installment.amount.toStringAsFixed(2)}'),
                      trailing: Text(
                        installment.isPaid ? 'Paid' : 'Pending',
                        style: TextStyle(
                          color: installment.isPaid ? Colors.green : Colors.orange,
                        ),
                      ),
                    )),
                    const SizedBox(height: 8),
                    if (plan.installments.any((i) => !i.isPaid))
                      ElevatedButton(
                        onPressed: () => _showAddInstallmentPaymentDialog(context, controller, plan),
                        child: const Text('Record Payment'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentList(FeeController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.payments.length,
      itemBuilder: (context, index) {
        final payment = controller.payments[index];
        return CustomCard(
          child: ListTile(
            title: Text(payment.studentName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: \$${payment.amount.toStringAsFixed(2)}'),
                Text('Payment Date: ${payment.date}'),
                Text('Receipt No: ${payment.receiptNumber}'),
                if (payment.paymentMethod != null)
                  Text('Method: ${payment.paymentMethod}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.receipt, color: Colors.teal),
              onPressed: () => _showReceiptDialog(context, payment),
            ),
          ),
        );
      },
    );
  }

  void _showGenerateChallanDialog(BuildContext context, FeeController controller, FeeRequest request) {
    final amountController = TextEditingController(text: request.amount.toString());
    final dueDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 7))),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Generate Fee Challan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Student: ${request.studentName}'),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(dueDateController.text),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.approveRequest(
                  controller.feeRequests.indexOf(request),
                  double.parse(amountController.text),
                  dueDateController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Challan generated successfully!')),
                );
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context, FeeController controller, FeeRequest request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Fee Request'),
          content: TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason for rejection',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.rejectRequest(
                  controller.feeRequests.indexOf(request),
                  _reasonController.text,
                );
                _reasonController.clear();
                Navigator.pop(context);
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPaymentDialog(BuildContext context, FeeController controller) {
    final studentController = TextEditingController();
    final amountController = TextEditingController();
    final receiptController = TextEditingController();
    final methodController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Record Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: receiptController,
                decoration: const InputDecoration(
                  labelText: 'Receipt Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: methodController,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (studentController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  controller.addPayment(
                    studentController.text,
                    double.parse(amountController.text),
                    receiptNumber: receiptController.text,
                    paymentMethod: methodController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Record'),
            ),
          ],
        );
      },
    );
  }

  void _showAddInstallmentPaymentDialog(
      BuildContext context, FeeController controller, InstallmentPlan plan) {
    final unpaidInstallments = plan.installments.where((i) => !i.isPaid).toList();
    String? selectedInstallmentId;
    final amountController = TextEditingController();
    final receiptController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Record Installment Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedInstallmentId,
                items: unpaidInstallments.map((installment) {
                  return DropdownMenuItem(
                    value: installment.id,
                    child: Text('${installment.dueDate} - \$${installment.amount}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedInstallmentId = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Installment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount Paid',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: receiptController,
                decoration: const InputDecoration(
                  labelText: 'Receipt Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedInstallmentId != null &&
                    amountController.text.isNotEmpty) {
                  controller.recordInstallmentPayment(
                    plan.id,
                    selectedInstallmentId!,
                    double.parse(amountController.text),
                    receiptNumber: receiptController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Record'),
            ),
          ],
        );
      },
    );
  }

  void _showReceiptDialog(BuildContext context, FeePayment payment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Receipt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student: ${payment.studentName}'),
              Text('Amount: \$${payment.amount.toStringAsFixed(2)}'),
              Text('Date: ${payment.date}'),
              Text('Receipt No: ${payment.receiptNumber}'),
              if (payment.paymentMethod != null)
                Text('Method: ${payment.paymentMethod}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}