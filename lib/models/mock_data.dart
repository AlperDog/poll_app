import 'package:poll_app/models/poll.dart';
import 'package:poll_app/models/user.dart';
import 'package:poll_app/models/vote.dart';

final mockUser = User(
  id: 'user1',
  username: 'Guest',
  isGuest: true,
  createdAt: DateTime.now(),
);

final mockPolls = [
  Poll(
    id: 'poll1',
    title: 'Favorite Color?',
    question: 'What is your favorite color?',
    options: [
      PollOption(id: 'red', text: 'Red', voteCount: 5, percentage: 0.28),
      PollOption(id: 'blue', text: 'Blue', voteCount: 3, percentage: 0.17),
      PollOption(id: 'green', text: 'Green', voteCount: 8, percentage: 0.44),
      PollOption(id: 'yellow', text: 'Yellow', voteCount: 2, percentage: 0.11),
    ],
    status: PollStatus.live,
    allowMultipleChoices: false,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    startedAt: DateTime.now().subtract(const Duration(minutes: 50)),
    totalVotes: 18,
    participantCount: 10,
  ),
  Poll(
    id: 'poll2',
    title: 'Best Programming Language?',
    question: 'Which programming language do you like most?',
    options: [
      PollOption(id: 'dart', text: 'Dart', voteCount: 4, percentage: 0.4),
      PollOption(id: 'python', text: 'Python', voteCount: 3, percentage: 0.3),
      PollOption(id: 'go', text: 'Go', voteCount: 2, percentage: 0.2),
      PollOption(id: 'js', text: 'JavaScript', voteCount: 1, percentage: 0.1),
    ],
    status: PollStatus.ended,
    allowMultipleChoices: true,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    startedAt: DateTime.now().subtract(const Duration(hours: 23)),
    endedAt: DateTime.now().subtract(const Duration(hours: 22)),
    totalVotes: 10,
    participantCount: 7,
  ),
];

final mockVotes = [
  Vote(
    id: 'vote1',
    pollId: 'poll1',
    userId: 'user1',
    username: 'Guest',
    selectedOptionIds: ['red'],
    createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
]; 