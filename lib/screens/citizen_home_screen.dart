import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'report_issue_screen.dart';
import 'admin_login_screen.dart';
import 'issue_list_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;

  final String _adminUsername = 'admin';
  final String _adminPassword = 'admin123';

  List<Map<String, dynamic>> issues = [
    {
      'title': 'Pothole',
      'location': 'Devoto Freeway',
      'date': 'July 23, 2025 9:45 AM',
      'status': 'New',
      'image': 'assets/images/pothole.jpg',
    },
    {
      'title': 'Broken Street Light',
      'location': '51 St Road',
      'date': 'July 15, 2025 11:00 PM',
      'status': 'In Progress',
      'image': 'assets/images/street_light.jpg',
    },
    {
      'title': 'Garbage Overflow',
      'location': 'Aug 1, 2025 8:30 AM',
      'status': 'In Progress',
      'image': 'assets/images/garbage.jpg',
    },
    {
      'title': 'Noise Complaint',
      'location': '21 Riverside',
      'date': 'Sep 5, 2025 3:00 PM',
      'status': 'Resolved',
      'image': 'assets/images/noise.jpg',
    },
    {
      'title': 'Water Leak',
      'location': 'Main St.',
      'date': 'Oct 1, 2025 2:30 PM',
      'status': 'New',
      'image': 'assets/images/water_leak_thumb.jpg',
    },
  ];

  void _handleLoginAttempt(String username, String password) {
    if (username == _adminUsername && password == _adminPassword) {
      setState(() {
        _isLoggedIn = true;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Admin Login Successful!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid Credentials')));
    }
  }

  void _adminLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _changeIssueStatus(Map<String, dynamic> issue, String newStatus) {
    final index = issues.indexOf(issue);
    if (index != -1) {
      setState(() {
        issues[index] = {...issues[index], 'status': newStatus};
        final updatedIssue = issues.removeAt(index);
        issues.insert(0, updatedIssue);
      });
    }
  }

  void _deleteIssue(Map<String, dynamic> issue) {
    setState(() {
      issues.remove(issue);
    });
  }

  void _handleReportNewIssue() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportIssueScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        issues.insert(0, result);
      });
    }
  }

  void _navigateToAdminLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AdminLoginScreen(onLoginAttempt: _handleLoginAttempt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    Widget? listFAB;

    final Color adminAppBarColor = Colors.blue[800]!;
    final Color citizenAppBarColor = Colors.blue[700]!;

    if (_isLoggedIn) {
      currentView = AdminDashboardScreen(
        issues: issues,
        onStatusChange: _changeIssueStatus,
        onDeleteIssue: _deleteIssue,
      );
    } else {
      currentView = IssueListScreen(issues: issues);

      listFAB = FloatingActionButton.extended(
        onPressed: _handleReportNewIssue,
        label: const Text('Report New Issue'),
        icon: const Icon(Icons.add_location_alt),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CityZen Community App'),
        backgroundColor: _isLoggedIn ? adminAppBarColor : citizenAppBarColor,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoggedIn)
            TextButton.icon(
              onPressed: _adminLogout,
              icon: const Icon(Icons.logout, color: Colors.white, size: 20),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            TextButton.icon(
              onPressed: _navigateToAdminLogin,
              icon: const Icon(Icons.security, color: Colors.white, size: 20),
              label: const Text(
                'Admin Portal',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: currentView,
      floatingActionButton: listFAB,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
