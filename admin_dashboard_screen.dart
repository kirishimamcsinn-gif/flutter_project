import 'package:flutter/material.dart';
// 1. ADD THE IMPORT FOR THE NEW SCREEN
import 'admin_report_screen.dart';

typedef StatusChanger =
    void Function(Map<String, dynamic> issue, String newStatus);
typedef IssueDeleter = void Function(Map<String, dynamic> issue);

class AdminDashboardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> issues;
  final StatusChanger onStatusChange;
  final IssueDeleter onDeleteIssue;

  const AdminDashboardScreen({
    super.key,
    required this.issues,
    required this.onStatusChange,
    required this.onDeleteIssue,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic>? _selectedIssue;

  @override
  void initState() {
    super.initState();
    if (widget.issues.isNotEmpty) {
      _selectedIssue = widget.issues.first;
    }
  }

  void _selectIssue(Map<String, dynamic> issue) {
    setState(() {
      _selectedIssue = issue;
    });
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'New':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _handleStatusChange(Map<String, dynamic> issue, String newStatus) {
    widget.onStatusChange(issue, newStatus);
    if (_selectedIssue != null && _selectedIssue!['title'] == issue['title']) {
      setState(() {
        _selectedIssue = {...issue, 'status': newStatus};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const List<String> tabs = ['Dashboard', 'Report', 'Map View', 'Analytics'];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Admin Portal for City Officers'),
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: tabs.map((name) => Tab(text: name)).toList(),
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildDashboardView(),
            // 2. REPLACED PLACEHOLDER WITH AdminReportScreen
            const AdminReportScreen(),
            _buildMapViewPlaceholder(),
            const Center(child: Text('Data Analytics View (Placeholder)')),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMapPlaceholder(),
          const SizedBox(height: 15),
          const Text(
            'Issues',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildIssuesTable(),
          const SizedBox(height: 15),
          const Text(
            'Selected Report Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildDetailsPanel(),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 50, color: Colors.blueGrey),
            Text(
              'Map Rendering Placeholder',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapViewPlaceholder() {
    return const Center(child: Text('Full Map View (Placeholder)'));
  }

  Widget _buildIssuesTable() {
    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.issues.length,
        itemBuilder: (context, index) {
          final issue = widget.issues[index];
          final isSelected = issue['title'] == _selectedIssue?['title'];
          final status = issue['status'] as String? ?? 'New';

          return ListTile(
            onTap: () => _selectIssue(issue),
            selected: isSelected,
            selectedTileColor: Colors.blue[50],
            title: Text(
              issue['title'] as String? ?? 'No Title',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailsPanel() {
    if (_selectedIssue == null) {
      return const Center(child: Text('Select an issue to view details.'));
    }

    final issue = _selectedIssue!;
    final status = issue['status'] as String? ?? 'New';

    final String reportedBy = 'Rafael Cervantes';
    final String assignedTo = 'Public Works';
    final String description = 'Large pothole near intersection';

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                issue['image'] ?? 'assets/images/pothole.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Center(
                      child: Image.asset('assets/images/placeholder_error.png'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text('Reported by: $reportedBy'),
            Text('Status: $status'),
            Text('Assigned: $assignedTo'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<String>(
                  onSelected: (String action) {
                    if (action == 'Delete') {
                      widget.onDeleteIssue(issue);
                      setState(() {
                        _selectedIssue = null;
                      });
                    } else {
                      _handleStatusChange(issue, action);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'New',
                          child: Text('Set to New'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'In Progress',
                          child: Text('Set to In Progress'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Resolved',
                          child: Text('Set to Resolved'),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(
                            'Delete Issue',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Actions',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
