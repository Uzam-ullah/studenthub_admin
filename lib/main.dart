import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/enrollment_controller.dart';
import 'controllers/fee_controller.dart';
import 'controllers/complaint_controller.dart';
import 'controllers/transcript_controller.dart';
import 'controllers/notification_controller.dart';
import 'screens/admin_dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EnrollmentController()),
        ChangeNotifierProvider(create: (_) => FeeController()),
        ChangeNotifierProvider(create: (_) => ComplaintController()),
        ChangeNotifierProvider(create: (_) => TranscriptController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const AdminDashboard(),
    );
  }
}