import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder poll list
    final polls = [
      {'id': '1', 'title': 'Favorite Color?', 'status': 'Live'},
      {'id': '2', 'title': 'Best Programming Language?', 'status': 'Ended'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        children: polls.map((poll) => Card(
          child: ListTile(
            title: Text(poll['title']!),
            subtitle: Text('Status: ${poll['status']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(poll['status'] == 'Live' ? 'Stop' : 'Start'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
} 