import 'package:flutter/material.dart';

class CommunityCommentsScreen extends StatefulWidget {
  final Map<String, dynamic> issueData;

  const CommunityCommentsScreen({super.key, required this.issueData});

  @override
  State<CommunityCommentsScreen> createState() =>
      _CommunityCommentsScreenState();
}

class _CommunityCommentsScreenState extends State<CommunityCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  List<Map<String, String>> comments = [
    {
      'user': 'Local Resident',
      'text':
          'I saw this pothole grow wider last week. It\'s a danger at night!',
      'date': 'Oct 20, 2025',
    },
    {
      'user': 'Community Watch',
      'text':
          'Reported to the Public Works department. Should be marked for repair soon.',
      'date': 'Oct 21, 2025',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final newCommentText = _commentController.text.trim();
    if (newCommentText.isNotEmpty) {
      setState(() {
        comments.insert(0, {
          'user': 'You (Citizen)',
          'text': newCommentText,
          'date': 'Now',
        });
        _commentController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  Widget _buildIssueDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0).copyWith(bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.issueData['title'] ?? 'Issue Title Missing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              const Icon(Icons.comment_outlined, color: Colors.blue),
            ],
          ),
          const Divider(height: 16),
          Text(
            widget.issueData['description'] ?? 'No description provided.',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                widget.issueData['location'] ?? 'Location Unknown',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(Map<String, String> comment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment['user']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: comment['user'] == 'You (Citizen)'
                      ? Colors.blue[700]
                      : Colors.black,
                ),
              ),
              Text(
                comment['date']!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment['text']!),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.issueData['title'] ?? 'Issue'} - Discussion'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F8FF), Color(0xFFFFFFFF)],
          ),
        ),
        child: Column(
          children: [
            // Display the main issue details card
            _buildIssueDetailsCard(),

            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Community Comments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: comments.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return _buildCommentTile(comments[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: _submitComment,
                    mini: true,
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
