import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poll.dart';
import '../providers/polls_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.onPollTap, required this.onCreatePoll, required this.onAdmin, required this.onProfile});

  final void Function(String pollId) onPollTap;
  final VoidCallback onCreatePoll;
  final VoidCallback onAdmin;
  final VoidCallback onProfile;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String searchQuery = '';
  String filterStatus = 'all';
  bool sortAsc = true;

  @override
  Widget build(BuildContext context) {
    final polls = ref.watch(pollsProvider);
    List<Poll> filteredPolls = polls;
    if (filterStatus != 'all') {
      filteredPolls = filteredPolls.where((p) => p.status.name == filterStatus).toList();
    }
    if (searchQuery.isNotEmpty) {
      filteredPolls = filteredPolls.where((p) => p.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    filteredPolls.sort((a, b) => sortAsc ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
    final livePolls = filteredPolls.where((p) => p.status == PollStatus.live).toList();
    final draftPolls = filteredPolls.where((p) => p.status == PollStatus.draft).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Polls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: widget.onProfile,
            tooltip: 'Profilim',
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: widget.onAdmin,
            tooltip: 'Admin Dashboard',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Anket ara...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: filterStatus,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Tümü')),
                    DropdownMenuItem(value: 'live', child: Text('Aktif')),
                    DropdownMenuItem(value: 'draft', child: Text('Taslak')),
                    DropdownMenuItem(value: 'ended', child: Text('Bitti')),
                    DropdownMenuItem(value: 'archived', child: Text('Arşiv')),
                  ],
                  onChanged: (val) => setState(() => filterStatus = val ?? 'all'),
                ),
                IconButton(
                  icon: Icon(sortAsc ? Icons.arrow_upward : Icons.arrow_downward),
                  tooltip: 'Sırala',
                  onPressed: () => setState(() => sortAsc = !sortAsc),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (livePolls.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Text('Aktif Anketler', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...livePolls.map((poll) => Card(
                    child: ListTile(
                      title: Text(poll.title),
                      subtitle: Text('Status: ${poll.status.displayName}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => widget.onPollTap(poll.id),
                            child: Text(poll.status == PollStatus.live ? 'Join' : 'View Results'),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            tooltip: 'Bitir',
                            onPressed: poll.status == PollStatus.live
                                ? () {
                                    ref.read(pollsProvider.notifier).updatePoll(
                                      poll.copyWith(
                                        status: PollStatus.ended,
                                        endedAt: DateTime.now(),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.archive),
                            tooltip: 'Archive',
                            onPressed: () {
                              ref.read(pollsProvider.notifier).archivePoll(poll.id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () async {
                              final result = await showDialog<Map<String, String>>(
                                context: context,
                                builder: (context) {
                                  final titleController = TextEditingController(text: poll.title);
                                  final questionController = TextEditingController(text: poll.question);
                                  return AlertDialog(
                                    title: const Text('Edit Poll'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: const InputDecoration(labelText: 'Title'),
                                        ),
                                        TextField(
                                          controller: questionController,
                                          decoration: const InputDecoration(labelText: 'Question'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop({
                                            'title': titleController.text,
                                            'question': questionController.text,
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (result != null) {
                                ref.read(pollsProvider.notifier).updatePoll(
                                  poll.copyWith(
                                    title: result['title'],
                                    question: result['question'],
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Poll'),
                                  content: const Text('Are you sure you want to delete this poll?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.read(pollsProvider.notifier).deletePoll(poll.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
                if (draftPolls.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Text('Taslak Anketler', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...draftPolls.map((poll) => Card(
                    child: ListTile(
                      title: Text(poll.title),
                      subtitle: Text('Status: ${poll.status.displayName}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            tooltip: 'Başlat',
                            onPressed: () {
                              ref.read(pollsProvider.notifier).updatePoll(
                                poll.copyWith(
                                  status: PollStatus.live,
                                  startedAt: DateTime.now(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () async {
                              final result = await showDialog<Map<String, String>>(
                                context: context,
                                builder: (context) {
                                  final titleController = TextEditingController(text: poll.title);
                                  final questionController = TextEditingController(text: poll.question);
                                  return AlertDialog(
                                    title: const Text('Edit Poll'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: const InputDecoration(labelText: 'Title'),
                                        ),
                                        TextField(
                                          controller: questionController,
                                          decoration: const InputDecoration(labelText: 'Question'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop({
                                            'title': titleController.text,
                                            'question': questionController.text,
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (result != null) {
                                ref.read(pollsProvider.notifier).updatePoll(
                                  poll.copyWith(
                                    title: result['title'],
                                    question: result['question'],
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Poll'),
                                  content: const Text('Are you sure you want to delete this poll?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.read(pollsProvider.notifier).deletePoll(poll.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onCreatePoll,
        child: const Icon(Icons.add),
        tooltip: 'Create Poll',
      ),
    );
  }
} 