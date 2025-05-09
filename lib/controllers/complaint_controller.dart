import 'package:flutter/material.dart';
import '../models/complaint_model.dart';

class ComplaintController with ChangeNotifier {
  List<Complaint> _complaints = [
    Complaint(
      studentName: 'Ali Khan',
      title: 'Library Book Not Available',
      description: 'The required textbook for CS-101 is not available in the library',
      date: '2023-10-15',
    ),
    Complaint(
      studentName: 'Sara Ahmed',
      title: 'Classroom Temperature Issue',
      description: 'The AC in room B-12 is not working properly',
      date: '2023-10-16',
      resolved: true,
      response: 'The maintenance team has been notified and will fix it by tomorrow',
    ),
  ];

  List<Complaint> get complaints => _complaints;

  void addComplaint(Complaint complaint) {
    _complaints.insert(0, complaint); // Add to top of list
    notifyListeners();
  }

  void resolveComplaint(int index) {
    _complaints[index].resolved = true;
    notifyListeners();
  }

  void addResponse(int index, String response) {
    _complaints[index].response = response;
    _complaints[index].resolved = true;
    notifyListeners();
  }

  // For testing - toggle resolved status
  void toggleResolvedStatus(int index) {
    _complaints[index].resolved = !_complaints[index].resolved;
    notifyListeners();
  }
}