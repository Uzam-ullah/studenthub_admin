import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/enrollment_controller.dart';
import '../models/enrollment_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_card.dart';

class EnrollmentScreen extends StatelessWidget {
  const EnrollmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EnrollmentController>(context);
    return DefaultTabController(
      length: 3, // Added new tab for course management
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Enrollment Management'),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Course Catalog'),
                Tab(text: 'Current Enrollments'),
                Tab(text: 'Pending Requests'),
              ],
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCourseCatalog(controller),
                  _buildEnrollmentList(controller),
                  _buildRequestList(controller),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddCourseDialog(context, controller),
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCourseCatalog(EnrollmentController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.availableCourses.length,
      itemBuilder: (context, index) {
        final course = controller.availableCourses[index];
        return CustomCard(
          child: ListTile(
            title: Text(course.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Code: ${course.code}'),
                Text('Credit Hours: ${course.creditHours}'),
                Text('Semester: ${course.semester}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => controller.removeCourse(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnrollmentList(EnrollmentController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.enrollments.length,
      itemBuilder: (context, index) {
        final enrollment = controller.enrollments[index];
        return CustomCard(
          child: ListTile(
            title: Text(enrollment.courseName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student: ${enrollment.studentName}'),
                Text('ID: ${enrollment.studentId}'),
                Text('Semester: ${enrollment.semester}'),
                Text('Status: ${enrollment.status}'),
              ],
            ),
            trailing: enrollment.status == 'Active'
                ? IconButton(
              icon: const Icon(Icons.person_remove, color: Colors.orange),
              onPressed: () => _showDropConfirmation(context, controller, index),
            )
                : const Icon(Icons.history, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildRequestList(EnrollmentController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.pendingRequests.length,
      itemBuilder: (context, index) {
        final request = controller.pendingRequests[index];
        return CustomCard(
          child: ListTile(
            title: Text(request.type == 'add'
                ? 'Add: ${request.courseName}'
                : 'Drop: ${request.courseName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student: ${request.studentName} (${request.studentId})'),
                Text('Credit Hours: ${request.creditHours}'),
                Text('Current Load: ${request.currentCreditHours}/${request.maxCreditHours}'),
                if (request.reason != null)
                  Text('Reason: ${request.reason}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    if (controller.validateRequest(index)) {
                      controller.approveRequest(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request approved')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Credit limit exceeded')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    _showRejectDialog(context, controller, index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddCourseDialog(BuildContext context, EnrollmentController controller) {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final creditController = TextEditingController();
    final semesterController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: creditController,
                decoration: const InputDecoration(
                  labelText: 'Credit Hours',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: semesterController,
                decoration: const InputDecoration(
                  labelText: 'Semester',
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
                if (codeController.text.isNotEmpty &&
                    nameController.text.isNotEmpty &&
                    creditController.text.isNotEmpty &&
                    semesterController.text.isNotEmpty) {
                  controller.addCourse(
                    Course(
                      code: codeController.text,
                      name: nameController.text,
                      creditHours: int.parse(creditController.text),
                      semester: semesterController.text,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDropConfirmation(BuildContext context, EnrollmentController controller, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Drop'),
          content: const Text('Are you sure you want to drop this enrollment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.dropEnrollment(index);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enrollment dropped')),
                );
              },
              child: const Text('Drop'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context, EnrollmentController controller, int index) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter rejection reason:'),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
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
                controller.rejectRequest(index, reasonController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request rejected')),
                );
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }
}