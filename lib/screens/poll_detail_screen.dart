import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/poll.dart';
import '../models/vote.dart';
import '../providers/polls_provider.dart';
import '../services/vote_service.dart';

class PollDetailScreen extends ConsumerStatefulWidget {
  const PollDetailScreen({super.key, required this.pollId, required this.onVote});

  final String pollId;
  final void Function(List<int> selectedOptions) onVote;

  @override
  ConsumerState<PollDetailScreen> createState() => _PollDetailScreenState();
}

class _PollDetailScreenState extends ConsumerState<PollDetailScreen> {
  List<int> selectedOptions = [];
  bool hasVoted = false;

  @override
  void initState() {
    super.initState();
    // Check if user has already voted
    final votes = ref.read(votesByPollIdProvider(widget.pollId));
    final currentUser = ref.read(currentUserProvider);
    hasVoted = votes.any((vote) => vote.userId == currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    final poll = ref.watch(pollByIdProvider(widget.pollId));
    
    if (poll == null) {
      return const Scaffold(
        body: Center(child: Text('Poll not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vote')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(poll.question, 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            Text('Status: ${poll.status.displayName}', 
              style: TextStyle(
                fontSize: 16, 
                color: poll.status.isActive ? Colors.green : Colors.grey
              )
            ),
            const SizedBox(height: 24),
            
            if (poll.allowMultipleChoices)
              ...List.generate(poll.options.length, (i) => CheckboxListTile(
                value: selectedOptions.contains(i),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      selectedOptions.add(i);
                    } else {
                      selectedOptions.remove(i);
                    }
                  });
                },
                title: Text(poll.options[i].text),
                subtitle: Text('${poll.options[i].voteCount} votes'),
              ))
            else
              ...List.generate(poll.options.length, (i) => RadioListTile<int>(
                value: i,
                groupValue: selectedOptions.isNotEmpty ? selectedOptions.first : null,
                onChanged: (val) {
                  setState(() {
                    if (val != null) {
                      selectedOptions = [val];
                    }
                  });
                },
                title: Text(poll.options[i].text),
                subtitle: Text('${poll.options[i].voteCount} votes'),
              )),
            
            const Spacer(),
            
            if (hasVoted)
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You have already voted!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            else if (!poll.status.canVote)
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'This poll is not active',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedOptions.isNotEmpty ? () => _submitVote(poll) : null,
                  child: const Text('Submit Vote'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submitVote(Poll poll) async {
    final voteService = VoteService();
    // Create a new vote
    final currentUser = ref.read(currentUserProvider);
    final newVote = Vote(
      id: const Uuid().v4(),
      pollId: poll.id,
      userId: currentUser.id,
      username: currentUser.username,
      selectedOptionIds: selectedOptions.map((i) => poll.options[i].id).toList(),
      createdAt: DateTime.now(),
    );

    // Simüle edilmiş API isteği
    final success = await voteService.submitVote(newVote);
    if (!success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vote failed! Please try again.')),
        );
      }
      return;
    }

    // Add vote to provider
    ref.read(votesProvider.notifier).update((votes) => [...votes, newVote]);
    // Update poll vote counts
    final updatedOptions = poll.options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      if (selectedOptions.contains(index)) {
        return option.copyWith(voteCount: option.voteCount + 1);
      }
      return option;
    }).toList();

    final updatedPoll = poll.copyWith(
      options: updatedOptions,
      totalVotes: poll.totalVotes + selectedOptions.length,
    );

    // Update poll in provider
    ref.read(pollsProvider.notifier).update((polls) {
      return polls.map((p) => p.id == poll.id ? updatedPoll : p).toList();
    });

    setState(() {
      hasVoted = true;
    });

    // Navigate to results
    widget.onVote(selectedOptions);
  }
} 