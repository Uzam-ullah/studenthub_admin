import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Enrollment'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/enrollment');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Fee Management'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/fee');
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Complaints'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/complaints');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Transcripts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/transcripts');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
    );
  }
}