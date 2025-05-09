import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/complaint_controller.dart';
import '../models/complaint_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_card.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final TextEditingController _responseController = TextEditingController();
  int? _selectedComplaintIndex;

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ComplaintController>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Complaints'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.complaints.length,
              itemBuilder: (context, index) {
                final complaint = controller.complaints[index];
                return CustomCard(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          complaint.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: complaint.resolved
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(complaint.description),
                            const SizedBox(height: 8),
                            Text(
                              'From: ${complaint.studentName}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Date: ${complaint.date}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (complaint.resolved && complaint.response != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Admin Response:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[700],
                                    ),
                                  ),
                                  Text(complaint.response!),
                                ],
                              ),
                          ],
                        ),
                        trailing: complaint.resolved
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.reply, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  _selectedComplaintIndex = index;
                                });
                                _showResponseDialog(context, controller, index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.teal),
                              onPressed: () => controller.resolveComplaint(index),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedComplaintIndex == index && !complaint.resolved)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextField(
                            controller: _responseController,
                            decoration: InputDecoration(
                              hintText: 'Type your response...',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  if (_responseController.text.isNotEmpty) {
                                    controller.addResponse(
                                        index,
                                        _responseController.text
                                    );
                                    _responseController.clear();
                                    setState(() {
                                      _selectedComplaintIndex = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (controller.complaints.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No complaints found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddComplaintDialog(context, controller),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showResponseDialog(
      BuildContext context, ComplaintController controller, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Response'),
          content: TextField(
            controller: _responseController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter your response to the complaint...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_responseController.text.isNotEmpty) {
                  controller.addResponse(index, _responseController.text);
                  _responseController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showAddComplaintDialog(
      BuildContext context, ComplaintController controller) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final studentNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Complaint'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentNameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Complaint Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Complaint Description',
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
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    studentNameController.text.isNotEmpty) {
                  controller.addComplaint(
                    Complaint(
                      studentName: studentNameController.text,
                      title: titleController.text,
                      description: descriptionController.text,
                      date: DateTime.now().toString().split(' ')[0],
                      resolved: false,
                    ),
                  );
                  titleController.clear();
                  descriptionController.clear();
                  studentNameController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}