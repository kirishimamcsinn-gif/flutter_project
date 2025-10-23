import 'package:flutter/material.dart';

// 1. The public Widget class (Must extend StatefulWidget)
class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

// 2. The private State class (Holds the build method and helper functions)
class _AdminReportScreenState extends State<AdminReportScreen> {
  // Add a simple state variable to track the dropdown value
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Generate Issue Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const Divider(height: 30),

          // --- Report Filter: Issue Status ---
          _buildFilterDropdown(
            title: 'Filter by Status',
            items: ['All', 'New', 'In Progress', 'Resolved'],
            initialValue: _selectedStatus,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
                print('Status Filter Selected: $value');
              }
            },
          ),
          const SizedBox(height: 20),

          // --- Report Filter: Date Range ---
          _buildDateRangePicker(context),
          const SizedBox(height: 30),

          // --- Generate Button ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement actual report generation/download logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Exporting report for status: $_selectedStatus',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text(
                'Export Filtered Issues', // Updated label (Option 3)
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // --- Report Preview/List Area (Placeholder for generated data) ---
          Center(
            child: Text(
              'Generated Report Preview Area',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method now belongs to the State class
  Widget _buildFilterDropdown({
    required String title,
    required List<String> items,
    required String initialValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: initialValue,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method now belongs to the State class
  Widget _buildDateRangePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: const Text('Pick Start and End Dates'),
          onPressed: () async {
            DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              print('Selected range: ${picked.start} to ${picked.end}');
              // TODO: Update state to show selected dates
            }
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            foregroundColor: Colors.blue[700],
            side: BorderSide(color: Colors.grey.shade400),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
