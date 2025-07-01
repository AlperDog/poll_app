import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/poll.dart';
import '../providers/polls_provider.dart';

class LiveResultsScreen extends ConsumerWidget {
  const LiveResultsScreen({super.key, required this.pollId});

  final String pollId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poll = ref.watch(pollByIdProvider(pollId));
    final wsAsync = ref.watch(webSocketStreamProvider);

    wsAsync.whenData((message) {
      // Simulate backend: expect {type: 'vote_update', pollId: ..., optionId: ...}
      if (message['type'] == 'vote_update' && message['pollId'] == pollId) {
        final optionId = message['optionId'] as String?;
        if (optionId != null && poll != null) {
          final updatedOptions = poll.options.map((option) {
            if (option.id == optionId) {
              return option.copyWith(voteCount: option.voteCount + 1);
            }
            return option;
          }).toList();
          final updatedPoll = poll.copyWith(
            options: updatedOptions,
            totalVotes: poll.totalVotes + 1,
          );
          ref.read(pollsProvider.notifier).update((polls) {
            return polls.map((p) => p.id == poll.id ? updatedPoll : p).toList();
          });
          // Show a SnackBar for demo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Live update received!')),
          );
        }
      }
    });

    if (poll == null) {
      return const Scaffold(
        body: Center(child: Text('Poll not found')),
      );
    }

    // Extract data for charts
    final results = poll.options.map((option) => option.voteCount.toDouble()).toList();
    final options = poll.options.map((option) => option.text).toList();
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];
    
    return Scaffold(
      appBar: AppBar(title: const Text('Live Results')),
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
            
            // Bar Chart
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: results.isNotEmpty ? results.reduce((a, b) => a > b ? a : b) + 2 : 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= options.length) return const Text('');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              options[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    results.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: results[index],
                          color: colors[index % colors.length],
                          width: 40,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Pie Chart
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(enabled: false),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: List.generate(
                    results.length,
                    (index) => PieChartSectionData(
                      color: colors[index % colors.length],
                      value: results[index],
                      title: poll.totalVotes > 0 
                        ? '${((results[index] / poll.totalVotes) * 100).toStringAsFixed(1)}%'
                        : '0%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total votes: ${poll.totalVotes}', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 8),
                  Text('Participants: ${poll.participantCount}', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  if (poll.allowMultipleChoices) ...[
                    const SizedBox(height: 8),
                    const Text('Multiple choices allowed', 
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // WebSocket Status
            Row(
              children: [
                const Text('WebSocket: ', style: TextStyle(fontSize: 16)),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: poll.status.isActive ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  poll.status.isActive ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 16, 
                    color: poll.status.isActive ? Colors.green : Colors.grey
                  )
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Button to simulate a vote update for demo
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bolt),
                label: const Text('Simulate Live Vote Update'),
                onPressed: () {
                  // Simulate a vote update for the first option
                  ref.read(webSocketServiceProvider).simulateMessage({
                    'type': 'vote_update',
                    'pollId': pollId,
                    'optionId': poll.options.first.id,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 