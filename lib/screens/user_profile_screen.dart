import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poll.dart';
import '../models/vote.dart';
import '../providers/polls_provider.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final polls = ref.watch(pollsProvider);
    final votes = ref.watch(votesProvider);
    final userVotes = votes.where((v) => v.userId == user.id).toList();
    final participatedPolls = polls.where((p) => userVotes.any((v) => v.pollId == p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profilim')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kullanıcı: ${user.username}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Katıldığı Anketler: ${participatedPolls.length}', style: const TextStyle(fontSize: 16)),
            Text('Toplam Oy: ${userVotes.length}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text('Anket Geçmişi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: participatedPolls.isEmpty
                  ? const Text('Henüz hiçbir ankete katılmadınız.')
                  : ListView.builder(
                      itemCount: participatedPolls.length,
                      itemBuilder: (context, i) {
                        final poll = participatedPolls[i];
                        final vote = userVotes.firstWhere((v) => v.pollId == poll.id);
                        return Card(
                          child: ListTile(
                            title: Text(poll.title),
                            subtitle: Text('Durum: ${poll.status.displayName}\nOyladığınız seçenek(ler): ${vote.selectedOptionIds.join(", ")}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 