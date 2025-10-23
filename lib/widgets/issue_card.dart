import 'package:flutter/material.dart';

class CommunityCommentsScreen extends StatelessWidget {
  final Map<String, dynamic> issueData;

  const CommunityCommentsScreen({super.key, required this.issueData});

  final List<Map<String, dynamic>> mockComments = const [
    {
      'user': 'Rafael C.',
      'time': '2 hours ago',
      'text': 'This has been a problem for days. When will it be fixed?',
      'isAdmin': false,
    },
    {
      'user': 'City Official',
      'time': 'Yesterday',
      'text':
          'Report received. We expect this issue to be resolved within 48 hours.',
      'isAdmin': true,
    },
    {
      'user': 'John Mark J.',
      'time': 'This morning',
      'text': 'It looks like they started work on it this morning!',
      'isAdmin': false,
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    final status = issueData['status'] as String? ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Comments'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildIssueHeader(context, status),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              itemCount: mockComments.length,
              itemBuilder: (context, index) {
                return _buildCommentTile(mockComments[index]);
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildIssueHeader(BuildContext context, String status) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                issueData['title'] as String? ?? 'No Title',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Status: $status | ${issueData['location'] as String? ?? 'Unknown Location'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(Map<String, dynamic> comment) {
    bool isAdmin = comment['isAdmin'] as bool? ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isAdmin ? Colors.blue[100] : Colors.grey[300],
            child: Text(
              comment['user']![0].toUpperCase(),
              style: TextStyle(
                color: isAdmin ? Colors.blue[700] : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['user']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isAdmin ? Colors.blue[800] : Colors.black,
                      ),
                    ),
                    if (isAdmin)
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Icon(
                          Icons.verified_user,
                          size: 14,
                          color: Colors.blue[800],
                        ),
                      ),
                    const Spacer(),
                    Text(
                      comment['time']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment['text']!, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[100],
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (text) {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
