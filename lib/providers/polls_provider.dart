import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poll_app/models/poll.dart';
import 'package:poll_app/models/user.dart';
import 'package:poll_app/models/vote.dart';
import 'package:poll_app/models/mock_data.dart';
import 'package:poll_app/services/websocket_service.dart';

class PollsNotifier extends StateNotifier<List<Poll>> {
  // TODO: Burada mockPolls yerine backend'den veri çekilecek.
  PollsNotifier() : super([]); // Başlangıçta boş, backend ile doldurulacak

  void addPoll(Poll poll) {
    state = [poll, ...state];
  }

  void deletePoll(String pollId) {
    state = state.where((poll) => poll.id != pollId).toList();
  }

  void updatePoll(Poll updatedPoll) {
    state = state.map((poll) => poll.id == updatedPoll.id ? updatedPoll : poll).toList();
  }

  void archivePoll(String pollId) {
    state = state.map((poll) =>
      poll.id == pollId ? poll.copyWith(status: PollStatus.archived) : poll
    ).toList();
  }
}

final pollsProvider = StateNotifierProvider<PollsNotifier, List<Poll>>((ref) => PollsNotifier());
// TODO: Burada mockUser yerine backend'den veya kimlik doğrulama ile kullanıcı alınacak.
final currentUserProvider = StateProvider<User>((ref) => User(id: '', username: 'DemoUser'));

// Provider for the currently selected poll
final selectedPollProvider = StateProvider<Poll?>((ref) => null);

// TODO: Burada mockVotes yerine backend'den oylar alınacak.
final votesProvider = StateProvider<List<Vote>>((ref) => []);

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