import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poll.dart';
import '../providers/polls_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polls = ref.watch(pollsProvider);
    final totalPolls = polls.length;
    final activePolls = polls.where((p) => p.status == PollStatus.live).length;
    final totalVotes = polls.fold<int>(0, (sum, p) => sum + p.totalVotes);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statBox('Toplam Anket', totalPolls.toString()),
                  _statBox('Aktif Anket', activePolls.toString()),
                  _statBox('Toplam Oy', totalVotes.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Anketler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          ...polls.map((poll) => Card(
            child: ListTile(
              title: Text(poll.title),
              subtitle: Text('Durum: ${poll.status.displayName}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (poll.status == PollStatus.draft)
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      tooltip: 'Başlat',
                      onPressed: () {
                        ref.read(pollsProvider.notifier).updatePoll(
                          poll.copyWith(status: PollStatus.live, startedAt: DateTime.now()),
                        );
                      },
                    ),
                  if (poll.status == PollStatus.live)
                    IconButton(
                      icon: const Icon(Icons.stop),
                      tooltip: 'Bitir',
                      onPressed: () {
                        ref.read(pollsProvider.notifier).updatePoll(
                          poll.copyWith(status: PollStatus.ended, endedAt: DateTime.now()),
                        );
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.archive),
                    tooltip: 'Arşivle',
                    onPressed: () {
                      ref.read(pollsProvider.notifier).archivePoll(poll.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Sil',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Anketi Sil'),
                          content: const Text('Bu anketi silmek istediğinize emin misiniz?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Vazgeç'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(pollsProvider.notifier).deletePoll(poll.id);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Sil'),
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
          const SizedBox(height: 32),
          const Text('Kullanıcı Yönetimi (Demo)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Card(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Kullanıcı yönetimi ve istatistikleri burada gösterilecek (demo amaçlı).'),
                  SizedBox(height: 8),
                  Text('Gerçek kullanıcı yönetimi için kimlik doğrulama entegrasyonu gereklidir.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
} 