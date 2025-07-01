import 'package:json_annotation/json_annotation.dart';

part 'vote.g.dart';

@JsonSerializable()
class Vote {
  final String id;
  final String pollId;
  final String? userId;
  final String? username;
  final List<String> selectedOptionIds;
  final DateTime createdAt;
  final String? sessionId;

  const Vote({
    required this.id,
    required this.pollId,
    this.userId,
    this.username,
    required this.selectedOptionIds,
    required this.createdAt,
    this.sessionId,
  });

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
  Map<String, dynamic> toJson() => _$VoteToJson(this);

  Vote copyWith({
    String? id,
    String? pollId,
    String? userId,
    String? username,
    List<String>? selectedOptionIds,
    DateTime? createdAt,
    String? sessionId,
  }) {
    return Vote(
      id: id ?? this.id,
      pollId: pollId ?? this.pollId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      createdAt: createdAt ?? this.createdAt,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  String toString() {
    return 'Vote(id: $id, pollId: $pollId, selectedOptions: $selectedOptionIds)';
  }
}

@JsonSerializable()
class VoteSubmission {
  final String pollId;
  final List<String> selectedOptionIds;
  final String? username;
  final String? sessionId;

  const VoteSubmission({
    required this.pollId,
    required this.selectedOptionIds,
    this.username,
    this.sessionId,
  });

  factory VoteSubmission.fromJson(Map<String, dynamic> json) => _$VoteSubmissionFromJson(json);
  Map<String, dynamic> toJson() => _$VoteSubmissionToJson(this);

  @override
  String toString() {
    return 'VoteSubmission(pollId: $pollId, selectedOptions: $selectedOptionIds)';
  }
} 