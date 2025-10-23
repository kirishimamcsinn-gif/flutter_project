import 'package:flutter/material.dart';
import 'community_comments_screen.dart';

class IssueDetailScreen extends StatelessWidget {
  final Map<String, dynamic> issueData;

  const IssueDetailScreen({super.key, required this.issueData});

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

  void _navigateToCommentsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityCommentsScreen(issueData: issueData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = issueData['status'] as String? ?? 'Unknown';
    final primaryColor = Colors.blue[700];

    return Scaffold(
      appBar: AppBar(
        title: Text(issueData['title'] as String? ?? 'Issue Details'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                issueData['image'] ?? 'assets/images/placeholder.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    issueData['title'] as String? ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              'Location: ${issueData['location'] as String? ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              'Reported: ${issueData['date'] as String? ?? 'Unknown Date'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () => _navigateToCommentsScreen(context),
              icon: const Icon(Icons.message),
              label: const Text('View Community Comments'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
