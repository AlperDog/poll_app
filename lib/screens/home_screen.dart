import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poll.dart';
import '../providers/polls_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.onPollTap, required this.onCreatePoll, required this.onAdmin});

  final void Function(String pollId) onPollTap;
  final VoidCallback onCreatePoll;
  final VoidCallback onAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polls = ref.watch(pollsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Polls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: onAdmin,
            tooltip: 'Admin Dashboard',
          ),
        ],
      ),
      body: ListView(
        children: [
          ...polls.map((poll) => Card(
                child: ListTile(
                  title: Text(poll.title),
                  subtitle: Text('Status: ${poll.status.displayName}'),
                  trailing: ElevatedButton(
                    onPressed: () => onPollTap(poll.id),
                    child: Text(poll.status == PollStatus.live ? 'Join' : 'View Results'),
                  ),
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreatePoll,
        child: const Icon(Icons.add),
        tooltip: 'Create Poll',
      ),
    );
  }
} 