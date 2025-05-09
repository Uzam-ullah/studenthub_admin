import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/enrollment_controller.dart';
import '../controllers/fee_controller.dart';
import '../controllers/complaint_controller.dart';
import '../controllers/transcript_controller.dart';
import '../controllers/notification_controller.dart';
import 'enrollment_screen.dart';
import 'fee_screen.dart';
import 'complaint_screen.dart';
import 'transcript_screen.dart';
import 'notification_screen.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Admin Dashboard'),
      drawer: const CustomDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildDashboardItem(
            context,
            Icons.school,
            'Enrollment',
            const EnrollmentScreen(),
          ),
          _buildDashboardItem(
            context,
            Icons.payment,
            'Fee Management',
            const FeeScreen(),
          ),
          _buildDashboardItem(
            context,
            Icons.report_problem,
            'Complaints',
            const ComplaintScreen(),
          ),
          _buildDashboardItem(
            context,
            Icons.description,
            'Transcripts',
            const TranscriptScreen(),
          ),
          _buildDashboardItem(
            context,
            Icons.notifications,
            'Notifications',
            const NotificationScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
      BuildContext context, IconData icon, String title, Widget screen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}