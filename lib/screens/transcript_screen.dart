import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/transcript_controller.dart';
import '../models/transcript_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_card.dart';

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TranscriptController>(context);
    return DefaultTabController(
      length: 3, // Added new tab for pending payments
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Transcript Management'),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'New Requests'),
                Tab(text: 'Pending Payment'),
                Tab(text: 'Issued Transcripts'),
              ],
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRequestList(controller),
                  _buildPendingPaymentList(controller),
                  _buildTranscriptList(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList(TranscriptController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.requests.length,
      itemBuilder: (context, index) {
        final request = controller.requests[index];
        return CustomCard(
          child: ListTile(
            title: Text(request.studentName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Semester: ${request.semester}'),
                Text('Student ID: ${request.studentId}'),
                Text('Request Date: ${request.requestDate}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.receipt, color: Colors.blue),
                  onPressed: () {
                    _showGenerateChallanDialog(context, controller, index);
                  },
                  tooltip: 'Generate Challan',
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => controller.rejectRequest(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingPaymentList(TranscriptController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.pendingPayments.length,
      itemBuilder: (context, index) {
        final payment = controller.pendingPayments[index];
        return CustomCard(
          child: ListTile(
            title: Text(payment.studentName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Semester: ${payment.semester}'),
                Text('Challan Amount: Rs. ${payment.amount}'),
                Text('Due Date: ${payment.dueDate}'),
                Text('Status: ${payment.isPaid ? "Paid" : "Pending"}'),
              ],
            ),
            trailing: payment.isPaid
                ? IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                controller.approveRequest(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transcript issued successfully!'),
                  ),
                );
              },
              tooltip: 'Issue Transcript',
            )
                : const Icon(Icons.pending, color: Colors.orange),
          ),
        );
      },
    );
  }

  Widget _buildTranscriptList(TranscriptController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.transcripts.length,
      itemBuilder: (context, index) {
        final transcript = controller.transcripts[index];
        return CustomCard(
          child: ListTile(
            title: Text(transcript.studentName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Semester: ${transcript.semester}'),
                Text('Issued Date: ${transcript.issueDate}'),
                Text('Transcript ID: ${transcript.transcriptId}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.download, color: Colors.teal),
              onPressed: () {
                // Add download functionality here
              },
            ),
          ),
        );
      },
    );
  }

  void _showGenerateChallanDialog(
      BuildContext context, TranscriptController controller, int index) {
    final request = controller.requests[index];
    final amountController = TextEditingController(text: '1000'); // Default amount
    final dueDateController = TextEditingController(
        text: DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Generate Challan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Student: ${request.studentName}'),
              const SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (Rs.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 14)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dueDateController.text = picked.toString().split(' ')[0];
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
                controller.generateChallan(
                  index,
                  double.parse(amountController.text),
                  dueDateController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Challan generated successfully!'),
                  ),
                );
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }
}