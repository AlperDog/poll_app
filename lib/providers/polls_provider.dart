import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poll_app/models/poll.dart';
import 'package:poll_app/models/user.dart';
import 'package:poll_app/models/vote.dart';
import 'package:poll_app/models/mock_data.dart';
import 'package:poll_app/services/websocket_service.dart';

final pollsProvider = StateProvider<List<Poll>>((ref) => mockPolls);
final currentUserProvider = StateProvider<User>((ref) => mockUser);

// Provider for the currently selected poll
final selectedPollProvider = StateProvider<Poll?>((ref) => null);

// Provider for votes
final votesProvider = StateProvider<List<Vote>>((ref) => mockVotes);

// Provider to get a specific poll by ID
final pollByIdProvider = Provider.family<Poll?, String>((ref, pollId) {
  final polls = ref.watch(pollsProvider);
  return polls.firstWhere((poll) => poll.id == pollId);
});

// Provider to get votes for a specific poll
final votesByPollIdProvider = Provider.family<List<Vote>, String>((ref, pollId) {
  final votes = ref.watch(votesProvider);
  return votes.where((vote) => vote.pollId == pollId).toList();
});

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  // Use a public echo server for demo; replace with your backend URL
  return WebSocketService('wss://echo.websocket.events');
});

final webSocketStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final ws = ref.watch(webSocketServiceProvider);
  return ws.connect();
}); 