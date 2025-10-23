import 'package:flutter/material.dart';
import 'issue_detail_screen.dart';

class IssueListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> issues;

  const IssueListScreen({super.key, required this.issues});

  @override
  State<IssueListScreen> createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
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

  void _navigateToDetailScreen(Map<String, dynamic> issue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IssueDetailScreen(issueData: issue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.issues.length,
      itemBuilder: (context, index) {
        return _buildIssueTile(widget.issues[index]);
      },
    );
  }

  Widget _buildIssueTile(Map<String, dynamic> issue) {
    final status = issue['status'] as String? ?? 'New';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _navigateToDetailScreen(issue),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      issue['image'] ?? 'assets/images/placeholder.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.broken_image)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue['title'] as String? ?? 'No Title',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Location: ${issue['location']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Date: ${issue['date']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
